# Pre-processing
You can use the MATLAB code in the directory Behavioural_psychophysics_and_preprocessing to load the data, visualise it, removed outliers, and combine it so the subsequent DDM scripts can analyse it. Run RT_analysis_monkeys for the NHP data and the Behavioural_wrapper for the human data, then run combine_subjects and remove_outliers. 

# DDM
We used the [HDDM package ](https://hddm.readthedocs.io/en/latest/) from Wiecki et al., 2013. It was challenging to get the environment working and there was much trouble getting it to run on M1 MacBooks. I strongly recommend using [Docker](https://www.docker.com) with [this image](https://hub.docker.com/r/hcp4715/hddm). 

Run Human_DDM_pipeline_with_outlier_removal to fit the HDDM to the human data. 
