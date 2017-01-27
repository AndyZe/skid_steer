
% Import enough data to run a skid-steer simulation.
% Import wheel velocity data to compare the results.
% Splines are used because we're dealing with different sample rates and
% signals that need to be differentiated.

global interpolation_delta_t

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import the COM coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'COM/1.txt';
com_data = importdata(filename);
x_com = com_data(1);
y_com = com_data(2);
z_com = com_data(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import, interpolate, and differentiate (twice) the x,y,theta data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'x_y_theta_slam/1.txt';
x_y_theta_data = importdata(filename);
time_slam = x_y_theta_data(:,1);
x_slam = x_y_theta_data(:,2);
y_slam = x_y_theta_data(:,3);
theta_slam = x_y_theta_data(:,4);

xytheta_times_to_eval = time_slam(1): interpolation_delta_t: time_slam(end);

x_spline_fxn = spline(time_slam, x_slam);
x_spline = ppval( x_spline_fxn, xytheta_times_to_eval ); % Evaluate at these points

y_spline_fxn = spline(time_slam, y_slam);
y_spline = ppval( y_spline_fxn, xytheta_times_to_eval );

theta_spline_fxn = spline(time_slam, theta_slam);
theta_spline = ppval( theta_spline_fxn, xytheta_times_to_eval );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For comparison with the simulation, import and spline the wheel velocity data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = 'wheel_vel/1.txt';
wheel_vel_data = importdata(filename);
time_wheels = wheel_vel_data(:,1);
l_wheel_vel = wheel_vel_data(:,2);
r_wheel_vel = wheel_vel_data(:,3);

wheels_times_to_eval = time_wheels(1): interpolation_delta_t: time_wheels(end);

% Fit with splines for easy interpolation
l_wheel_vel_spline_fxn = spline(time_wheels, l_wheel_vel);
l_wheel_vel_spline = ppval( l_wheel_vel_spline_fxn, wheels_times_to_eval );

r_wheel_vel_spline_fxn = spline(time_wheels, r_wheel_vel);
r_wheel_vel_spline = ppval( r_wheel_vel_spline_fxn, wheels_times_to_eval );

%%%%%%%%
% Filter
%%%%%%%%

x_spline = lp_filter( x_spline, xytheta_times_to_eval(end) );
y_spline = lp_filter( y_spline, xytheta_times_to_eval(end) );
theta_spline = lp_filter( theta_spline, xytheta_times_to_eval(end) );

x_dot_spline = lp_filter_deriv( x_spline, xytheta_times_to_eval(end) );
y_dot_spline = lp_filter_deriv( y_spline, xytheta_times_to_eval(end) );
theta_dot_spline = lp_filter_deriv( theta_spline, xytheta_times_to_eval(end) );

x_ddot_spline = lp_filter_deriv( x_dot_spline, xytheta_times_to_eval(end) );
y_ddot_spline = lp_filter_deriv( y_dot_spline, xytheta_times_to_eval(end) );
theta_ddot_spline = lp_filter_deriv( theta_dot_spline, xytheta_times_to_eval(end) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trim the data arrays to the same length
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_length = min([length(xytheta_times_to_eval) length(wheels_times_to_eval)]);

xytheta_times_to_eval = xytheta_times_to_eval(1:max_length);
wheels_times_to_eval = wheels_times_to_eval(1:max_length);
x_spline = x_spline(1:max_length);
y_spline = y_spline(1:max_length);
theta_spline = theta_spline(1:max_length);
x_dot_spline = x_dot_spline(1:max_length);
y_dot_spline = y_dot_spline(1:max_length);
theta_dot_spline = theta_dot_spline(1:max_length);
x_ddot_spline = x_ddot_spline(1:max_length);
y_ddot_spline = y_ddot_spline(1:max_length);
theta_ddot_spline = theta_ddot_spline(1:max_length);

%%%%%%%
% Plots
%%%%%%%

figure
title('Filtered X Position [m]')
hold on
plot(time_slam, x_slam, 'r')
plot(xytheta_times_to_eval, x_spline,'b')
plot(xytheta_times_to_eval, x_dot_spline,'c')
plot(xytheta_times_to_eval, x_ddot_spline,'g')
legend('Original data', 'Spline-interpolated data', 'Spline slope', 'Spline concavity')

% figure
% hold on
% title('Left Wheel Speed [rad/s]')
% plot(time_wheels, l_wheel_vel, 'r')
% plot(wheels_times_to_eval, l_wheel_vel_spline,'b')
% legend('Original data', 'Spline-interpolated data')

%%%%%%%%%%%%%%%%%%%
% % Filter Testing:
%%%%%%%%%%%%%%%%%%%
% f_test = 10; % Hz
% sample_rate = 1000;
% run_time = 1;
% for t= 1: run_time*sample_rate
%     data(t)= sin(2*3.142*f_test*(t/sample_rate));
% end
% filtered_data = lp_filter(data, run_time);
% figure
% plot(data,'b')
% hold on
% plot(filtered_data,'r')
% legend('Data','Filtered Data')