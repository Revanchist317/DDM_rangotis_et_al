function [mu, sd] = psychometric_fit_cum_norm_v2(probit, paradigm)

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
    % Exit the function with exit flag = 0.
    if length(p) < 2
        warning("Not enough points for fitting!") 
        return
    end

    % Make an initial guess at the parameters to fit. x(1) is the mean, x(2) is
    % the SD.

    % mean:
    w = exp(-(p - 0.5).^2 ./0.1);
        for k = 1:3
            x(1) = sum(w .* [probit.x] .* [probit.n])/sum(w .*[probit.n]);

            % SD:
            nsd = erfinv((p * 2) -1);
            idx = nsd > 2;
            nsd(idx) = 2;
            idx = nsd < -2;
            nsd(idx) = -2;
            nsd(nsd == 0) = mean(nsd)/10;

        end

    results.preg = polyfit([probit.x],nsd,1); % Fit a straight line to nsd as function of probit.x
    x(2) = 1/results.preg(1); 
    a = loglike(x, probit);
    b = loglike([x(1) -x(2)], probit);

    if(b < a)
        x(2) = -x(2);
    end
    
    % Calclate log likelihood for the initial guess for mean and SD (held in
    % array 'x').
    [results.fit, results.loglike] = fminsearch(@loglike, x, [], probit);

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
 
    mu = results.fit(1); % mean
    sd = results.fit(2); % sd
    
    % Plot the observed data points and the fitted curve:
    
    global stim_set %#ok<*TLEV>
    
    if paradigm == "m133"
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set2, probit.resps ./ probit.n, probit.sem, 'o', ... 
        'MarkerFaceColor', [0.00,0.45,0.74],"Color", [0.00,0.45,0.74] , ...
    'LineWidth', 1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 2.5, "Color", [0.00,0.45,0.74]);
        
    elseif paradigm == "m134"
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set2, probit.resps ./ probit.n, probit.sem, 'o', ...
        'MarkerFaceColor', [0.84,0.11,0.38],"Color", [0.84,0.11,0.38] , ... 
    'LineWidth', 1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 2.5, "Color", [0.84,0.11,0.38]);
        
    else
        stim_set = unique(probit.x);
        g_stim = linspace(min(stim_set)-(max(stim_set/2)), max(stim_set)+(max(stim_set/2)), 100);
        errorbar(stim_set, probit.resps ./ probit.n, probit.sem, 'ko', ...
        'MarkerFaceColor', 'k',  'LineWidth', 1, 'HandleVisibility', 'off');
        g_cdf = 0.5 + erf((g_stim - mu)/(sd * sqrt(2)))/2;
        plot(g_stim, g_cdf, 'k-','LineWidth', 2.5);
    end 
end
