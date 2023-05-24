% GaborTracking: prefs.m
% Author: Ethan Pirso
% Description: Sets preferred Gabor patch stimulus parameters.
% Dependencies: None
% Called by: params.m (optional)
%
% Output variables in the workspace:
% - size: The preferred size of the Gabor patch stimulus in pixels.
% - viewingDistanceCm: The preferred distance from the observer to the screen in cm.
% - freqCpdDesired: The preferred spatial frequency of the Gabor patch in cycles per degree (CPD).
% - stepSize: The preferred step size of the Gabor patch movement in pixels.
% - dwellTime: The preferred time interval between each movement step of the Gabor patch in milliseconds.
% - conStep: The preferred step size for adjusting the contrast of the Gabor patch in percent decrease.
% - movement: The movement of the Gabor stimulus ("saccadic" or "smooth").
% - dist: The preferred distribution of the step size ("normal" or "uniform").

stimSize = 80;
viewingDistanceCm = 60;
freqCpdDesired = 4.5;
stepSize = 130;
dwellTime = 120;
conStep = 1.2;
movement = "smooth";
dist = "uniform"; 
