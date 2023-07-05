% calc_freq_cpd: calc_freq_cpd.m
% Author: Ethan Pirso
% Description: Function to calculate the required 'freq' parameter for a Gabor patch in Psychtoolbox based on the desired frequency in
%              cycles per degree (CPD), screen size in centimeters, screen size in pixels, and viewing distance in centimeters.
%
% Inputs:
% - screen_width_cm: Screen width in centimeters
% - screen_width_px: Screen width in pixels
% - viewing_distance_cm: Viewing distance in centimeters
% - freq_cpd_desired: Desired frequency in cycles per degree (CPD)
%
% Output:
% - freq: Frequency in cycles per pixel

function freq = calc_freq_cpd(screen_width_cm, screen_width_px, viewing_distance_cm, freq_cpd_desired)

    % Calculate the number of pixels per centimeter
    pix_per_cm = screen_width_px / screen_width_cm;

    % Calculate the number of centimeters per degree of visual angle
    cm_per_deg = viewing_distance_cm * tan(deg2rad(1));

    % Calculate the number of pixels per degree of visual angle
    pix_per_deg = pix_per_cm * cm_per_deg;

    % Calculate the frequency in cycles per pixel
    freq = freq_cpd_desired / pix_per_deg;
    
end
