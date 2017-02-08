clear all; close all; clc

% If we want to skip through data quickly
% Else, set skip_to_index to zero
skip_to_index = 1;
skip_this_many = 100;

% If wanted, set the accelerations to 0. (They're noisy)
zero_accels = true;

% Store reasonably-good parameter sets here
reasonably_good = [];

% Copy this data to work with
load('results');
sorted_results = results;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Another round? Prompt user
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reply = 'y';

while ( reply=='y' || reply=='Y' )
       
    close all;
    clearvars -except skip_to_index skip_this_many zero_accels sorted_results reasonably_good;
    clearvars -global
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Start plotting the dataset with the least error.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % These are the quantities in 'results':
    %results(row,:) = [cutoff_freq mu_x mu_y K f_r num_samples variance];
    
    % Row with least variance
    [min_variance, min_index] = min(sorted_results(:,7));
    
    % Quickly skip through?
    if (skip_to_index)
        skip_to_index = skip_to_index + skip_this_many;
        min_index = skip_to_index;
    end
    
    best_results = sorted_results(min_index, :)
    
    % Remove this row from the large results matrix
    % so we can find the 2nd-best next time
    sorted_results = sorted_results( [1:min_index-1, min_index+1:end], : );
    
    % Skip the ridiculously small errors caused by just a few datapoints
    if ( best_results(7) > 0.5 )
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot against experimental data
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        compare_sim_to_data( best_results(1), best_results(2), best_results(3), best_results(4), best_results(5), zero_accels );
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % After plotting, ask the user if it looks OK.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        prompt = 'Save the results for these parameters?  y/n   ';
        reply = input(prompt,'s');
        
        % Save if it was decent
        if (reply == 'y' || reply=='Y')
            reasonably_good = [ reasonably_good; best_results];
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % If the previous dataset didn't look acceptable, move on to the next
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        prompt = 'Another round?  y/n   ';
        reply = input(prompt,'s');
    else
        reply = 'y'; % Do another round
    end
end