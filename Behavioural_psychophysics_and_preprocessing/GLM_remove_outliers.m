% This script serves to remove outliers from the raw data

comb_subj_raw = readtable("combined_blocks_humans_raw_GLM.csv"); 

% Plot the RT histograms of each task
rt_cyl_butt = comb_subj_raw.rt(comb_subj_raw.stimulus_displayed == "cylinder" & comb_subj_raw.response_mode == "buttons", :);
rt_cyl_sac = comb_subj_raw.rt(comb_subj_raw.stimulus_displayed == "cylinder" & comb_subj_raw.response_mode == "saccades", :);
rt_dots_butt =comb_subj_raw.rt(comb_subj_raw.stimulus_displayed == "dots" & comb_subj_raw.response_mode == "buttons", :);
rt_dots_sac = comb_subj_raw.rt(comb_subj_raw.stimulus_displayed == "dots" & comb_subj_raw.response_mode == "saccades", :);

f = figure;
tiledlayout("flow")

nexttile
histogram(rt_cyl_sac)
% xline(mean(rt_cyl_sac),"-", "mean")
title("Cylinder/saccades")
q2 = quantile(rt_cyl_sac, 0.95);
xlabel("Reaction time [seconds]")
ylabel("Count")
xline(q2, "-", "Upper cutoff", "FontSize", 16, "LineWidth", 2);
xl1 = xline(.25, "-", "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl1.LabelHorizontalAlignment = 'left';
set(gca, "FontSize", 17)
xlim([0 3])

nexttile
histogram(rt_dots_sac)
% xline(mean(rt_dots_sac),"-", "mean")
title("RDK/saccades")
q4 = quantile(rt_dots_sac, 0.95);
xlabel("Reaction time [seconds]")
ylabel("Count")
xline(q4, "-", "Upper cutoff", "FontSize", 16, "LineWidth", 2);
xl2 = xline(.25, "-", "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl2.LabelHorizontalAlignment = 'left';
set(gca, "FontSize", 17)
xlim([0 3.5])

nexttile
histogram(rt_cyl_butt)
% xline(mean(rt_cyl_butt),"-", "mean")
title("Cylinder/hand")
q1 = quantile(rt_cyl_butt, 0.95);
xlabel("Reaction time [seconds]")
ylabel("Count")
xline(q1, "-", "Upper cutoff", "FontSize", 16, "LineWidth", 2);
xl3 = xline(.25, "-", "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl3.LabelHorizontalAlignment = 'left';
set(gca, "FontSize", 17)
xlim([0 3])

nexttile
histogram(rt_dots_butt)
% xline(mean(rt_dots_butt),"-", "mean")
title("RDK/hand")
q3 = quantile(rt_dots_butt, 0.95);
xlabel("Reaction time [seconds]")
ylabel("Count")
xline(q3, "-", "Upper cutoff", "FontSize", 16, "LineWidth", 2);
xl4 = xline(.25, "-", "Lower cutoff", "FontSize", 16, "LineWidth", 2);
xl4.LabelHorizontalAlignment = 'left';
set(gca, "FontSize", 17)
xlim([0 3.5])

f.Position = [366,251,1271,776];
sgtitle("Outlier removal, human data", 'FontWeight', 'bold', 'FontSize', 30);

comb_subj_raw(comb_subj_raw.rt < 0.250, :) = [];
comb_subj_raw(comb_subj_raw.stimulus_displayed == "cylinder" & comb_subj_raw.response_mode == "buttons" & comb_subj_raw.rt > q1, :) = [];
comb_subj_raw(comb_subj_raw.stimulus_displayed == "cylinder" & comb_subj_raw.response_mode == "saccades" & comb_subj_raw.rt > q2, :) = [];
comb_subj_raw(comb_subj_raw.stimulus_displayed == "dots" & comb_subj_raw.response_mode == "buttons" & comb_subj_raw.rt > q3, :) = [];
comb_subj_raw(comb_subj_raw.stimulus_displayed == "dots" & comb_subj_raw.response_mode == "saccades" & comb_subj_raw.rt > q4, :) = [];

writetable(comb_subj_raw, 'combined_blocks_humans_GLM.csv')
