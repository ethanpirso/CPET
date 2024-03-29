% Continuous Psychophysics with Eye Tracking (CPET): initStim.m
% Author: Ethan Pirso
% Description: Initializes the position and properties of the stimulus with constant velocity across random trajectories.
%              This script is generalized to handle different types of stimuli like Gabor patches, Letters, Aukland Optotypes, and Marmoset stimuli.
% Dependencies: None
% Called by: runCPET.m
%
% Input variables in the workspace:
% - screenWidth: Width of the screen in pixels.
% - screenHeight: Height of the screen in pixels.
% - win: The window pointer for the Psychtoolbox window.
% - grey: The color used for the background of the window.
% - stim: The type of stimulus being used (1: Gabor patch, 2: Letter, 3: Aukland Optotype, 4: Marmoset stimuli).
% - stimSize: The size of the stimulus.
% - tw: Width of the Gabor patch in pixels.
% - th: Height of the Gabor patch in pixels.
% - optotypes: Array containing the names of optotype images.
% - optoidx: Index for the optotype array.
% - movement: The type of movement for the stimulus (2 for curvilinear trajectory).
% - dps: Desired velocity in degrees of visual angle per second for curvilinear trajectory.
% - screenWidthCm: Width of the screen in centimeters.
% - screenWidthPx: Width of the screen in pixels.
% - viewingDistanceCm: Viewing distance in centimeters.
%
% Output variables in the workspace:
% - gabortex: Procedural Gabor texture (if Gabor patch is the selected stimulus).
% - optotex: Optotype texture (if Aukland Optotype is the selected stimulus).
% - marmosettex: Marmoset texture (if Marmoset stimuli are the selected stimulus).
% - stimData: Empty matrix to store stimulus data.
% - X: X coordinate of the stimulus center on the screen.
% - Y: Y coordinate of the stimulus center on the screen.
% - xPosSmooth, yPosSmooth: Smooth curvilinear trajectory for smooth pursuit movement.
% - constVelocity: Constant velocity for curvilinear trajectory (pixels per second).
% - stimulusDuration: Duration for displaying the stimulus (calculated based on the constant velocity and total path length for curvilinear trajectory movement).
% - numFrames: The number of frames based on stimulus duration and velocity (only for curvilinear trajectory movement).
% - frameDuration: Duration for a frame (only for curvilinear trajectory movement).
%
% Note: This version of the script generates a smooth curvilinear trajectory for the stimulus where the velocity is constant, and the time to traverse the trajectory is variable based on the total path length and the set constant velocity.

% Initialize the position of the stimulus
X = (screenWidth / 2) - (stimSize / 2);
Y = (screenHeight / 2) - (stimSize / 2);

% Initialize the stim data matrix
stimData = [];

switch stim
    case 1
        % Build a procedural gabor texture for a gabor with a support of tw x th
        % pixels, and a RGB color offset grey (see params).
        gabortex = CreateProceduralGabor(win, tw, th, 0, [grey 0]);   
    case 3
        % Make the optotype image into a texture   
        optotype = imread(strcat('../STIMULI/OPTOTYPES/', optotypes(optoidx), '_reg.tif'));
        optotype = imresize(optotype, [stimSize stimSize]);
        optotype = double(optotype) ./ 255;
        optotype(optotype>grey(1)) = optotype(optotype>grey(1)) - (1 - grey(1));
        optotex = Screen('MakeTexture', win, optotype);
    case 4
        % Make the marmoset image into a texture   
        marmoset = imread("../STIMULI/MARMOSETS/marmoset_bw.tif");
        marmoset = imresize(marmoset, [stimSize stimSize]);
        marmoset = double(marmoset) ./ 255;
%         marmoset = imgaussfilt(marmoset);
        marmosettex = Screen('MakeTexture', win, marmoset);
end

% Initialize stimulus positions for curvilinear trajectory
if movement == 2 
    % Initialize random trajectory
    numPoints = 80; % num of points to interpolate
    canvasSize = 2/3; % proportion of the screen to display image within
    xPos = (rand(1, numPoints-1) * round(screenWidth*canvasSize)) + (screenWidth * (1-canvasSize)/2) - (stimSize / 2);
    yPos = (rand(1, numPoints-1) * round(screenHeight*canvasSize)) + (screenHeight * (1-canvasSize)/2) - (stimSize / 2);
    xPos = [X xPos];
    yPos = [Y yPos];
    
    % Set constant velocity according to desired visual degrees per second
    dps = 6; % degrees per second
    ppd = calc_ppd(screenWidthCm, screenWidthPx, viewingDistanceCm); % pixels per degree
    constVelocity = dps * ppd; % pixels per second
    
    % Calculate total path length
    pathLengths = sqrt(diff(xPos).^2 + diff(yPos).^2);
    totalPathLength = sum(pathLengths);
    
    % Calculate time to reach each point with constant velocity
    timePoints = [0 cumsum(pathLengths/constVelocity)];
    
    % Get smooth curvilinear trajectory
    ppx = spline(timePoints, xPos);
    ppy = spline(timePoints, yPos);
    
    % Calculate stimulus duration based on the path length and constant velocity
    stimulusDuration = totalPathLength / constVelocity; % seconds
    
    % Calculate the number of frames based on stimulus duration and velocity
    numFrames = round(stimulusDuration * Screen('FrameRate', win));
    frameDuration = 1 / Screen('FrameRate', win);
    
    % Calculate new time values for the trajectory points based on the desired velocity
    tVals = linspace(0, stimulusDuration, numFrames);
    xPosSmooth = ppval(ppx, tVals);
    yPosSmooth = ppval(ppy, tVals);

end
