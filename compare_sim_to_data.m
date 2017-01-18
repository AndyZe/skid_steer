%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a set of data
% Run the skid_steer simulation on this data
% Compare the simulated wheel velocities to the wheels vels from data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc

global interpolation_delta_t alpha
interpolation_delta_t = 0.05;
alpha=0.5; % higher alpha ==> less smoothing

%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare all of the data
%%%%%%%%%%%%%%%%%%%%%%%%%
addpath ./data_processing
addpath ./data_processing/COM
addpath ./data_processing/wheel_vel
addpath ./data_processing/x_y_theta_slam
addpath ./eq_solver

% Get a vector of spline-interpolated values for every time step
matlab_import_data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The parameters we care about for the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global F_ext_x F_ext_y F_ext_z pe_x pe_y pe_z x_ddot_M_B y_ddot_M_B 
global x_ddot_G_M y_ddot_G_M x_dot_M_B y_dot_M_B x_dot_G_M y_dot_G_M x_G_M 
global y_G_M z_ddot_G_B z_G_B theta_ddot_M theta_dot_M

F_ext_x = 0; F_ext_y = 0; F_ext_z = 0; % external forces (on EEF)
pe_x = 0; pe_y = 0; pe_z = 0; % Relative EEF positions, in case you want to include external forces on the effectors in your mode
x_ddot_M_B = 0; y_ddot_M_B = 0; % base acceleration
x_ddot_G_M = 0; y_ddot_G_M = 0; % COM acceleration
x_dot_M_B = 0; y_dot_M_B = 0; %inputs - base velocity
x_dot_G_M = 0; y_dot_G_M = 0; %inputs - COM velocity
x_G_M = 0; y_G_M = 0; %inputs - COM position
z_ddot_G_B = 0; %input - COM Z acceleration
z_G_B = 0.35; %input - COM Z position (VB rough approx.)
theta_ddot_M = 0; %input - base rot. acceleration
theta_dot_M = 0; %input - base rot. velocity

% Store the results
global left_wheel_vel_sim right_wheel_vel_sim

%%%%%%%%%%%%%%%%%%%
% For each timestep
%%%%%%%%%%%%%%%%%%%
for t= 1: length(xytheta_times_to_eval)
    
    disp( strcat( 'Time:  ', num2str(xytheta_times_to_eval(t)) ) )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get one time step of data for input to the model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x_ddot_M_B = x_ddot_spline(t);    y_ddot_M_B = y_ddot_spline(t);
    x_ddot_G_M = 0;   y_ddot_G_M = 0; % The arms aren't moving so the COM doesn't move wrt the base
    x_dot_M_B = x_dot_spline(t);    y_dot_M_B = y_dot_spline(t);
    x_dot_G_M = 0;   y_dot_G_M = 0; % The arms aren't moving so the COM doesn't move wrt the base
    x_G_M = x_com;      y_G_M = y_com;
    z_ddot_G_B = 0; % Assuming the platform stays in the plane. The /slam_out_pose data shows z=0
    z_G_B = 0.35;
    theta_ddot_M = theta_ddot_spline(t);
    theta_dot_M = theta_dot_spline(t);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Run the simulation on this data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fsolve_skid_steer
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare the simulated wheel velocities to the wheels vels from data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Experimental
subplot(2,1,1)
hold on
plot(wheels_times_to_eval, l_wheel_vel_spline, 'ro')
plot(wheels_times_to_eval, r_wheel_vel_spline, 'bo')
xlabel('Time [s]')
ylabel('Wheel speed [rad/s]')
legend('Experimental left wheel speed', 'Experimental right wheel speed')

% Simulated
subplot(2,1,2)
hold on
plot(xytheta_times_to_eval, left_wheel_vel_sim, 'ro')
plot(xytheta_times_to_eval, right_wheel_vel_sim, 'bo')
xlabel('Time [s]')
ylabel('Wheel speed [rad/s]')
legend('Simulated left wheel speed', 'Simulated right wheel speed')