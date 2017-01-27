
%%%%%%%%
% Inputs
%%%%%%%%
global F_ext_x F_ext_y F_ext_z pe_x pe_y pe_z x_ddot_M_B y_ddot_M_B 
global x_ddot_G_M y_ddot_G_M x_dot_M_B y_dot_M_B x_dot_G_M y_dot_G_M x_G_M 
global y_G_M z_ddot_G_B z_G_B theta_ddot_M theta_dot_M

% Display the inputs for debugging
% x_ddot_M_B
% y_ddot_M_B
% x_ddot_G_M
% y_ddot_G_M
% x_dot_M_B
% y_dot_M_B
% x_dot_G_M
% y_dot_G_M
% x_G_M
% y_G_M
% z_ddot_G_B
% z_G_B
% theta_ddot_M
% theta_dot_M

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
global mu_x mu_y K f_r I m r d_m W_b g

mu_x = 0.9; mu_y = 0.9; %Liu et al. values
K = 13.333; f_r = 0.0263; %Liu et al. values
I = 1/12*118.8437*(0.43^3+0.27^2); m = 118.8437; r = 0.328/2; d_m = 0.56; W_b = 0.52;% VB rough approx.
g = 9.81; %constant

%%%%%%%%%%%%%%%%%
% Results to save
%%%%%%%%%%%%%%%%%
global left_wheel_vel_sim right_wheel_vel_sim

fun = @(x) Thesis_fsolve(x);
N_guess = m*g/4;
q_l_guess = (2*x_dot_M_B-r*theta_dot_M)/(2*r);
q_r_guess = (2*x_dot_M_B+r*theta_dot_M)/(2*r);
x0 = [N_guess,N_guess,N_guess,N_guess,q_l_guess,q_r_guess]; % Guess

options = optimoptions('fsolve','MaxFunctionEvaluations',1000,'Display','none');

tic
results = fsolve(fun,x0,options)
toc

% Save the wheel velocities
% Skip if the solver failed
if (( abs(results(5)) < 10^2 ) && ( abs(results(6)) < 10^2 ))
    left_wheel_vel_sim = [left_wheel_vel_sim results(5)];
    right_wheel_vel_sim = [right_wheel_vel_sim results(6)];
else
    left_wheel_vel_sim = [left_wheel_vel_sim NaN];
    right_wheel_vel_sim = [right_wheel_vel_sim NaN];
end


