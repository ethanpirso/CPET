% Continuous Psychophysics with Eye Tracking (CPET): initStim.m
% Author: Ethan Pirso
% Description: Initializes the position and properties of the stimulus.
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
% - movement: The type of movement for the stimulus ("smooth" for smooth pursuit).
%
% Output variables in the workspace:
% - gabortex: Procedural Gabor texture (if Gabor patch is the selected stimulus).
% - optotex: Optotype texture (if Aukland Optotype is the selected stimulus).
% - marmosettex: Marmoset texture (if Marmoset stimuli are the selected stimulus).
% - stimData: Empty matrix to store stimulus data.
% - X: X coordinate of the stimulus center on the screen.
% - Y: Y coordinate of the stimulus center on the screen.
% - xPosSmooth, yPosSmooth: Smooth curvilinear trajectory for smooth pursuit movement.
% - stimulusDuration: Duration for displaying the stimulus (only for smooth pursuit movement).
% - numFrames: The number of frames based on stimulus duration and velocity (only for smooth pursuit movement).
% - frameDuration: Duration for a frame (only for smooth pursuit movement).

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
        optotype(optotype>0.8) = grey(1);
        optotex = Screen('MakeTexture', win, optotype);
    case 4
        % Make the marmoset image into a texture   
        marmoset = imread("../STIMULI/MARMOSETS/marmoset_bw.tif");
        marmoset = imresize(marmoset, [stimSize stimSize]);
        marmoset = double(marmoset) ./ 255;
%         marmoset = imgaussfilt(marmoset);
        marmosettex = Screen('MakeTexture', win, marmoset);
end

% Initialize stimulus positions for smooth pursuit
if movement == "smooth"
    % Set stimulus display time
    stimulusDuration = 120; % seconds
    
    % Initialize random trajectory
    numPoints = 70; % controls speed
    pointsPerSec = numPoints / stimulusDuration; % speed of stimulus
    canvasSize = 2/3; % proportion of the screen to display image within
    xPos = (rand(1, numPoints-1) * round(screenWidth*canvasSize)) + (screenWidth * (1-canvasSize)/2) - (stimSize / 2);
    yPos = (rand(1, numPoints-1) * round(screenHeight*canvasSize)) + (screenHeight * (1-canvasSize)/2) - (stimSize / 2);
    xPos = [X xPos];
    yPos = [Y yPos]; 
    
    % Get smooth curvilinear trajectory
    t = linspace(0, stimulusDuration, numPoints);
    ppx = spline(t, xPos);
    ppy = spline(t, yPos);
    
    % Calculate the number of frames based on stimulus duration and velocity
    numFrames = round(stimulusDuration * Screen('FrameRate', win));
    frameDuration = 1 / Screen('FrameRate', win);
    
    % Calculate new time values for the trajectory points based on the desired velocity
    tVals = linspace(0, stimulusDuration, numFrames);
    xPosSmooth = ppval(ppx, tVals);
    yPosSmooth = ppval(ppy, tVals);
end
