
% Load the monkey data 
m133_dots = readtable('m133_dots_pp.csv');
m134_dots = readtable('m134_dots_pp.csv');
m133_cyl = readtable('m133_cyl_pp.csv');
m134_cyl = readtable('m134_cyl_pp.csv');

% Load the human data 
all_humans = readtable('combined_blocks_humans-2.csv');

% Create the first figure 
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

Cyl_list = {humans_cyl_saccades, humans_cyl_hand, m133_cyl, m134_cyl};
RDK_list = {humans_dots_saccades, humans_dots_hand, m133_dots, m134_dots};

% Psychometric_function_DDM
hold on 
Psychometric_function_DDM_v2(humans_cyl_saccades, "humans", 1)
Psychometric_function_DDM_v2(m133_cyl, "m133", 1)
Psychometric_function_DDM_v2(m134_cyl, "m134", 2)
hold off

% Do the legends
legend(["Humans", "m133", "m134"], "Location", "southeast")

title("Cylinder/saccades",  "FontSize", 25)

% RDK / saccades 
nexttile 
box on
xlim([-60, 60])
hold on
Psychometric_function_DDM_v2(humans_dots_saccades, "humans", 2)
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
Psychometric_function_DDM_v2(humans_cyl_hand, "humans", 3)
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
Psychometric_function_DDM_v2(humans_dots_hand, "humans", 4)
Psychometric_function_DDM_v2(m133_dots, "m133", 3)
Psychometric_function_DDM_v2(m134_dots, "m134", 4)
hold off 
ylabel('Proportion of "right" responses')
xlabel('(leftward motion)    Coherence [%]  (rightward motion)')
legend(["Humans", "m133", "m134"], "Location", "southeast")
title("RDK/hand",  "FontSize", 25)

%% Second figure, RT by task type
% Here we separate it by species as monkeys underwent the task on somewhat
% different values of difficulty (especially for the cylinder) and also had
% quite different RTs (again, especially for the cylinder). Therefore, the
% axes should be adjusted accordingly 

f2 = figure;
f2.Position = [187,250,1269,773];
tiledlayout(2, 2)

% Employ consistent colour scheme 
color_cyl = ["#FF8C00", "#c4290a", "#ff7b00", "#ffae00"];
color_RDK = ["#00b25f", "#0072B2", "#0074b2", "#6aa9bd"];

% Start with humans on the cylinder 
nexttile
xlabel('(leftward motion)    Disparity [DVA]  (rightward motion)')
ylabel('Mean reaction time');
xlim([-0.09, 0.09]);
ylim([0.45, 0.65])
ax = gca;
ax.FontSize = 16;
title('Cylinder reaction times (humans)',  "FontSize", 25)

hold on 
% Humans first 
for ikk = 1:2

    A = Cyl_list(ikk);    
    rt = A{1}.rt;
    difficulty = A{1}.stim;
    
    % Get unique difficulty levels
    uniqueDifficulty = unique(difficulty);
    
    % Initialize arrays to store average reaction time and SEM for each difficulty level
    avgRT = zeros(size(uniqueDifficulty));
    semRT = zeros(size(uniqueDifficulty));
    
    % Calculate average reaction time and SEM for each difficulty level
    for i = 1:length(uniqueDifficulty)
        subsetRT = rt(difficulty == uniqueDifficulty(i));
        avgRT(i) = mean(subsetRT);
        semRT(i) = std(subsetRT) / sqrt(length(subsetRT));
    end
    
    % Plot the data with error bars
    errorbar(uniqueDifficulty, avgRT, semRT, "Color", color_cyl(ikk), ...
        "LineStyle", '-', "LineWidth",3);
end 

hold off
legend(["Humans/saccades", "Humans/hand"], "Location", "northwest")

% Continue with monkeys on the cylinder 
nexttile(3)
xlabel('(leftward motion)    Disparity [DVA]  (rightward motion)')
ylabel('Mean reaction time');
xlim([-0.04, 0.04])
ylim([0.24, 0.28])
ax = gca;
ax.FontSize = 16;
title('Cylinder reaction times (monkeys)',  "FontSize", 25)

hold on
for ikk = 3:4

    A = Cyl_list(ikk);    
    rt = A{1}.rt;
    difficulty = A{1}.stim;
    
    % Get unique difficulty levels
    uniqueDifficulty = unique(difficulty);
    
    % Initialize arrays to store average reaction time and SEM for each difficulty level
    avgRT = zeros(size(uniqueDifficulty));
    semRT = zeros(size(uniqueDifficulty));
    
    % Calculate average reaction time and SEM for each difficulty level
    for i = 1:length(uniqueDifficulty)
        subsetRT = rt(difficulty == uniqueDifficulty(i));
        avgRT(i) = mean(subsetRT);
        semRT(i) = std(subsetRT) / sqrt(length(subsetRT));
    end
    
    % Plot the data with error bars
    errorbar(uniqueDifficulty, avgRT, semRT,"Color", color_cyl(ikk), ...
        "LineStyle", '-.', "LineWidth",3);
