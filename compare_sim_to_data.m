%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a set of data
% Run the simulation on this data
% Compare the simulated wheel velocities to the wheels vels from data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare all of the data
%%%%%%%%%%%%%%%%%%%%%%%%%
addpath ./data_processing
addpath ./data_processing/COM
addpath ./data_processing/wheel_vel
addpath ./data_processing/x_y_theta_slam

matlab_import_data

for i=1: i<length(xytheta_times_to_eval)
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get a particular set of data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Run the simulation on this data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compare the simulated wheel velocities to the wheels vels from data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end