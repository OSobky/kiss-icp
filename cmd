kiss_icp_pipeline [OPTIONS] DATA 



-- Save Local map command for Infra pointclouds
kiss_icp_pipeline --save_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_full.npy \
                  -v \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/kiss-icp/config/basic.yaml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/matched

-- Save Local map command for Infra pointclouds downsampled no ground
kiss_icp_pipeline --save_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_full_downsampled.npy \
                  -v \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/kiss-icp/config/basic.yaml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/ground_removed_pcds_-7.25_no_origin_downsampled

-- Save Local map command for Infra pointclouds no ground
kiss_icp_pipeline --save_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_no_ground.npy \
                  -v \
                  -n 15 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/kiss-icp/config/basic.yaml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/ground_removed_pcds_-7.25


-- Load infra Local map command with infra pointclouds
kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra.npy \
                  -v \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/matched

-- Load infra Local map command with vehicle pointclouds
kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra.npy \
                  -v \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched

-- Load infra Local map command with vehicle pointclouds with ground is removed in both
kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_full.npy \
                  -v \
                 /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0


# Load infra Local map command with vehicle pointclouds 
# plus get the initial guess from the gps and imu

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra.npy \
                  -v \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched

# Load infra Local map command with vehicle pointclouds 
# plus get the initial guess from the gps and imu
# plus increase the max distance for points

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_full.npy \
                  -v \
                  --max_range 150 \
                  -j 1 \
                  -n 492 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched


# Load infra Local map command with vehicle pointclouds 
# plus get the initial guess from the gps and imu
# plus increase the max distance for points
# ground is removed in both

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_full.npy \
                  -v \
                  --max_range 150 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0


# online registeration of vehicle pointclouds to infra pointclouds command with ground with no deskew

kiss_icp_pipeline --target_pcd /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/matched \
                  -v \
                  --max_range 150 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched


# online registeration of vehicle pointclouds to infra pointclouds command with ground with deskew

kiss_icp_pipeline --target_pcd /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/matched \
                  -v \
                  --max_range 150 \
                  --deskew \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched


# online registeration of vehicle pointclouds to infra pointclouds command with ground removed with deskew

kiss_icp_pipeline --target_pcd /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/ground_removed_pcds_-7.25 \
                  -v \
                  --max_range 150 \
                  --deskew \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0



# online registeration of vehicle pointclouds to infra pointclouds command with ground removed with no deskew

kiss_icp_pipeline --target_pcd /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/02_infrastructure_lidar_ouster/s110_lidar_ouster_south_driving_direction_east/ground_removed_pcds_-7.25 \
                  -v \
                  --max_range 150 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0



# offline registeration of vehicle pointclouds to infra pointclouds command with ground with no deskew

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra.npy \
                  -v \
                  --max_range 150 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/offline/ground/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched



# offline registeration of vehicle pointclouds to infra pointclouds command with ground with deskew

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra.npy \
                  -v \
                  --max_range 150 \
                  --deskew \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/offline/ground/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched


# offline registeration of vehicle pointclouds to infra pointclouds command with ground removed with deskew

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_no_ground.npy \
                  -v \
                  --max_range 150 \
                  --deskew \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/offline/no_ground/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0

# offline registeration of vehicle pointclouds to infra pointclouds command with ground removed with no deskew

kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/local_map/kiss_icp_infra_no_ground.npy \
                  -v \
                  --max_range 150 \
                  --gps /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/03_gps/04_gps_position_drive/json/matched/ \
                  --imu  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/04_imu/04_imu_rotations_drive/json/matched/ \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/kiss-icp/offline/no_ground/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/ground_removed_pcds_0.0

# Ablation study without any modification to KISS and only Vehilce PCD (Conda env kiss-icp)

kiss_icp_pipeline -v \
                  --max_range 150 \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/abilation/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched

kiss_icp_pipeline -v \
                  --max_range 150 \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/abilation/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/transformed_cleaned_dir


kiss_icp_pipeline --local_map /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/data/local_map/kiss_icp_infra.npy \
                  -v \
                  --max_range 150 \
                  -j 1 \
                  -n 492 \
                  --config /mnt/c/Users/elsobkyo/Documents/masters-thesis/veh-infr-loc/experiments/abilation/config.yml \
                  /mnt/c/Users/elsobkyo/Documents/masters-thesis/Data/01_scene_01_omar/01_lidar/01_vehicle_lidar_robosense/vehicle_lidar_robosense_driving_direction_east/s110_first_east/matched

