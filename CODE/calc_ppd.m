% calc_ppd: calc_ppd.m
% Author: Ethan Pirso
% Description: Function to calculate the number of pixels per degree of visual angle based on
%              screen size in centimeters, screen size in pixels, and viewing distance in centimeters.
%
% Inputs:
% - screen_width_cm: Screen width in centimeters
% - screen_width_px: Screen width in pixels
% - viewing_distance_cm: Viewing distance in centimeters
%
% Output:
% - pix_per_deg: Number of pixels per degree of visual angle

function pix_per_deg = calc_ppd(screen_width_cm, screen_width_px, viewing_distance_cm)

    % Calculate the number of pixels per centimeter
    pix_per_cm = screen_width_px / screen_width_cm;

    % Calculate the number of centimeters per degree of visual angle
    cm_per_deg = viewing_distance_cm * tan(deg2rad(1));

    % Calculate the number of pixels per degree of visual angle
    pix_per_deg = pix_per_cm * cm_per_deg;
    
end
