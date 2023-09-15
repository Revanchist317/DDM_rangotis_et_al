function result = loglike(params, probit)

mean = params(1);
sd = params(2);

y = ([probit.x] - mean)./sd; % first half of Gaussian norm. dist. function: y = (x - mu) / sigma.
%
% p & q: creating the norm. dist. function predicted values for all 'x' (dx) from the sd and
% means (probit) passed to this function by its caller function.
%

p = (erf(y/sqrt(2)) +1)/2;  % second half of Gaussian norm. dist. function: p = 1/2(1 + erf(y / sqrt(2) ) ).
q = 1-p;

% Can't have log(0).
% ...so BGC replaced all zeros in p & q with the minimum matlab value (a common hack, see
% Geoff Boynton's code for CSH project as well) (NC).
p(p<1e-20) = 1e-20;
q(q<1e-20) = 1e-20;

%
% Calculating the -ve log of the likelihood function? This would describe
% the goodness of fit of the model (NC). The  model with the largest
% likelihood value is the best-fitting model i.e. the MNE (maximum likelihood estimate).
%
% 1. Multiplying the number of responses at each dx by the log probability of
% their occurance as calculated above using the normal distribution.

% Is it valid to ignore the binomial coefficient in the equation below?
% The relevant binomial coefficient is supposed to be added to each dx binomial log-likelihood
% function calculation. The binomial coefficient for each dx is the same
% for both model fits. Since the same amount overall is added to each
% model's log-likelihood value, and these 2 model's values are substracted
% from each other to get the chi2-test variable, whether the binomial
% coefficient is included in the log-likehood calculation does not matter
% since it is only the relative difference that is used in the chi2-test.
% Hence this constant can be safely ignored for these stat purposes (NC).

result = sum( (([probit.n] - [probit.resps]) .* log(q)) + ([probit.resps] .* log(p) ) );

% 2. Making it negative:
result = -result;