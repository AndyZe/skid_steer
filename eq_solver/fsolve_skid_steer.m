
clear all; close all; clc

%%%%%%%%
% Inputs
%%%%%%%%
global F_ext_x F_ext_y F_ext_z pe_x pe_y pe_z x_ddot_M_B y_ddot_M_B 
global x_ddot_G_M y_ddot_G_M x_dot_M_B y_dot_M_B x_dot_G_M y_dot_G_M x_G_M 
global y_G_M z_ddot_G_B z_G_B theta_ddot_M theta_dot_M

F_ext_x = 0; F_ext_y = 0; F_ext_z = 0; % external forces (on EEF)
pe_x = 0; pe_y = 0; pe_z = 0; % EEF positions
x_ddot_M_B = 0; y_ddot_M_B = 0; % base acceleration
x_ddot_G_M = 0; y_ddot_G_M = 0; % COM acceleration
x_dot_M_B = 0; y_dot_M_B = 0; %inputs - base velocity
x_dot_G_M = 0; y_dot_G_M = 0; %inputs - COM velocity
x_G_M = 0; y_G_M = 0; %inputs - COM position
z_ddot_G_B = 0; %input - COM Z acceleration
z_G_B = 0.35; %input - COM Z position (VB rough approx.)
theta_ddot_M = 0; %input - base rot. acceleration
theta_dot_M = 0; %input - base rot. velocity

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
global mu_x mu_y K f_r I m r d_m W_b g

mu_x = 0.9; mu_y = 0.9; %Liu et al. values
K = 13.333; f_r = 0.0263; %Liu et al. values
I = 1/12*118.8437*(0.43^3+0.27^2); m = 118.8437; r = 0.328/2; d_m = 0.56; W_b = 0.52;% VB rough approx.
g = 9.81; %constant

%%%%%%%%%%%%%%%%%%
% Desired velocity
%%%%%%%%%%%%%%%%%%
% Note: if getting an error about undefined objective function, try a small
% non-zero value for both velocity components.
% It seems pure translation or pure rotation is unachievable.
x_dot_M_B = 0.001; %0.3;
theta_dot_M = 0.3; %0.1;


fun = @(x) Thesis_fsolve(x);
N_guess = m*g/4;
q_l_guess = (2*x_dot_M_B-r*theta_dot_M)/(2*r);
q_r_guess = (2*x_dot_M_B+r*theta_dot_M)/(2*r);
x0 = [N_guess,N_guess,N_guess,N_guess,q_l_guess,q_r_guess]
tic
fsolve(fun,x0)
toc