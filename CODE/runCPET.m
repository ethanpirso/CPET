% Continuous Psychophysics with Eye Tracking (CPET): runCPET.m
% Author: Ethan Pirso
% Description: This main script orchestrates the tracking experiment. It initiates the experiment parameters, 
%              window, and stimuli, then proceeds to start recording via the EyeLink device. The script then enters 
%              a loop, during which it draws and updates the stimuli, collects and estimates data errors in real-time, 
%              applies an early stopping criterion (after 30 seconds), and checks for keypresses and contrast levels. 
%              Upon completion of the loop, the script closes the PTB window, halts recording and disconnects from 
%              the EyeLink device, plots data, and saves the data in a specific file. 
% Dependencies: params.m, initWin.m, initEyelink.m, initStim.m, collectData.m,
%              estimateError.m, drawStim.m, updateStim.m, closeEyelink.m, plotData.m
%
% Input variables in the workspace:
% - None
%
% Output variables in the workspace:
% - dataFile: The name of the saved data file which contains the following details: 
%             subject identification, trial number, diopter value, stimulus selection, stimulus data, gaze data, 
%             contrast threshold, contrast confidence interval, and lag.

clear; close all

params; % Initialize parameters for experiment
initWin; % Initialize PTB window
if ~demo
    initEyelink; % Initialize the Eyelink
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
        if toc > 30
            estimateError; % estimates the real-time position error
    
            if stop % if the stop flag was raised by 'estimateError'
                break;
            end
        end
    end

    % Check for key presses and contrast > 0.05
    [~, ~, keyCode] = KbCheck();
    if keyCode(KbName('Escape')) || contrast <= 0.05
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
    save(dataFile);
    movefile(dataFile,'../DATA/MAT');
end
