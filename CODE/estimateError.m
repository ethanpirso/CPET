% GaborTracking: estimateError.m
% Author: Ethan Pirso
% Description: Calculates position error in real-time and evaluates early trial stopping criterion.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - gazeData: Matrix containing gaze positions for each frame.
% - gaborData: Matrix containing Gabor patch positions and contrast for each frame.
% - stimFreq: The frequency of Gabor stimulus position updates.
%
% Output variables in the workspace:
% - stop: Flag to indicate if the trial should be stopped early (1 for stopping, 0 otherwise).

% Remove blinks
for i=1:length(gazeData)
    if gazeData(i,1) < 0 || gazeData(i,2) < 0
        gazeData(i,1) = gazeData(i-1,1);
        gazeData(i,2) = gazeData(i-1,2);
    end
end

% Extract the data
x_target = stimData(:,1);
y_target = stimData(:,2);
x_subject = gazeData(:,1);
y_subject = gazeData(:,2);

% Fix lag and truncate ends
x_subject = circshift(x_subject,-39);
y_subject = circshift(y_subject,-39);
x_target = x_target(1:end-39,:);
y_target = y_target(1:end-39,:);
x_subject = x_subject(1:end-39,:); 
y_subject = y_subject(1:end-39,:);

%% Stop criterion: MAD

% Calculate the position error and normalize it
err = normalize(sqrt((x_subject - x_target).^2 + (y_subject - y_target).^2) ...
    ,'zscore','robust');

% Calculate the moving average of the error
M = movmedian(err, stimFreq*8); % 8 sec moving median

% Check if the moving average exceeds the threshold
if any(M > 3)
    stop = 1; % flag to stop trial
end

%% Stop criterion: Percentage time gaze is within specific radius of target

% % Add a new variable to store the radius (in pixels)
% % radius = mean(distances) + z*(std(distances)/length(distances))
% radius = 263; % 26 px ~ one degree of visual angle
% 
% % Calculate the distance between gaze position and Gabor position
% distances = sqrt((x_subject - x_target).^2 + (y_subject - y_target).^2);
% 
% % Check if the distance is within the specified radius
% within_radius = distances <= radius;
% 
% % Count the number of frames where the gaze is within the specified radius
% num_within_radius = sum(within_radius);
% 
% % Calculate the percentage of time the gaze is within the specified radius
% percentage_within_radius = (num_within_radius / length(gazeData)) * 100;
% 
% disp(percentage_within_radius)
% 
% % Set a threshold for the percentage (e.g., 70%)
% threshold_percentage = 70; % z = 0.524
% 
% % Check if the percentage is below the threshold
% if percentage_within_radius < threshold_percentage
%     stop = 1; % flag to stop trial
% end

