
cd('/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data')

subjects_in_directory = dir("*raw.csv");

for i = 1:length(subjects_in_directory)
    if i == 1
        combined_blocks_humans = readtable(subjects_in_directory(i).name);
    else
        combined_blocks_humans = [combined_blocks_humans; readtable(subjects_in_directory(i).name)];  %#ok<AGROW>
    end
end 
% Save the new table of combined data 
writetable(combined_blocks_humans, 'combined_blocks_humans_raw.csv')
