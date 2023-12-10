%% Introduction
% Revan Rangotis 2022 

% default folder
cd('/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data_monkeys')

% Save the figures? 
Save_figures = 0; 

% This script serves pre-processing for the reaction time (RT) data for the
% m133 (Tornado) and m134 (Turtle) data for the DDM project. 

% Load the data 
dots_133 = readtable('m133_dots_raw.csv') ;
dots_134 = readtable('m134_dots_raw.csv') ;
cyl_133 = readtable('m133_cylinder_raw.csv');
cyl_134 = readtable('m134_cylinder_raw.csv');

% Cutoff points. For RDK, the decision is easy and mirrors human
% distribution and the literature. For the clinder, this was far more
% complicated and will likely be contended but the vast majority of quick
% reaction times were wild guesses, as one can see from the plot of RT
% against difficulty. Therefore, I chose the value of 0.19 to reflect what
% Gold and Shadlen suggested in their annual reviews paper 
cyl_l_cutoff = 0.19;
RDK_l_cutoff = 0.25;

%% Cylinder data
% The cylinder data is raw, meaning no trials were removed, except for one
% session on the grounds of low acccuracy. The stimulus data points have 
% not been normalised. 

% Visualisation

% m133
% Lower cut-off
f = figure;
tiledlayout(2, 2) 
nexttile
m133_cylinder_h_figure = histogram(cyl_133.rt);
title("m133 cylinder")
xl1 = xline(cyl_l_cutoff, '-', "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl1.LabelHorizontalAlignment = 'left';
xlim([0 0.6])
xlabel("Reaction time [seconds]")
ylabel("Count") 


% Upper cut-off
% I suggest we go with the 99th percentile 
cyl_u_cutoff_m133 = (quantile(cyl_133.rt, 0.99));
xline(cyl_u_cutoff_m133, '-', "Upper cutoff", "FontSize", 16, "LineWidth", 2);
set(gca, "FontSize", 17)

% m134
% Lower cut-off
nexttile(3) 
m134_cylinder_h_figure = histogram(cyl_134.rt);
title("m134 cylinder")
xl2 = xline(cyl_l_cutoff, '-', "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl2.LabelHorizontalAlignment = 'left';
xlabel("Reaction time [seconds]")
ylabel("Count") 

% Upper cut-off
cyl_u_cutoff_m134 = (quantile(cyl_134.rt, 0.99));
xline(cyl_u_cutoff_m134, '-', "Upper cutoff", "FontSize", 16, "LineWidth", 2);
xlim([0 0.6])
set(gca, "FontSize", 17)

% Removal of outlier data
% m133
cyl_133(cyl_133.rt < cyl_l_cutoff | cyl_133.rt > cyl_u_cutoff_m133, :) = [];

% m134
cyl_134(cyl_134.rt < cyl_l_cutoff | cyl_134.rt > cyl_u_cutoff_m134, :) = [];

%% RDK data

% Visualisation
% m133
% Lower cut-off
nexttile
m133_dots_h_figure = histogram(dots_133.rt);
title("m133 RDK")
xl3 = xline(RDK_l_cutoff, '-', "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl3.LabelHorizontalAlignment = 'left';
xlabel("Reaction time [seconds]")
ylabel("Count") 
set(gca, "FontSize", 17)
xlim([0 2])

% Upper cut-off
% I suggest we go with the 98th percentile 
RDK_u_cutoff_m133 = (quantile(dots_133.rt, 0.98));
xline(RDK_u_cutoff_m133, '-', "Upper cutoff", "FontSize", 16, "LineWidth", 2);

% m134
% Lower cut-off
nexttile
m134_dots_h_figure = histogram(dots_134.rt);
title("m134 RDK")
xl4 = xline(RDK_l_cutoff, '-', "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl4.LabelHorizontalAlignment = 'left';
xlabel("Reaction time [seconds]")
ylabel("Count") 
xlim([0 2])

% Upper cut-off
RDK_u_cutoff_m134 = (quantile(dots_134.rt, 0.98));
xline(RDK_u_cutoff_m134, '-', "Upper cutoff", "FontSize", 16, "LineWidth", 2);
set(gca, "FontSize", 17)

% Make the figure a little larger 
f.Position = [366,251,1271,776];
sgtitle("Outlier removal, monkey data", 'FontWeight', 'bold', 'FontSize', 30);

% Removal 
% m133
dots_133(dots_133.rt < RDK_l_cutoff | dots_133.rt > RDK_u_cutoff_m133, :) = [];

% m134
dots_134(dots_134.rt < RDK_l_cutoff | dots_134.rt > RDK_u_cutoff_m134, :) = [];

% Save the newly made files 
writetable(dots_133, 'm133_dots_pp.csv')
writetable(dots_134, 'm134_dots_pp.csv')
writetable(cyl_133, 'm133_cyl_pp.csv')
writetable(cyl_134, 'm134_cyl_pp.csv')
