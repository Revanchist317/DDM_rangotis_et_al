
cd('/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data')
a = cell(25, 1); 
subjects_in_directory = dir("*raw_GLM.csv");

for i = 1:length(subjects_in_directory)
    if i == 1
        combined_blocks_humans = readtable(subjects_in_directory(i).name);
    else
        combined_blocks_humans = [combined_blocks_humans; readtable(subjects_in_directory(i).name)];  %#ok<AGROW>
    end
end 

writetable(combined_blocks_humans, 'combined_blocks_humans_raw_GLM.csv')