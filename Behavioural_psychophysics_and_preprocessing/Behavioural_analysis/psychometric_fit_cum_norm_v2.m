function [mu, sd] = psychometric_fit_cum_norm_v2(probit, paradigm, counter)

    % Revan Rangotis, 2022
    % This function fits a psychometric curve using the cumulative Gaussian to
    % data with a binomial distribution (i.e., only two responses possible,
    % such as left and right, ideally suited to analyse performance on 2AFC
    % tasks). 

    % Data structure:
    % probit.x: List of unique 'conditions', such as the list of disparities,
    % typically an odd number (if ambiguous conditions are used)
    % probit.n: The number of trials in each condition
    % probit.resps: The number of 'right direction', literally going CCW for
    % cyliders for instance 

    % This function exists for SYMMETRICAL reward schedules, meaning each side
    % is rewarded equally. 

    % Calculate p, the proportions of choices in +ve rotation direction 
    p = [probit.resps]./[probit.n];

    % If there are fewer than three points on the PSF, cannot fit the cdf.
    if length(p) < 2
        warning("Not enough points for fitting!") 
        return
    end

    Results.fit = fitCumulativeGaussian(probit.resps, probit.n, probit.x);

    mu = Results.fit(1);
    sd = Results.fit(2);

    % Calculate the errorbars (SEM) for the data:
    for i = 1:size(probit.n, 1)
        data = zeros(1, probit.n(i));
        data(1:probit.resps(i)) = 1;
        probit.std(i) = std(data);
        probit.sem(i) = probit.std(i) / sqrt(probit.n(i)) ;
        clear data;
    end

    % Plot the fitted curve:
    stim_set2 = unique(probit.x);

    colour_list = ["k", "k", "k","k"]; 
    m_colour_list = ["#ff7b00", "#ffae00", "#008bb2", "#6aa9bd"]; 
    
    % Plot the observed data points and the fitted curve:
    global stim_set %#ok<*TLEV>
    
    if paradigm == "m133"
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set2, probit.resps ./ probit.n, probit.sem, 'o', ... 
        'MarkerFaceColor', m_colour_list(counter),"Color", m_colour_list(counter) , ...
    'LineWidth', 1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 3, "Color",  m_colour_list(counter), "LineStyle","--");
        
    elseif paradigm == "m134"
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set2, probit.resps ./ probit.n, probit.sem, 'o', ...
        'MarkerFaceColor', m_colour_list(counter),"Color", m_colour_list(counter) , ... 
    'LineWidth', 1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 3, "Color", m_colour_list(counter), "LineStyle","--");
        
    else
        stim_set = unique(probit.x);
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set, probit.resps ./ probit.n, probit.sem, 'o', ...
        'MarkerFaceColor', colour_list(counter), "Color", colour_list(counter), 'LineWidth', ...
        1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 2.5, "Color", colour_list(counter));
    end 
end

function fitParams = fitCumulativeGaussian(resps, n, x)

    % Define the cumulative Gaussian function
    cumulativeGaussian = @(params, x) 0.5 * (1 + erf((x - params(1)) / (params(2) * sqrt(2))));

    % Initial guess for parameters (mean and standard deviation)
    initialGuess = [0, abs(x(find((resps./n)>(1-0.76), 1)))];

    % Define options for lsqcurvefit
    options = optimoptions('lsqcurvefit', 'Display', 'iter');

    % Use lsqcurvefit for least-squares fitting
    fitParams = lsqcurvefit(cumulativeGaussian, initialGuess, x, resps./n, [], [], options);

    % Display the results
    disp('Fitted Parameters:');
    disp(['Mean: ', num2str(fitParams(1))]);
    disp(['Standard Deviation: ', num2str(fitParams(2))]);
end
