# Introduction
This code is part of the publication "Distinct decision processes for 3D and motion stimuli in both humans and monkeys revealed by drift diffusion modelling", 2024. 

# Pre-processing
You can use the MATLAB code in the directory Behavioural_psychophysics_and_preprocessing to load the data, visualise it, removed outliers, and combine it so the subsequent DDM scripts can analyse it. Run RT_analysis_monkeys for the NHP data and the Behavioural_wrapper for the human data, then run combine_subjects and remove_outliers. Psychometric_comparison_H_and_M reproduces the top part of Figure 2. There is also an alternative pre-processing pathway for the GLM-HMM analysis which removes all trials without any previous trials (this is necessary for correct the covariate "Previous Choice" weight estimation). See the GLM_pre_processing flag in Behavioural_wrapper for the humans; monkeys are done separately in the Python code because of a difference in trial structure (no blocks). 

# DDM
We used the [HDDM package ](https://hddm.readthedocs.io/en/latest/) from Wiecki et al., 2013. It was a bit challenging to get the environment working and there was some trouble getting it to run on M1 MacBooks. I strongly recommend using [Docker](https://www.docker.com) with [this image](https://hub.docker.com/r/hcp4715/hddm). 

Run Human_DDM_pipeline_with_outlier_removal to fit the HDDM to the human data. RT_full_combined creates Figure 2. 
