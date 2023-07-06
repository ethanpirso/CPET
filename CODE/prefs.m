% Continuous Psychophysics with Eye Tracking (CPET): prefs.m
% Author: Ethan Pirso
% Description: Sets the preferred parameters for the stimulus in the experiment.
%              These preferences can be manually adjusted according to the requirements of the experiment.
% Dependencies: None
% Called by: params.m (optional)
%
% Output variables in the workspace:
% - stimSize: Preferred size of the stimulus in pixels.
% - viewingDistanceCm: Preferred distance between the observer and the screen in centimeters.
% - freqCpdDesired: Preferred spatial frequency of the stimulus in cycles per degree (CPD).
% - stepSize: Preferred step size for stimulus movement in pixels.
% - dwellTime: Preferred time interval between each movement step of the stimulus in milliseconds.
% - dwellFrames: Preferred number of frames between each stimulus update.
% - conStep: Preferred step size for adjusting the contrast of the stimulus, expressed as a percent decrease.
% - movement: Preferred type of stimulus movement, either "saccadic" or "smooth".
% - dist: Preferred distribution for the step size, either "normal" or "uniform".

stimSize = 80;
viewingDistanceCm = 80;
freqCpdDesired = 4.5;
stepSize = 130;
dwellTime = 120;
dwellFrames = 14;
conStep = 1;
movement = 2;
dist = "u"; 