% Continuous Psychophysics with Eye Tracking (CPET): updateStim.m
% Author: Ethan Pirso
% Description: This script updates the position of the stimulus in each frame, based on the movement type 
%              (jitter or curvilinear trajectory) and the distribution of position updates (normal or uniform). 
%              In the case of curvilinear trajectory movement, the script also updates the contrast of the stimulus every 
%              14 frames. In the case of jitter movement, the script updates the contrast of the stimulus 
%              and includes a waiting time after each movement.
%
% Dependencies: collectData.m
% Called by: runCPET.m
%
% Input variables in the workspace:
% - movement: Movement type of the stimulus (jitter or curvilinear trajectory).
% - dist: Distribution type for the stimulus position updates (normal or uniform).
% - stepSize: Distance that the stimulus moves per step in jitter movement.
% - screenWidth, screenHeight: Screen dimensions in pixels.
% - stimSize: Stimulus size in pixels.
% - X, Y: Current coordinates of the stimulus.
% - conStep: Contrast reduction step.
% - dwellTime: Dwell time in jitter movement.
% - dwellFrames: Number of dwell frames in curvilinear trajectory.
% - frame: Current frame number.
% - xPosSmooth, yPosSmooth: Pre-calculated positions for smooth movement.
%
% Output variables in the workspace:
% - X, Y: Updated coordinates of the stimulus.
% - contrast: Updated contrast of the stimulus.

% Update position of the stimulus
switch movement

    case 1 % Jitter

        % Collect data from Eyelink and stimulus position
        collectData; 
    
        if dist == "n"
            mu = 0;
            sigma = 0.3;
            R = chol(sigma);
            z1 = repmat(mu,1,1) + randn(1)*R;
            z2 = repmat(mu,1,1) + randn(1)*R;
            X = X + z1 * stepSize;
            Y = Y + z2 * stepSize;
        
        elseif dist == "u"
            X = X + (rand() * 2 - 1) * stepSize;
            Y = Y + (rand() * 2 - 1) * stepSize;
        end
    
        % Lower contrast
        contrast = contrast * ((100-conStep) / 100);
    
        WaitSecs(dwellTime/1000);

    case 2 % Curvilinear trajectory
       
        if mod(frame, dwellFrames) == 0
            % Collect data from Eyelink and stimulus position
            collectData; 
            
            % Lower contrast
            contrast = contrast * ((100-conStep) / 100);
        end
    
        if frame <= numel(xPosSmooth)
    
            X = xPosSmooth(frame);
            Y = yPosSmooth(frame);
    
            frame = frame + 1;
        end
end

% Make sure the stimulus stays within the screen boundaries
X = min(max(X, 0), screenWidth - stimSize);
Y = min(max(Y, 0), screenHeight - stimSize);
