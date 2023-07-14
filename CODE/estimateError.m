% Continuous Psychophysics with Eye Tracking (CPET): estimateError.m
% Author: Ethan Pirso
% Description: Computes the real-time positional error during a trial and checks for conditions to stop the trial early.
% Dependencies: None
% Called by: runCPET.m
%
% Input variables in the workspace:
% - gazeData: Matrix with gaze positions for each frame.
% - stimData: Matrix with stimulus positions and contrast for each frame.
% - stimFreq: Frequency of stimulus position updates.
%
% Output variables in the workspace:
% - stop: A flag indicating if the trial should be stopped early (1 to stop, 0 to continue).
%
% The function handles the following tasks:
% 1. Removal of blink events from the gaze data.
% 2. Extraction of X and Y positions for both the subject's gaze and the stimulus.
% 3. Adjustment for potential lag and truncation of the data arrays to ensure synchronous lengths.
% 4. Calculation and normalization of the position error.
% 5. Computation of the moving median of the error over an 8-second window.
% 6. Evaluation of the stopping criterion: if the moving median of the error exceeds a threshold, the 'stop' flag is set to 1, indicating that the trial should be stopped early.

% Extract the data
x_target = stimData(:,1);
y_target = stimData(:,2);
x_subject = gazeData(:,1);
y_subject = gazeData(:,2);

% Remove blinks
for i=1:length(gazeData)
    if gazeData(i,1) < 0 || gazeData(i,2) < 0
        x_subject(i) = gazeData(i-1,1);
        y_subject(i) = gazeData(i-1,2);
    end
end

% Median filter
x_subject(:) = movmedian(gazeData(:,1),5);
y_subject(:) = movmedian(gazeData(:,2),5);

% Fix lag and truncate ends
[rx,xlags] = xcorr(x_target, x_subject);
[ry,ylags] = xcorr(y_target, y_subject);
lag = min(xlags(rx==max(rx)), ylags(ry==max(ry)));
if lag <= 0 % assume that gaze lags target position always
    x_subject = circshift(x_subject,lag);
    y_subject = circshift(y_subject,lag);
    x_target = x_target(1:end+lag,:);
    y_target = y_target(1:end+lag,:);
    x_subject = x_subject(1:end+lag,:); 
    y_subject = y_subject(1:end+lag,:);
end

xaxis = 0:length(gazeData)-1;
xaxis = xaxis./stimFreq; % x-axis scaled to time (s)

% Throw out first 5 seconds of data (removing initial saccade and instructions)
xaxis = xaxis(xaxis>=5);
x_target = x_target(xaxis>=5);
y_target = y_target(xaxis>=5);
x_subject = x_subject(xaxis>=5);
y_subject = y_subject(xaxis>=5);

% Calculate the position error and normalize it
err = normalize(sqrt((x_subject - x_target).^2 + (y_subject - y_target).^2) ...
    ,'zscore','robust');

% Calculate the moving average of the error
M = movmedian(err, stimFreq*9); % 9 sec moving median

% Check if the moving average exceeds the threshold
if any(M > 3)
    stop = 1; % flag to stop trial
end
