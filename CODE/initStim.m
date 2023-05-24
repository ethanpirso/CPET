% GaborTracking: initGabor.m
% Author: Ethan Pirso
% Description: Initializes the position and properties of the Gabor patch stimulus.
% Dependencies: None
% Called by: run.m
%
% Input variables in the workspace:
% - screenWidth: Width of the screen in pixels.
% - screenHeight: Height of the screen in pixels.
% - x: Horizontal position of the Gabor patch center.
% - y: Vertical position of the Gabor patch center.
% - win: The window pointer for the PTB window.
% - grey: The color used for the background of the window.
% - tw: Width of the Gabor patch in pixels.
% - th: Height of the Gabor patch in pixels.
%
% Output variables in the workspace:
% - gaborX: X coordinate of the Gabor patch center on the screen.
% - gaborY: Y coordinate of the Gabor patch center on the screen.
% - gaborData: Empty matrix to store Gabor patch data.
% - gabortex: Procedural Gabor texture.

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
%         marmoset(optotype>0.8) = grey(1);
        marmosettex = Screen('MakeTexture', win, marmoset);
end

% Initialize stimulus positions for smooth pursuit
if movement == "smooth"
    % Set stimulus display time
    stimulusDuration = 120; % seconds
    
    % Initialize random trajectory
    numPoints = 70; % controls speed
    xPos = rand(1, numPoints-1) *  round(screenWidth/1.5) + screenWidth/6;
    yPos = rand(1, numPoints-1) *  round(screenHeight/1.5) + screenHeight/6;
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
