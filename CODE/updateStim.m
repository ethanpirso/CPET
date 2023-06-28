% Continuous Psychophysics with Eye Tracking (CPET): updateStim.m
% Author: Ethan Pirso
% Description: This script updates the position of the stimulus in each frame, based on the movement type 
%              ("smooth" or "saccadic") and the distribution of position updates ("normal" or "uniform"). 
%              In the case of smooth movement, the script also updates the contrast of the stimulus every 
%              14 frames. In the case of saccadic movement, the script updates the contrast of the stimulus 
%              and includes a waiting time after each movement.
%
% Dependencies: collectData.m
% Called by: runCPET.m
%
% Input variables in the workspace:
% - movement: Movement type of the stimulus ("smooth" or "saccadic").
% - dist: Distribution type for the stimulus position updates ("normal" or "uniform").
% - stepSize: Distance that the stimulus moves per step.
% - screenWidth, screenHeight: Screen dimensions in pixels.
% - stimSize: Stimulus size in pixels.
% - X, Y: Current coordinates of the stimulus.
% - conStep: Contrast reduction step.
% - dwellTime: Dwell time in saccadic movement.
% - frame: Current frame number.
% - xPosSmooth, yPosSmooth: Pre-calculated positions for smooth movement.
%
% Output variables in the workspace:
% - X, Y: Updated coordinates of the stimulus.
% - contrast: Updated contrast of the stimulus.

% Update position of the Gabor
if movement == "smooth"

    if mod(frame, 14) == 0
        % Collect data from Eyelink and gabor position
        collectData; 
        
        % Lower contrast
        contrast = contrast * ((100-conStep) / 100);
    end

    if frame <= numel(xPosSmooth)

        X = xPosSmooth(frame);
        Y = yPosSmooth(frame);

        frame = frame + 1;
    end

else % movement == "saccadic"

    % Collect data from Eyelink and gabor position
    collectData; 

    if dist == "normal"
        mu = 0;
        sigma = 0.3;
        R = chol(sigma);
        z1 = repmat(mu,1,1) + randn(1)*R;
        z2 = repmat(mu,1,1) + randn(1)*R;
        X = X + z1 * stepSize;
        Y = Y + z2 * stepSize;
    
    else % dist == "uniform"
        X = X + (rand() * 2 - 1) * stepSize;
        Y = Y + (rand() * 2 - 1) * stepSize;
    end

    % Lower contrast
    contrast = contrast * ((100-conStep) / 100);

    WaitSecs(dwellTime/1000);

end

% Make sure the Gabor stays within the screen boundaries
X = min(max(X, 0), screenWidth - stimSize);
Y = min(max(Y, 0), screenHeight - stimSize);
