% GaborTracking: updateGabor.m
% Author: Ethan Pirso
% Description: Draws and updates the position of the Gabor patch based on the specified movement and distribution.
% Dependencies: collectData.m
% Called by: run.m
%
% Input variables in the workspace:
% - movement: The movement of the Gabor stimulus ("saccadic" or "smooth").
% - dist: Type of distribution for the Gabor patch position updates ("normal" or "uniform").
% - stepSize: Distance the Gabor patch moves per step.
% - screenWidth: Screen width in pixels.
% - screenHeight: Screen height in pixels.
% - tw: Gabor patch width in pixels.
% - th: Gabor patch height in pixels.
% - gaborX: Current x-coordinate of the Gabor patch.
% - gaborY: Current y-coordinate of the Gabor patch.
%
% Output variables in the workspace:
% - gaborX: Updated x-coordinate of the Gabor patch.
% - gaborY: Updated y-coordinate of the Gabor patch.

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
