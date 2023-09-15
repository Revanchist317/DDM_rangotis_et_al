# Load all modules
import hddm
import multiprocessing as mp

# Load data
humans_all_data = hddm.load_csv('combined_blocks_humans.csv')

# Sort data based on stimulus displayed (RDK or SfM cylinder) and response mode (saccades or buttons)
humans_cylinder = humans_all_data[humans_all_data['stimulus_displayed'] == 'cylinder']
humans_dots = humans_all_data[humans_all_data['stimulus_displayed'] == 'dots']
humans_cylinder_saccades = humans_cylinder[humans_cylinder['response_mode'] == 'saccades']
humans_cylinder_buttons = humans_cylinder[humans_cylinder['response_mode'] == 'buttons']
humans_dots_saccades = humans_dots[humans_dots['response_mode'] == 'saccades']
humans_dots_buttons = humans_dots[humans_dots['response_mode'] == 'buttons']

# Put together a full combination of paramters since one model will be created for each
human_data = ['humans_cylinder_saccades', "humans_cylinder_buttons", "humans_dots_saccades", "humans_dots_buttons"]

# Either exclude or include inter-trial variability parameter estimation (BETWEEN trials)
# Optionally include inter-trial variability with: including_list = [('z'), ('z', 'sz', 'sv', 'st')]
# Note this is extremeley computationally demanding
including_list = [('z')]

# Initialise and print into terminal number of cores
pool = mp.Pool(mp.cpu_count())
print("Number of processors: ", mp.cpu_count())
Full_list_of_arguments = []


# Define the function to run
def run_MCMC_diff_data(n):
    data_input = human_data[n]
    v_reg = {'model': 'v ~ stim', 'link_func': lambda x: x}
    data_humans = {"humans_cylinder_saccades": humans_cylinder_saccades,
                   "humans_cylinder_buttons": humans_cylinder_buttons,
                   "humans_dots_saccades": humans_dots_saccades, "humans_dots_buttons": humans_dots_buttons}

    # Run the function as many times as we have members of the list of paramters
    for included in including_list:

        # Run the function 5 times to assess convergence
        for iteration in range(1, 6):
            label = "5percent_outlier_removal"
            model = hddm.HDDMRegressor(data_humans[data_input], v_reg, group_only_regressors=False,
                                       keep_regressor_trace=True, informative=False,
                                       is_group_model=True, include=included, trace_subjs=True, p_outlier=0.05)
            model.sample(5000, burn=200, dbname=str(data_input + '_' + str(included) + '_' + label +
                                                    str(iteration) + '.db'), db='pickle')
            model.save(str(data_input + '_' + str(included) + '_' + label + str(iteration)))


# Using list comprehension, run the function defined above for the full DDM
[pool.apply(run_MCMC_diff_data, args=[n]) for n in range(0, 4)]
