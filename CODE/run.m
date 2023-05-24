% GaborTracking: run.m
% Author: Ethan Pirso
% Description: Main script to run the Gabor tracking experiment, collect data, and save results.
% Dependencies: params.m, initWin.m, initEyelink.m, initGabor.m, collectData.m,
%              estimateError.m, updateGabor.m, closeEyelink.m, plotData.m
%
% Input variables in the workspace:
% - None
%
% Output variables in the workspace:
% - conThreshold: Contrast threshold when MAD of position error > 3.
% - dataFile: File name of the saved data file containing subject info, trial settings, and data.

clear; close all

params; % Initialize parameters for experiment
initWin; % Initialize PTB window
if ~demo
    initEyelink; % Initialize the Eyelink and start recording
end
initStim; % Initialize the stimulus

frame = 1; % frame counter
stop = 0; % flag for early trial stopping criterion

% Display instructions for 3 seconds at the beginning of the trial
DrawFormattedText(win, 'Track the stimulus. Press "esc" to escape.', ...
        'center', 300)
% Draw the stimulus
drawStim;
WaitSecs(3);

% Main loop to continuously draw the stimulus, collect data, and update position
tic;
while 1

    % Draw the update the position of stimulus
    drawStim;
    updateStim;

    if ~demo
        % Estimate error and apply early stopping criterion after 30 seconds
        if toc > 20
            estimateError; % estimates the real-time position error
    
            if stop % if the stop flag was raised by 'estimateError'
                break;
            end
        end
    end

    % Check for key presses and contrast > 0.1
    [~, ~, keyCode] = KbCheck();
    if keyCode(KbName('Escape')) || contrast <= 0.1
        break;
    end

end

% Close the window
Screen('Close', win);

if ~demo
    % Stop recording data and close the connection to the EyeLink tracker
    closeEyelink;
    
    % Plot Data
    plotData;
    
    % Save data
    dataFile = append(trialName,'.mat');
    save(dataFile,'subject','trial','diopters','stim','stimData','gazeData', ...
        'conThreshold','conCI','lag')
    movefile(dataFile,'../DATA/MAT')
end
