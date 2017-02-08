function [ SSE, num_samples ] = compare_sim_to_data( cutoff_freq_input, mu_x_input, mu_y_input, K_input, f_r_input, zero_accels )
% 4-th Order Butterworth LPF and differentiator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a set of data given a set of parameters
% Run the skid_steer simulation on this data
% Compare the simulated wheel velocities to the wheels vels from data
% By calculating the SSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global interpolation_delta_t cutoff_freq mu_x mu_y
global K f_r
interpolation_delta_t = 0.02;
cutoff_freq = cutoff_freq_input;
mu_x = mu_x_input;
mu_y = mu_y_input;
K = K_input;
f_r = f_r_input;

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
    
    %disp( strcat( 'Time:  ', num2str(xytheta_times_to_eval(t)) ) )
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get one time step of data for input to the model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (zero_accels) % If we want to set the noisy acceleration to 0
        x_ddot_M_B = 0;
        y_ddot_M_B = 0;
        theta_ddot_M = 0;
    else
        x_ddot_M_B = x_ddot_spline(t);
        y_ddot_M_B = y_ddot_spline(t);
        theta_ddot_M = theta_ddot_spline(t);        
    end
    x_ddot_G_M = 0;   y_ddot_G_M = 0; % The arms aren't moving so the COM doesn't move wrt the base
    x_dot_M_B = x_dot_spline(t);    y_dot_M_B = y_dot_spline(t);
    x_dot_G_M = 0;   y_dot_G_M = 0; % The arms aren't moving so the COM doesn't move wrt the base
    x_G_M = x_com;      y_G_M = y_com;
    z_ddot_G_B = 0; % Assuming the platform stays in the plane. The /slam_out_pose data shows z=0
    z_G_B = 0.35;
    theta_dot_M = theta_dot_spline(t);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Run the simulation on this data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fsolve_skid_steer
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compare the simulated wheel velocities to the wheel vels from data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate SSE for all data points
SSE = 0;
% For every simulation datapoint
for i=1:length(wheels_times_to_eval)
    if ( isfinite(left_wheel_vel_sim(i))) % Skip the many NaN's
    
        % Get the wheel velocity at this time
        l_wheel_vel_exp = ppval( l_wheel_vel_spline_fxn, wheels_times_to_eval(i) );
        SSE = SSE + ( left_wheel_vel_sim(i)-l_wheel_vel_exp )^2;
    end
end

num_samples = length(wheels_times_to_eval);

figure
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
axis([0 7.5 -2 4])
hold on
plot(wheels_times_to_eval, left_wheel_vel_sim, 'ro')
plot(wheels_times_to_eval, right_wheel_vel_sim, 'bo')
xlabel('Time [s]')
ylabel('Wheel speed [rad/s]')
legend('Simulated left wheel speed', 'Simulated right wheel speed')