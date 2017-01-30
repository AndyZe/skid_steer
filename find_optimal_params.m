clear all; close all; clc

% Search a grid of parameters, including:
% low-pass filter cutoff frequency (ranging from 0.1:10)
% mu_x  (Friction parameter) (ranging from 0.1:1)
% mu_y  (Friction parameter) (ranging from 0.1:1)
% K     (From Liu et al.) (centered around 13.333)
% f_r   (From Liu et al.) (centered around 0.0263)

% TODO: Don't need to run 'matlab_import_data' at every timestep
% TODO: Could disable plotting with a function input

% The best parameter set will return the lowest variance
results = [];
row = 1;
SSE = 0;
variance = 0;

for (cutoff_freq = 0.1:1:6)
    for (mu_x = 0.3 : 0.2 :1 )
        for (mu_y = 0.3 : 0.2 :1 )
            for (K = 5:2:20)
                for (f_r = 0.005 : 0.02 :0.06)
                    disp( [row 8400] ) % Display which iteration we're on
                    
                    % Store the parameters and variance for plotting
                    %function [ variance ] = compare_sim_to_data( cutoff_frequency )
                    [SSE num_samples] = compare_sim_to_data(cutoff_freq, mu_x, mu_y, K, f_r);
                    variance = SSE/num_samples;
                    results(row,:) = [cutoff_freq mu_x mu_y K f_r num_samples variance];
                    
                    row = row+1;
                    clearvars -global;
                    clearvars -except results row cutoff_freq mu_x mu_y K f_r;
                    close all; clc
                end
            end
        end
    end
end

% The best: smallest variance with at least X datapoints
[min_variance, min_index] = min(results(:,7));
best_results = results(min_index, :)

% Run it one more time to see the best results
% We're pulling these inputs from the "best row" of 'results'
compare_sim_to_data( best_results(1), best_results(2), best_results(3), best_results(4), best_results(5));

save('results.mat')


