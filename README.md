# Continuous Psychophysics with Eye Tracking (CPET)

### Author: Ethan Pirso

CPET is a MATLAB application for conducting continuous tracking experiments with an EyeLink eye tracker. It includes functions for initializing the stimulus, collecting gaze data, calculating position errors, and updating the stimulus position based on specified distributions. The application collects eye movement data and determines the contrast threshold of a subject. Data is saved in a structured format, and plots can be generated for analysis. The data can be used to assess contrast sensitivity and perform refraction.

## Contents

### CODE folder
    1. calc_freq_cpd.m: Calculates the required 'freq' parameter for a Gabor patch in Psychtoolbox based on the desired frequency in cycles per degree (CPD), screen size in centimeters, screen size in pixels, and viewing distance in centimeters.
    2. closeEyelink.m: Stops EyeLink data acquisition, closes the EDF file, downloads the output file, and shuts down the EyeLink system.
    3. collectData.m: Collects eye gaze data from the Eyelink and updates Gabor patch data.
    4. estimateError.m: Calculates position error in real-time and uses MAD as an early trial stopping criterion.
    5. initEyelink.m: Initializes the Eyelink eye tracker and configures the calibration type.
    6. initGabor.m: Initializes the position and properties of the Gabor patch stimulus.
    7. initWin.m: Sets up the Psychtoolbox (PTB) window and defines screen parameters.
    8. params.m: Initializes various parameters for the experiment, such as stimulus size, viewing distance, spatial frequency, step size, dwell time, and contrast step size.
    9. plotData.m: Generates plots of the target and subject gaze positions, normalized position error, and contrast.
    10. prefs.m: Sets preferred Gabor patch stimulus parameters.
    11. run.m: Main script to run the Gabor tracking experiment, collect data, and save results.
    12. updateGabor.m: Updates the position of the Gabor patch based on the specified distribution.

### DEMOS folder
    1. gaborWalk.m: A demo script to display a Gabor patch following a random walk trajectory.
    2. trackGaze.m: A demo script for gaze tracking using the EyeLink eye tracker.

### STIMULI folder
Contains the images for Aukland Optotypes and Marmoset stimuli.

## Getting Started
To begin using GaborTracking, navigate to the CODE folder and run the run.m script. This script will execute the Gabor tracking experiment, collect data, and save results.

## Dependencies
    • MATLAB
    • Psychtoolbox
    • EyeLink SDK (for eye tracking)
