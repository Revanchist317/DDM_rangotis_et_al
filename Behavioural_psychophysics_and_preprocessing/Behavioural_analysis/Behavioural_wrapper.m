% Wrapper for behavioural data analysis
% written by Revan Rangotis, March 2022 

IDs_in_directory = ["002" "003" "004" "005" "006" "007" "008" "009" "011" "012" "013" "014" "015" "016" "017" "018" "019" "020" "021" "023"];
Save_figures = 0; % Change this to save the figures into a folder
Save_files = 1; % Change this to save the final data file into a folder
Show_figures = 'off'; % For performance keep to 'off'
analyse_ind_blocks = 1;
GLM_pre_processing = 1; % This flag simply removes the first trial of each block

psychometric_description = cell(20, 4);
ijk = 1;

% Loop through subjects
for i = 1:length(IDs_in_directory)
    subject_id = IDs_in_directory(i); % Select the appropriate subject ID
    paradigms_list = ["cyl_butt" "cyl_sac" "dots_butt" "dots_sac"];
    paradigm_names_list = ["cylinder_buttons" "cylinder_saccades" "dots_buttons" "dots_saccades"];
    
    % Loop through experimental paradigms 
    for k = 1:4 
        paradigm = paradigms_list(k); % Choose the appropriate paradigm 
        paradigm_name = paradigm_names_list(k); 
        path = ("/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data/responses_" + paradigm);
        cd(path) % Change the current directory to access the relevant data
        files_in_directory = dir("DDM_" + subject_id + "*");
        
        %% Pre-processing for outlier removal 
        
        % Pre-allocate cells 
        a = cell(15, 1); 
        b = cell(15, 2); 

        % Assignment of blocks to training or experimental, since we had
        % some training blocks to familiarise the participants with the
        % task which are not included in the final analysis 
        for ii = 1:length(files_in_directory)
            a(ii) = {files_in_directory(ii).name};
            if contains(a(ii), "_t_")
                current_block = readtable(files_in_directory(ii).name);
                match = wildcardPattern + "_";
                block_number = erase(files_in_directory(ii).name, [match, ".txt"]);
                block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + block_number + " (training)"); 
                block_name = strrep(block_name, '_', " ");
                b{ii, 2} = "Training";
            else
                current_block = readtable(files_in_directory(ii).name);
                match = wildcardPattern + "_";
                block_number = erase(files_in_directory(ii).name, [match, ".txt"]);
                block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + block_number); 
                block_name = strrep(block_name, '_', " ");
                b{ii, 2} = "Experimental";
            end 
            b{ii, 1} = current_block;
        end
                
        % Remove empty cells
        b((cellfun('isempty',b(:, 1))), :) = []; 
         
        % Remove incorrect coding, this happened then the software bugged 
        % out or other trouble occurred     
        for m = 1:length(b)
            
            for iokl = 1:nnz([b{:, 2}] == "Experimental")
                
                b{iokl, 1}(b{iokl, 1}.RT == 999, :) = []; 
                b{iokl, 1}(b{iokl, 1}.Accuracy == 999, :) = []; 
                b{iokl, 1}(b{iokl, 1}.FixationOnset == 999000, :) = []; 
                b{iokl, 1}(b{iokl, 1}.StimulusOnset == 999000, :) = []; 
                b{iokl, 1}(b{iokl, 1}.ResponseTime == 999000, :) = [];
                b{iokl, 1}(b{iokl, 1}.ToneOnset == 999000, :) = []; 
                b{iokl, 1}.Previous_response = ones(height(b{iokl, 1}), 1)*2; 

                if iokl == 1 
                    combined_blocks_outl = b{iokl, 1}; 
                else
                    combined_blocks_outl = [combined_blocks_outl; b{iokl, 1}]; %#ok<AGROW>
                end
            end
            
            % Combine the experimental blocks together into one table
            % claled 'combined_blocks' 
            
            if b{m, 2} == "Experimental"

                if GLM_pre_processing
                    b{m, 1}.Previous_response = ones(height(b{m, 1}), 1)*2; 
                    b{m, 1}.Previous_response(2:end) = b{m, 1}.Response(1:end-1);
                    b{m, 1}(1, :) = [];
                end 
                
                if m == 1
                    combined_blocks = b{m, 1}; 
                else
                    combined_blocks = [combined_blocks; b{m, 1}]; %#ok<AGROW>
                end

            end 
        end
       
        %% Block-by-block analysis for RT and psychometric functions 
        
        % This is only relevant for piloting purposes to visually inspect
        % how the individual subjets performed 
        if analyse_ind_blocks

            figure('visible', Show_figures); % Open first figure

            % Allow a variable number of sub-figures to be displayed
            final_figure_RT = tiledlayout('flow'); 

            % Initialise a separate counter for training blocks 
            train_block_counter = 1; 

            % Experimental blocks - RT/psychometric     
            for j = 1:length(b)
                block_cur = b{j, 1}; 
                match = wildcardPattern + "_";
                block_number = j;

                if b{j, 2} == "Training"
                    block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + train_block_counter + " (training)"); 
                    train_block_counter = train_block_counter + 1;
                else
                    block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + block_number);
                end 

                block_name = strrep(block_name, '_', " ");
                nexttile 
                block_cur = table2array(block_cur); 
            end

            figure('visible', Show_figures);
            final_figure_psychometric = tiledlayout('flow');
            
            % Re-initialise a separate counter for training blocks 
            train_block_counter = 1; 

            % Training blocks psychometric
            for j = 1:length(b)
                block_cur = b{j, 1}; 
                match = wildcardPattern + "_";
                block_number = j;

                if b{j, 2} == "Training"
                    block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + train_block_counter + " (training)"); 
                    train_block_counter = train_block_counter + 1;
                else
                    block_name = ("subject" + subject_id + "_" + paradigm_name + "_" + block_number);
                end 

                block_name = strrep(block_name, '_', " ");
                nexttile 
                block_cur = table2array(block_cur); 
            end

        end 
       
        %% Blocks combined analysis 
        
        % Array from table 
        combined_blocks_analysis = table2array(combined_blocks);
        
        % Make a single name
        combined_name = ("subject" + subject_id + " " + paradigm_name + " combined"); 
        combined_name = strrep(combined_name, '_', " ");
        
        % Analyse and plot RT + psychometric curves 
        C_final_figure_RT = figure('visible', Show_figures);
        Mean_RT_session(combined_blocks_analysis, combined_name, paradigm); 
        
        C_final_figure_psycho = figure('visible', Show_figures);
        ijk = ijk + 1;
        
        % Saving the figures 
        if Save_figures

            if ~isfolder('figures') 
                mkdir figures
            end 

            cd figures % move to folder
            saveas(final_figure_RT, "separate_blocks_rt_" + subject_id + ".fig")
            saveas(C_final_figure_RT, "combined_blocks_rt" + subject_id + ".fig")
            saveas(final_figure_psychometric, "separate_blocks_psych" + subject_id + ".fig")
            saveas(C_final_figure_psycho, "combined_blocks_psych_" + subject_id + ".fig")

        end 
        
        % Normalise the stimulus 
        combined_blocks.Stimulus(:) = combined_blocks.Stimulus(:)/max(combined_blocks.Stimulus);
        
        %% Saving the processed files
        
        resp_mode = erase(paradigm_name, [match, "_"]);
        stimulus_displayed = erase(paradigm_name, resp_mode);
        stimulus_displayed = erase(stimulus_displayed, '_');
        
        combined_blocks.resp_mode(:) = resp_mode;
        combined_blocks.stimulus_displayed(:) = stimulus_displayed;
        
        if Save_files
            ID_list = zeros(height(combined_blocks), 1); 
            ID_list(:) = subject_id;
            file_for_save = table(ID_list, combined_blocks.Stimulus, combined_blocks.RT, combined_blocks.Response, combined_blocks.Accuracy, combined_blocks.stimulus_displayed, combined_blocks.resp_mode, combined_blocks.Previous_response);
            file_for_save.Properties.VariableNames = ["subj_idx" "stim" "rt" "response" "accuracy" "stimulus_displayed" "response_mode" "previous response"];

            if k == 1
                final_file = file_for_save;
            else
                final_file = [final_file; file_for_save]; 
            end

        end
        
        % Close the figures 
        close all 
    end
    
    if Save_files   

        if GLM_pre_processing
            cd('/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data')
            writetable(final_file, subject_id + "raw_GLM" + '.csv')
        else
            % Change this to your local directory 
            cd('/Users/revanhome/Desktop/Magdeburg/DDM/Behavioural_psychophysics_and_preprocessing/Behavioural_data')
            writetable(final_file, subject_id + "raw" + '.csv')
        end 
    end
end
