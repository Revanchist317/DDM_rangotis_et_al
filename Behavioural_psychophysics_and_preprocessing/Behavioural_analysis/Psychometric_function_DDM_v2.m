function [mu, sd] = Psychometric_function_DDM_v2(data_raw_psychometric, paradigm, counter)

    %% Pre-processing

    % Create column vector with list of coherence/disparity values
    data_raw_psychometric = table2array(data_raw_psychometric);
    list_of_conditions = unique(data_raw_psychometric(:,2));
    sort(list_of_conditions,'ascend'); % sort them in ascending order
    final_analysis_array = cell(length(list_of_conditions),1);

    % Find trial IDs for each condition, put themn in first column
    for i = 1:size(list_of_conditions,1)
        final_analysis_array{i,1} = find(data_raw_psychometric(:,2)==list_of_conditions(i,1));
    end

    % Find the responses for each condition 
    for i = 1:size(list_of_conditions,1)
        final_analysis_array{i,2} = data_raw_psychometric(final_analysis_array{i,1}(:,1),4);
    end

    % Number of trials per condition
    for i = 1:size(list_of_conditions,1)
        list_of_conditions(i,2) = size(final_analysis_array{i,1},1);
    end

    % Find the number of 'right' responses (CCW)
    for i = 1:size(list_of_conditions,1)
        list_of_conditions(i,3) = sum(final_analysis_array{i,2});
    end

    probit.x = list_of_conditions(:,1); % List of conditions
    probit.n = list_of_conditions(:,2); % Number of trials in total
    probit.resps = list_of_conditions(:,3); % Number of 'right direction' trials

    [mu, sd] = psychometric_fit_cum_norm_v2(probit, paradigm, counter);
    
    if max(probit.x) > 10
        precision = 3;
    else
        precision = 2;
    end 
    
    str = {"Bias: " + num2str(mu, precision), "Threshold: " + num2str(sd, precision)};
    ax = gca;
    ax.FontSize = 16;
    
    xl = xlim;
    left_post_text = xl(1) + abs(xl(1))*0.1;

    colour_list = ["#FF8C00", "#00b25f", "#c4290a", "#0072B2"]; 
    m_colour_list = ["#ff7b00", "#ffae00", "#008bb2", "#6aa9bd"]; 

    if paradigm == "humans"
        text(left_post_text, 0.8, str, "FontSize", 16, "Color", 'k'); 
    elseif paradigm == "m133"
        text(left_post_text, 0.6, str, "FontSize", 16, "Color", m_colour_list(counter));
    else
        text(left_post_text, 0.4, str, "FontSize", 16, "Color", m_colour_list(counter));
    end 
