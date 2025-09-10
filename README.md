# BLAPIRmanuscript
Data and code to replicate the figures in the manuscript Differential encoding of social identity, valence and unfamiliarity in the amygdala and piriform cortex. Mazuski C, Oettl L-L, Ren C, &amp; O'Keefe J.

This directory contains 4 folders with the necessary data/scripts to plot the panels in figures1-4 of the paper entitled 
Differential encoding of social identity, valence and unfamiliarity in the amygdala and piriform cortex. Mazuski C, Oettl L-L, Ren C, & O'Keefe J.

Figure1
Data
- learning_curve : contains the accuracy per session for each animal for all initial learning sessions
- days_until_criterion: contains the day/session when each animal reached criterion
- first_last_rates: contains the hit rates and false alarm rates for each animal for the first and last session
- olfactory_block: contains the accuracy values per animal before and after the block of olfactory cues
- visual_block: contains the accuracy values per animal before and after the block of visual cues
- plot_data: contains the accuracy values in blocks of 20 trials for each session of animal 'BLA04' across the whole experiment

Figure2
Data
- data_timewarped: individual neuronal firing data from every task trial 
(numtrials x 40timepoints)
	- timepoints 0-10 = baseline, t10-20 = sensory, t20-30 = action, t30-40 = outcome
	- trials = individual trials from first to last. foldername indicates which trials are included (i.e. prelearning, postlearning)
- averaged trial responses for all neurons for S+ or S- stored in data_timewarped/prelearning.npy or data_timewarped/postlearning.npy
- masterlist_experiment1task includes information on all units recorded during the social reward task


Figure3
Data
- same as above except data_timewarped includes the following variations
catchtrials/ (i.e. probe trials or non-task animals. These are the responses to the novelmale and female)
alltrials/ includes all trials in sequential order
trials_early.npy - mean responses to S+/S- during early presentations
responsiveneurons_earlytrials/ arrays showing which neurons were 'responsive' to the S+/S- (early trails) or the probetrial animals


Figure4
Data
NaturalisticSocial/ includes a folder per recording day that includes the following data:
Events.csv - file containing timestamps for presentation of the 4 conspecifics for natural social interaction
Behavior/ includes subfolders for each interaction with the features including interindividual distance
Neurons/ includes the timestamps for all neurons recorded during naturalistic behavior

experiment1freelymoving.csv - masterlist for all neurons recorded during naturalistic behavior
experiment1_taskfreelymovingspecificity - masterlist for all neurons continuously recorded from task to naturalistic beahvior and their specificity scores used to determine whether a neuron is task-specific, non-task specific, general selectivity or nonresponsive



