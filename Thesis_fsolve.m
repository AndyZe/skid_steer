function F = Thesis_fsolve(x)

%%%%%%%%
% Inputs
%%%%%%%%
global F_ext_x F_ext_y F_ext_z pe_x pe_y pe_z x_ddot_M_B y_ddot_M_B 
global x_ddot_G_M y_ddot_G_M x_dot_M_B y_dot_M_B x_dot_G_M y_dot_G_M x_G_M 
global y_G_M z_ddot_G_B z_G_B theta_ddot_M theta_dot_M

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
global mu_x mu_y K f_r I m r d_m W_b g


%N_fl = x(1);
%N_fr = x(2);
%N_bl = x(3);
%N_br = x(4);
%q_dot_l = x(5);
%q_dot_r = x(6);

%Slip velocities
s_dot_lx = x_dot_M_B - d_m*theta_dot_M/2 - r*x(5);
s_dot_rx = x_dot_M_B + d_m*theta_dot_M/2 - r*x(6);
s_dot_fy = y_dot_M_B + W_b/2*theta_dot_M;
s_dot_by = y_dot_M_B - W_b/2*theta_dot_M;

%Tire friction forces - x
F_x_fl = -mu_x*x(1)*(1-exp(-K*abs(s_dot_lx)/(1/2*(abs(s_dot_lx+r*x(5))+abs(r*x(5))+abs(abs(s_dot_lx+r*x(5))-abs(r*x(5)))))))*s_dot_lx/sqrt(s_dot_lx^2+s_dot_fy^2);
F_x_fr = -mu_x*x(2)*(1-exp(-K*abs(s_dot_rx)/(1/2*(abs(s_dot_rx+r*x(6))+abs(r*x(6))+abs(abs(s_dot_rx+r*x(6))-abs(r*x(6)))))))*s_dot_rx/sqrt(s_dot_rx^2+s_dot_fy^2);
F_x_bl = -mu_x*x(3)*(1-exp(-K*abs(s_dot_lx)/(1/2*(abs(s_dot_lx+r*x(5))+abs(r*x(5))+abs(abs(s_dot_lx+r*x(5))-abs(r*x(5)))))))*s_dot_lx/sqrt(s_dot_lx^2+s_dot_by^2);
F_x_br = -mu_x*x(4)*(1-exp(-K*abs(s_dot_rx)/(1/2*(abs(s_dot_rx+r*x(6))+abs(r*x(6))+abs(abs(s_dot_rx+r*x(6))-abs(r*x(6)))))))*s_dot_rx/sqrt(s_dot_rx^2+s_dot_by^2);
%Tire friction forces - y
F_y_fl = -mu_y*x(1)*(1-exp(-K))*s_dot_fy/sqrt(s_dot_lx^2+s_dot_fy^2);
F_y_fr = -mu_y*x(2)*(1-exp(-K))*s_dot_fy/sqrt(s_dot_rx^2+s_dot_fy^2);
F_y_bl = -mu_y*x(3)*(1-exp(-K))*s_dot_by/sqrt(s_dot_lx^2+s_dot_by^2);
F_y_br = -mu_y*x(4)*(1-exp(-K))*s_dot_by/sqrt(s_dot_rx^2+s_dot_by^2);
%Rolling resistance
R_fl = f_r*x(1);
R_fr = f_r*x(2);
R_bl = f_r*x(3);
R_br = f_r*x(4);
%CG accelerations
x_ddot_G_B = x_ddot_M_B + x_ddot_G_M - y_G_M*theta_ddot_M-2*y_dot_G_M*theta_dot_M-x_G_M*theta_dot_M^2;
y_ddot_G_B = y_ddot_M_B + y_ddot_G_M - x_G_M*theta_ddot_M-2*x_dot_G_M*theta_dot_M-y_G_M*theta_dot_M^2;
% 6 Equations, 6 Unknowns (N_fl,N_fr,N_bl,N_br,q_dot_l,q_dot_r)
F(1) = x(1) + x(2) + x(3) + x(4) - m*(g + z_ddot_G_B) + F_ext_z;
F(2) = m*(g + z_ddot_G_B)*(d_m/2 - y_G_M) - pe_z*F_ext_y-F_ext_z*(d_m/2-pe_y)+m*z_G_B*y_ddot_G_B - d_m*(x(2) + x(4));
F(3) = m*(W_b/2 - x_G_M)*(g + z_ddot_G_B)+m*z_G_B*(x_ddot_G_B) - pe_z*F_ext_x -F_ext_z*(W_b/2 - pe_x) - W_b*(x(4)+x(3));
F(4) = F_x_fl+F_x_fr+F_x_bl+F_x_br - m*(x_ddot_G_B) - f_r*(m*(g+z_ddot_G_B)-F_ext_z) +F_ext_x;
F(5) = F_y_fl+F_y_fr+F_y_bl+F_y_br + m*y_ddot_G_B - F_ext_y;
F(6) = (F_y_fl+F_y_fr)*(W_b/2 - x_G_M) - (F_y_bl+F_y_br)*(W_b/2 + x_G_M) + (F_x_fr+F_x_br-R_fr-R_br)*(d_m/2 + y_G_M)-(F_x_fl+F_x_bl-R_bl-R_fl)*(d_m/2-y_G_M) + F_ext_y*(pe_x - x_G_M) - F_ext_x*(pe_y - y_G_M) - I*theta_ddot_M;

end

