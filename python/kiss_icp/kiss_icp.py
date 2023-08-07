# MIT License
#
# Copyright (c) 2022 Ignacio Vizzo, Tiziano Guadagnino, Benedikt Mersch, Cyrill
# Stachniss.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import numpy as np

from kiss_icp.config import KISSConfig
from kiss_icp.deskew import get_motion_compensator
from kiss_icp.mapping import get_voxel_hash_map
from kiss_icp.preprocess import get_preprocessor
from kiss_icp.registration import register_frame
from kiss_icp.threshold import get_threshold_estimator
from kiss_icp.voxelization import voxel_down_sample
from typing import Optional
from pathlib import Path
from scipy.linalg import svd
import json
import utm
from scipy.spatial.transform import Rotation as R




class KissICP:
    def __init__(self, config: KISSConfig, local_map_path: Optional[Path] = None):
        self.poses = []
        self.config = config
        self.compensator = get_motion_compensator(config)
        self.adaptive_threshold = get_threshold_estimator(self.config)
        self.local_map = get_voxel_hash_map(self.config, local_map_path)
        self.preprocess = get_preprocessor(self.config)
        self.local_map_path = local_map_path

    def register_frame(self, frame, timestamps, gps_json_path=None, imu_json_path=None):
        # Apply motion compensation
        frame = self.compensator.deskew_scan(frame, self.poses, timestamps)

        # Preprocess the input cloud
        frame = self.preprocess(frame)

        # Voxelize
        source, frame_downsample = self.voxelize(frame)

        # Get motion prediction and adaptive_threshold
        sigma = self.get_adaptive_threshold()
        
        # Getting the initial guess from GPS & IMU
        initial_guess_gps_imu = self.initial_tf_from_gps(gps_json_path, imu_json_path)
        
        # Extract rotation component
        R = initial_guess_gps_imu[:3, :3]

        # Orthogonalize R
        R_ortho = self.orthogonalize_matrix(R)

        # Replace the rotation component with the orthogonalized matrix
        initial_guess_gps_imu[:3, :3] = R_ortho

        # Compute initial_guess for ICP
        if not gps_json_path and not imu_json_path:
            prediction = self.get_prediction_model()
            last_pose = self.poses[-1] if self.poses else initial_guess_gps_imu
            initial_guess = last_pose @ prediction
        else:
            initial_guess = initial_guess_gps_imu

        

        # Run ICP
        new_pose = register_frame(
            points=source,
            voxel_map=self.local_map,
            initial_guess=initial_guess,
            max_correspondance_distance=3 * sigma,
            kernel=sigma / 3,
        )

        self.adaptive_threshold.update_model_deviation(np.linalg.inv(initial_guess) @ new_pose)
        if not self.local_map_path:
            self.local_map.update(frame_downsample, new_pose)
        self.poses.append(new_pose)
        return frame, source

    def voxelize(self, iframe):
        frame_downsample = voxel_down_sample(iframe, self.config.mapping.voxel_size * 0.5)
        source = voxel_down_sample(frame_downsample, self.config.mapping.voxel_size * 1.5)
        return source, frame_downsample

    def get_adaptive_threshold(self):
        return (
            self.config.adaptive_threshold.initial_threshold
            if not self.has_moved()
            else self.adaptive_threshold.get_threshold()
        )

    def get_prediction_model(self):
        if len(self.poses) < 2:
            return np.eye(4)
        return np.linalg.inv(self.poses[-2]) @ self.poses[-1]

    def has_moved(self):
        if len(self.poses) < 1:
            return False
        compute_motion = lambda T1, T2: np.linalg.norm((np.linalg.inv(T1) @ T2)[:3, -1])
        motion = compute_motion(self.poses[0], self.poses[-1])
    
    

    def orthogonalize_matrix(self, mat):
        U, S, Vt = svd(mat)
        return U @ Vt
    

    # Create a function to read GPS data and generate initial transformation matrix
    def initial_tf_from_gps(self, gps_path, imu_path):

        float_formatter = "{:.8f}".format
        np.set_printoptions(suppress=True, formatter={'float_kind': float_formatter})

        gps_json = json.load(open(gps_path))
        imu_json = json.load(open(imu_path))
        lat, long, alt = float(gps_json["lat"]), float(gps_json["long"]), float(gps_json["alt"])

        quaternion_x ,quaternion_y ,quaternion_z ,quaternion_w =  float(imu_json["quaternion_x"]), float(imu_json["quaternion_y"]), float(imu_json["quaternion_z"]), float(imu_json["quaternion_w"])


        # Convert GPS to UTM
        utm_east_vehicle_lidar, utm_north_vehicle_lidar, zone, _ = utm.from_latlon(lat, long)
        utm_east_vehicle_lidar = utm_east_vehicle_lidar
        utm_north_vehicle_lidar = utm_north_vehicle_lidar
        altitude_vehicle_lidar = alt

        rotation_x_vehicle_lidar = quaternion_x
        rotation_y_vehicle_lidar = quaternion_y
        rotation_z_vehicle_lidar = quaternion_z
        rotation_w_vehicle_lidar = quaternion_w
        rotation_roll_vehicle_lidar, rotation_pitch_vehicle_lidar, rotation_yaw_vehicle_lidar = R.from_quat(
            [rotation_x_vehicle_lidar, rotation_y_vehicle_lidar, rotation_z_vehicle_lidar,
            rotation_w_vehicle_lidar]).as_euler('xyz', degrees=True)
        rotation_yaw_vehicle_lidar = 0

        # 1.2 infrastructure lidar pose
        utm_east_s110_lidar_ouster_south = 695308.460000000 - 0.5
        utm_north_s110_lidar_ouster_south = 5347360.569000000 + 2.5
        altitude_s110_lidar_ouster_south = 534.3500000000000 + 1.0 + 0.5

        # =====================================================================

        rotation_roll_s110_lidar_ouster_south = 0  # 1.79097398157454 # pitch
        rotation_pitch_s110_lidar_ouster_south = 1.1729642881072  # roll
        rotation_yaw_s110_lidar_ouster_south = 172  # 172.693672075377

        translation_vehicle_lidar_to_s110_lidar_ouster_south = np.array(
            [utm_east_s110_lidar_ouster_south - utm_east_vehicle_lidar,
            utm_north_s110_lidar_ouster_south - utm_north_vehicle_lidar,
            altitude_s110_lidar_ouster_south - altitude_vehicle_lidar], dtype=float)

        rotation_matrix_vehicle_lidar_to_s110_lidar_ouster_south = R.from_rotvec(
            [rotation_roll_s110_lidar_ouster_south - rotation_roll_vehicle_lidar,
            rotation_pitch_s110_lidar_ouster_south - rotation_pitch_vehicle_lidar,
            rotation_yaw_s110_lidar_ouster_south - rotation_yaw_vehicle_lidar],
            degrees=True).as_matrix().T

        translation_vector_rotated = np.matmul(rotation_matrix_vehicle_lidar_to_s110_lidar_ouster_south,
                                            translation_vehicle_lidar_to_s110_lidar_ouster_south)
        transformation_matrix = np.zeros((4, 4))
        transformation_matrix[0:3, 0:3] = rotation_matrix_vehicle_lidar_to_s110_lidar_ouster_south
        transformation_matrix[0:3, 3] = -translation_vector_rotated
        transformation_matrix[3, 3] = 1.0
        
        rotate_around_x = R.from_euler('x', -1.5, degrees=True)
        transformation_matrix_rotate_x= np.zeros((4, 4))
        transformation_matrix_rotate_x[0:3, 0:3] = rotate_around_x.as_matrix()
        transformation_matrix_rotate_x[3, 3] = 1.0

        transformation_matrix = np.matmul(transformation_matrix, transformation_matrix_rotate_x.T)

        return transformation_matrix
