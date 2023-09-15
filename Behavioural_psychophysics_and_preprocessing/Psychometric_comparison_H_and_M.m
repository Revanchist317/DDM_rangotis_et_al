
% Load the monkey data 
m133_dots = readtable('m133_dots_pp.csv');
m134_dots = readtable('m134_dots_pp.csv');
m133_cyl = readtable('m133_cyl_pp.csv');
m134_cyl = readtable('m134_cyl_pp.csv');

% Load the human data 
all_humans = readtable('combined_blocks_humans.csv');

% Create the figure 
f = figure;
f.Position = [187,250,1269,773];
tiledlayout("flow")
nexttile 

% Start with cylinder/saccades
xlabel('(leftward motion)    Disparity [DVA]  (rightward motion)')
ylabel('Proportion of "right" responses')
xlim([-0.09, 0.09])
box on

% Extract relevant human data 
humans_cyl_saccades = all_humans(string(all_humans.stimulus_displayed) ...
    == 'cylinder' & string(all_humans.response_mode) == 'saccades', 1:5);
humans_cyl_hand = all_humans(string(all_humans.stimulus_displayed) ...
    == 'cylinder' & string(all_humans.response_mode) == 'buttons', 1:5);
humans_dots_saccades = all_humans(string(all_humans.stimulus_displayed) ...
    == 'dots' & string(all_humans.response_mode) == 'saccades', 1:5);
humans_dots_hand = all_humans(string(all_humans.stimulus_displayed) ...
    == 'dots' & string(all_humans.response_mode) == 'buttons', 1:5);

humans_cyl_saccades.stim = humans_cyl_saccades.stim*0.08;
humans_cyl_hand.stim = humans_cyl_hand.stim*0.08;

humans_dots_hand.stim = humans_dots_hand.stim*50; 
humans_dots_saccades.stim = humans_dots_saccades.stim*50; 

% Psychometric_function_DDM
hold on 
Psychometric_function_DDM_v2(humans_cyl_saccades, "humans")
Psychometric_function_DDM_v2(m133_cyl, "m133")
Psychometric_function_DDM_v2(m134_cyl, "m134")
hold off

% Do the legends
legend(["Humans", "m133", "m134"], "Location", "southeast")

title("Cylinder/saccades",  "FontSize", 25)

% RDK / saccades 
nexttile 
box on
xlim([-60, 60])
hold on
Psychometric_function_DDM_v2(humans_dots_saccades, "humans")
hold off 
ylabel('Proportion of "right" responses')
xlabel('(leftward motion)    Coherence [%]  (rightward motion)')
legend("Humans", "Location", "southeast")
title("RDK/saccades",  "FontSize", 25)

% Cylinder / hand 
nexttile 
box on
xlim([-0.09, 0.09])
hold on
Psychometric_function_DDM_v2(humans_cyl_hand, "humans")
hold off 
ylabel('Proportion of "right" responses')
xlabel('(leftward motion)    Disparity [DVA]  (rightward motion)')
legend("Humans", "Location", "southeast")
title("Cylinder/hand",  "FontSize", 25)

% RDK / hand 
nexttile 
box on
xlim([-60, 60])
hold on 
Psychometric_function_DDM_v2(humans_dots_hand, "humans")
Psychometric_function_DDM_v2(m133_dots, "m133")
Psychometric_function_DDM_v2(m134_dots, "m134")
hold off 
ylabel('Proportion of "right" responses')
xlabel('(leftward motion)    Coherence [%]  (rightward motion)')
legend(["Humans", "m133", "m134"], "Location", "southeast")
title("RDK/hand",  "FontSize", 25)

