
clear all; close all; clc

% Import enough data to run a skid-steer simulation.
% Import wheel velocity data to compare the results.
% Splines are used because we're dealing with different sample rates and
% signals that need to be differentiated.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import the COM coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'COM/1.txt';
com_data = importdata(filename);
x_com = com_data(1);
y_com = com_data(2);
z_com = com_data(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import, spline, and differentiate (twice) the x,y,theta data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'x_y_theta_slam/1.txt';
x_y_theta_data = importdata(filename);
time_slam = x_y_theta_data(:,1);
x_slam = x_y_theta_data(:,2);
y_slam = x_y_theta_data(:,3);
theta_slam = x_y_theta_data(:,4);

xytheta_times_to_eval = time_slam(1): 0.001: time_slam(end);

x_spline_fxn = spline(time_slam, x_slam);
x_spline = ppval( x_spline_fxn, xytheta_times_to_eval ); % Evaluvate at these points

x_dot_spline_fxn = fnder( x_spline_fxn, 1 ); % Derivative
x_dot_spline = ppval( x_dot_spline_fxn, xytheta_times_to_eval );

title('X Position [m]')
hold on
plot(time_slam, x_slam, 'r')
plot(xytheta_times_to_eval, x_spline,'b')
plot(xytheta_times_to_eval, x_dot_spline,'c')
legend('Original data', 'Spline-interpolated data', 'Spline slope')

y_spline_fxn = spline(time_slam, y_slam);
y_spline = ppval( y_spline_fxn, xytheta_times_to_eval ); % Evaluvate at these points

y_dot_spline_fxn = fnder( y_spline_fxn, 1 ); % Derivative
y_dot_spline = ppval( y_dot_spline_fxn, xytheta_times_to_eval );

theta_spline_fxn = spline(time_slam, theta_slam);
theta_spline = ppval( theta_spline_fxn, xytheta_times_to_eval ); % Evaluvate at these points

theta_dot_spline_fxn = fnder( theta_spline_fxn, 1 ); % Derivative
theta_dot_spline = ppval( theta_dot_spline_fxn, xytheta_times_to_eval );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For comparison with the simulation, import and spline the wheel velocity data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'wheel_vel/1.txt';
wheel_vel_data = importdata(filename);
time_wheels = wheel_vel_data(:,1);
l_wheel_vel = wheel_vel_data(:,2);
r_wheel_vel = wheel_vel_data(:,3);

wheels_times_to_eval = time_wheels(1): 0.001: time_wheels(end);

% Fit with splines for easy interpolation
l_wheel_vel_spline_fxn = spline(time_wheels, l_wheel_vel);
l_wheel_vel_spline = ppval( l_wheel_vel_spline_fxn, wheels_times_to_eval ); % Evaluate at these points

figure
hold on
title('Left Wheel Speed [rad/s]')
plot(time_wheels, l_wheel_vel, 'r')
plot(wheels_times_to_eval, l_wheel_vel_spline,'b')
legend('Original data', 'Spline-interpolated data')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trim the data arrays to the same length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_length = min([length(xytheta_times_to_eval) length(wheels_times_to_eval)]);

xytheta_times_to_eval = xytheta_times_to_eval(1:max_length);
wheels_times_to_eval = wheels_times_to_eval(1:max_length);
