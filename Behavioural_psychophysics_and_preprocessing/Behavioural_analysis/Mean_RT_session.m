function Mean_RT_session(data_raw_rt, name, paradigm)

    % This script measures the mean coherence or disparity with the mean rection
    % time along the choices of the trials (correct or incorrect)
    % Written by Revan Rangotis, March 2022

    %% Pre-processing

    % Create a column vector with list of coherence/disparity values 
    list_of_conditions = unique(data_raw_rt(:,2)); 
    sort(list_of_conditions,'ascend'); % sort them in ascending order
    final_analysis_array = cell(length(list_of_conditions),1);

    % Find trial IDs for each condition, put themn in first column
    for i = 1:size(list_of_conditions,1)
        final_analysis_array{i,1} = find(data_raw_rt(:,2)==list_of_conditions(i,1));
    end

    % Find the RT for all trials in each condition
    for i = 1:size(list_of_conditions,1)
        final_analysis_array{i,2} = data_raw_rt(final_analysis_array{i,1}(:,1),3);
    end

    % Note the mean RT for each condition back into the list. This is for all
    % correct as welll as incorrect trials 
    for i = 1:size(list_of_conditions,1)
        list_of_conditions(i,2) = mean(final_analysis_array{i,2});
    end

    %% Focusssed analysis on correct vs incorrect vs 0 trials 
    % First, isolate correct trials
    hits = data_raw_rt(data_raw_rt(:,5)==1, [2 3]);
    list_of_trial_conditions_hits = unique(hits(:,1));

    % Put the indices of correct trials for each condition (disparity or
    % coherence) into the third column of the final matrix 
    for i = 1:length(list_of_trial_conditions_hits)
        final_analysis_array{i,3} = find(hits(:,1)==list_of_trial_conditions_hits(i,1));
    end

    % Next to them, place the corresponding RTs 
    for i = 1:size(list_of_trial_conditions_hits,1)
        final_analysis_array{i,4} = hits(final_analysis_array{i,3}(:,1),2);
    end

    % Calculate the mean RTs for each condition
    for i = 1:size(list_of_trial_conditions_hits,1)
        list_of_trial_conditions_hits(i,2) = mean(final_analysis_array{i,4});
    end

    % Mean coherence/disparity, mean RT, and SEM for correct trials 
    x_correct = list_of_trial_conditions_hits(:,1);
    y_correct = list_of_trial_conditions_hits(:,2);
    for i = 1:size(list_of_trial_conditions_hits,1)
        list_of_trial_conditions_hits(i,3) = std(final_analysis_array{i,4})/sqrt(length(final_analysis_array{i,4}));
    end
    SEM_correct = list_of_trial_conditions_hits(:,3);

    %% Second, isolate incorrect trials
    not_hits_no_zero = data_raw_rt(data_raw_rt(:,5) == 0 & data_raw_rt(:,2) ~= 0, [2 3]);
    list_of_trial_conditions_not_hits = unique(not_hits_no_zero(:,1));

    % Put the indices of incorrect trials for each condition (disparity or
    % coherence) into the fifth column of the final matrix 
    for i = 1:size(list_of_trial_conditions_not_hits,1)
        final_analysis_array{i,5} = find(not_hits_no_zero(:,1)==list_of_trial_conditions_not_hits(i,1));
    end

    % Next to them, place the corresponding RTs 
    for i = 1:size(list_of_trial_conditions_not_hits,1)
        final_analysis_array{i,6} = not_hits_no_zero(final_analysis_array{i,5}(:,1),2);
    end

    % Calculate the mean RTs for each condition
    for i = 1:size(list_of_trial_conditions_not_hits,1)
        list_of_trial_conditions_not_hits(i,2) = mean(final_analysis_array{i,6});
    end

    % Mean coherence/disparity, mean RT, and SEM for incorrect trials 
    if ~isempty(list_of_trial_conditions_not_hits)
        x_incorrect = list_of_trial_conditions_not_hits(:,1);
        y_incorrect = list_of_trial_conditions_not_hits(:,2);
        for i = 1:size(list_of_trial_conditions_not_hits,1)
            list_of_trial_conditions_not_hits(i,3) = std(final_analysis_array{i,4})/sqrt(length(final_analysis_array{i,4}));
        end
        SEM_incorrect = list_of_trial_conditions_not_hits(:,3);
    end

    %% Third, isolate trials at 0 (coherence or disparity, ambiguous trials)
    hits_at_zero = data_raw_rt(data_raw_rt(:,2) == 0, [2 3]);
    list_of_trial_conditions_hits_at_zero = unique(hits_at_zero(:,1));

    % Put the indices of 0 trials for each condition (disparity or
    % coherence) into the fifth column of the final matrix 
    for i = 1:size(list_of_trial_conditions_hits_at_zero,1)
        final_analysis_array{i,7} = find(hits_at_zero(:,1)==list_of_trial_conditions_hits_at_zero(i,1));
    end

    % Next to them, place the corresponding RTs 
    for i = 1:size(list_of_trial_conditions_hits_at_zero,1)
        final_analysis_array{i,8} = hits_at_zero(final_analysis_array{i,7}(:,1),2);
    end

    % Calculate the mean RTs for each condition
    for i = 1:size(list_of_trial_conditions_hits_at_zero,1)
        list_of_trial_conditions_hits_at_zero(i,2) = mean(final_analysis_array{i,8});
    end

    % Mean coherence/disparity, mean RT, and SEM for ambiguous trials 
    if ~isempty(list_of_trial_conditions_hits_at_zero)
        x_0 = list_of_trial_conditions_hits_at_zero(:,1);
        y_0 = list_of_trial_conditions_hits_at_zero(:,2);
        for i = 1:size(list_of_trial_conditions_hits_at_zero,1)
            list_of_trial_conditions_hits_at_zero(i,3) = std(final_analysis_array{i,4})/sqrt(length(final_analysis_array{i,4}));
        end
        SEM_0 = list_of_trial_conditions_hits_at_zero(:,3);
    end 

    %% Plotting
    % Plot the graph with the SEM for both conditions 
    errorbar(x_correct,y_correct,SEM_correct,'b-o', 'LineWidth',1);
    hold on
    if exist("x_incorrect", 'var')
        errorbar(x_incorrect,y_incorrect,SEM_incorrect,'r-o', 'LineWidth',1);
    end 
    if exist("x_0", 'var')
        errorbar(x_0,y_0,SEM_0,'k-o', 'LineWidth',1);
    end 
    hold off
    title(name, 'FontSize', 18)

    % Choose appropriate labels for the x axis 
    if paradigm == "cyl_butt" || paradigm == "cyl_sac"
        xlabel('(leftward motion)    Disparity   (rightward motion)') 
    else
        xlabel('(leftward motion)    Coherence   (rightward motion)') 
        xlim([-60 60])
    end 

    % Add y-axis label and legend 
    ylabel('Reaction time (s)')
    legend({'correct', 'incorrect', 'ambiguous'},'Location','northwest')