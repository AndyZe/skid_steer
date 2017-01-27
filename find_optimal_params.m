clear all; close all; clc

% Search a grid of parameters, including:
% low-pass filter cutoff frequency (ranging from 0.1:10)
% mu_x  (Friction parameter) (ranging from 0.1:1)
% mu_y  (Friction parameter) (ranging from 0.1:1)
% K     (From Liu et al.) (centered around 13.333)
% f_r   (From Liu et al.) (centered around 0.0263)

% The best parameter set will return the lowest SSE
SSE= [];
for (cutoff_freq = 0.1:0.2:10)
    for (mu_x = 0.1:0.05:1)
        for (mu_y = 0.1:0.05:1)
            for (K = 5:0.5:20)
                for (f_r = 0.005 : 0.005 : 0.06)

                    % Store all the SSE values for plotting
                    %function [ SSE ] = compare_sim_to_data( cutoff_frequency )
                    SSE = [SSE compare_sim_to_data(2)];

                end
            end
        end
    end
end