end 
hold off
legend(["m133/saccades", "m134/saccades"], "Location", "northwest")

% Continue with humans on the RDK
nexttile(2)
ax = gca;
ax.FontSize = 16;
xlabel('(leftward motion)    Coherence [%]  (rightward motion)')
ylabel('Mean reaction time');
title('RDK reaction times (humans)',  "FontSize", 25)
xlim([-60, 60])

hold on
for ikk = 1:2
    A = RDK_list(ikk);
    rt = A{1}.rt;
    difficulty = A{1}.stim;
    
    % Get unique difficulty levels
    uniqueDifficulty = unique(difficulty);
    
    % Initialize arrays to store average reaction time and SEM for each difficulty level
    avgRT = zeros(size(uniqueDifficulty));
    semRT = zeros(size(uniqueDifficulty));
    
    % Calculate average reaction time and SEM for each difficulty level
    for i = 1:length(uniqueDifficulty)
        subsetRT = rt(difficulty == uniqueDifficulty(i));
        avgRT(i) = mean(subsetRT);
        semRT(i) = std(subsetRT) / sqrt(length(subsetRT));
    end
    
    % Plot the data with error bars
    errorbar(uniqueDifficulty, avgRT, semRT,"Color", color_RDK(ikk), ...
        "LineStyle", '-', "LineWidth",3);
end 
hold off
legend(["Humans/saccades", "Humans/hand"], "Location", "northwest")

% And lastly monkeys on RDK 
nexttile(4)
xlabel('(leftward motion)    Coherence [%]  (rightward motion)')
ylabel('Mean reaction time');
xlim([-60, 60])
title('RDK reaction times (monkeys)',  "FontSize", 25)
ylim([0.3, 1])
ax = gca;
ax.FontSize = 16;

hold on 
for ikk = 3:4

    % Assuming you have a table named "humans_cyl_saccades"
    % with columns "rt" for reaction times and "stim" for difficulty
    
    % Extract data from the table
    A = RDK_list(ikk);
    rt = A{1}.rt;
    difficulty = A{1}.stim;
    
    % Get unique difficulty levels
    uniqueDifficulty = unique(difficulty);
    
    % Initialize arrays to store average reaction time and SEM for each difficulty level
    avgRT = zeros(size(uniqueDifficulty));
    semRT = zeros(size(uniqueDifficulty));
    
    % Calculate average reaction time and SEM for each difficulty level
    for i = 1:length(uniqueDifficulty)
        subsetRT = rt(difficulty == uniqueDifficulty(i));
        avgRT(i) = mean(subsetRT);
        semRT(i) = std(subsetRT) / sqrt(length(subsetRT));
    end
    
    % Plot the data with error bars
    errorbar(uniqueDifficulty, avgRT, semRT,"Color", color_RDK(ikk), ...
        "LineStyle", '-.', "LineWidth",3);
end 
hold off
legend(["m133/hand", "m134/hand"], "Location", "northwest")

%% RT by accuracy 

% Create a figure which spltis the RT for humans and monkeys on the task
% accuracy as well as task type 

f3 = figure;
f3.Position = [2,65,920,731];
tiledlayout(4, 2)

% Humans cylinder saccades
nexttile
Mean_RT_session(table2array(humans_cyl_saccades), "Cylinder saccades (humans)", "cyl_sac");
xlim([-0.09, 0.09])
xlabel(gca, "")


% Humans cylinder saccades
nexttile(3)
Mean_RT_session(table2array(humans_cyl_hand), "Cylinder hand (humans)", "cyl_sac");
xlim([-0.09, 0.09])
xlabel(gca, "")

nexttile(5)
Mean_RT_session(table2array(m133_cyl), "Cylinder saccades (m133)", "cyl_sac");
xlim([-0.04, 0.04])
xlabel(gca, "")

nexttile(7)
Mean_RT_session(table2array(m134_cyl), "Cylinder saccades (m134)", "cyl_sac");
xlim([-0.04, 0.04])

% RDK
nexttile(2)
Mean_RT_session(table2array(humans_dots_saccades), "RDK saccades (humans)", "cyl_sac");
xlim([-60, 60])
legend({'correct', 'incorrect', 'ambiguous'},'Location','northeastoutside', "FontSize",16)
ylabel(gca, "")
xlabel(gca, "")

% Humans cylinder saccades
nexttile(4)
Mean_RT_session(table2array(humans_dots_hand), "RDK hand (humans)", "cyl_sac");
xlabel(gca, "")
ylabel(gca, "")
xlim([-60, 60])

nexttile(6)
Mean_RT_session(table2array(m133_dots), "RDK hand (m133)", "cyl_sac");
xlabel(gca, "")
ylabel(gca, "")
xlim([-60, 60])

nexttile(8)
Mean_RT_session(table2array(m134_dots), "RDK hand (m134)", "dots_sac");
xlim([-60, 60])
ylabel(gca, "")
