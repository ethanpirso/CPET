% Continuous Psychophysics with Eye Tracking (CPET): params.m
% Author: Ethan Pirso
% Description: Initializes various parameters for the experiment. These parameters include details about the
%              experiment mode (demo or not), subject and trial identifiers, stimulus attributes (size, frequency, 
%              step size, dwell time, contrast step size, etc.), and the screen's attributes. Now it supports 
%              four types of stimuli: Gabor patch, Letter, Aukland Optotype, and Marmoset stimuli.
% Dependencies: prefs.m (optional), calc_freq_cpd.m
% Called by: runCPET.m
%
% Output variables in the workspace:
% - demo: A logical variable indicating if the program is running in demo mode (without EyeLink).
% - subject: The subject identifier code.
% - trial: The trial number.
% - diopters: The diopter of the spherical concave lens used in the experiment.
% - trialName: The concatenated subject and trial identifier.
% - stim: The selected stimulus type (1: Gabor patch, 2: Letter, 3: Optotype, 4: Marmoset Face).
% - stimSize: The size of the stimulus in pixels.
% - viewingDistanceCm: The distance from the observer to the screen in cm.
% - freqCpdDesired: The desired spatial frequency in cycles per degree (CPD).
% - stepSize: The step size of the stimulus movement in pixels.
% - dwellTime: For jitter, the time interval between each update (movement step) of the stimulus in milliseconds.
% - dwellFrames: For curvilinear trajectory, the number of frames between each stimulus update.
% - conStep: The step size for adjusting the contrast of the stimulus, represented as a percent decrease.
% - movement: The type of movement for the stimulus (jitter or curvilinear trajectory).
% - dist: The distribution of the step size (normal or uniform), applicable if the movement is jitter.
% - res: The resolution of the Gabor patch stimulus in pixels.
% - phase: The phase of the Gabor patch stimulus.
% - sc: The standard deviation of the Gaussian envelope used for Gabor patch stimulus.
% - tilt: The tilt of the Gabor patch stimulus.
% - contrast: The initial contrast of the stimulus.
% - aspectratio: The aspect ratio of the Gabor patch stimulus.
% - tw: The width of the Gabor patch stimulus.
% - th: The height of the Gabor patch stimulus.
% - x: The horizontal center of the Gabor patch stimulus.
% - y: The vertical center of the Gabor patch stimulus.
% - screenWidthCm: The width of the screen in cm.
% - screenWidthPx: The width of the screen in pixels.
% - freq: The spatial frequency of the Gabor patch stimulus, calculated using calc_freq_cpd.m.
% - fr: The desired frame rate of the Psychtoolbox window in Hz.
% - stimFreq: The frequency of stimulus position updates.
% - grey: The screen background color in RGB format.
% - letter: The specific letter used as the stimulus, applicable if the selected stimulus is Letter.
% - textColor: The color of the letter, applicable if the selected stimulus is Letter.
% - optoidx: The index of the chosen optotype, applicable if the selected stimulus is Optotype.
% - optotypes: An array of possible optotypes, applicable if the selected stimulus is Optotype.

commandwindow; % bring command window forward for inputs

demo = input('\nrun as demo without EyeLink? 1 or 0 (yes or no): ');
if ~demo
    subject = input('enter subject identifier code (e.g. 001): ','s');
    trial = input('enter trial number: ','s');
    diopters = input('enter diopter of spherical lens: ');
    trialName = append(subject,'_',trial);
end

% Prompt the experimenter to select the desired stimulus
fprintf('Select the desired stimulus:\n');
fprintf('1: Gabor\n');
fprintf('2: Letter\n');
fprintf('3: Optotype\n')
fprintf('4: Marmoset Face\n')
stim = input('Enter the number corresponding to your selection: ');

switch stim
    case 1
        % Initial stimulus params for the gabor patch
        switch input('use preferred gabor params? "y" or "n": ','s')
            case 'y'
                prefs;
            case 'n'
                stimSize = input('stimulus size, pixels (e.g. 75): ');
                viewingDistanceCm = input('viewing distance, cm: ');
                freqCpdDesired = input('spatial frequency, cpd (e.g. 4): ');
                conStep = input('constrast step size, percent decrease (e.g. 1): ');
                fprintf('Select the desired movement type:\n');
                fprintf('1: Jitter\n');
                fprintf('2: Curvilinear Trajectory\n');
                movement = input('Enter the number corresponding to your selection: ');
                switch movement 
                    case 1
                        stepSize = input('stepSize, pixels (e.g. 150): ');
                        dwellTime = input(['dwell time for each target presentation, ' ...
                            'msec (e.g. 50): ']);
                        dist = input('enter "n" for normal or "u" for uniform distributed step size: ','s');
                    case 2
                        % IMPORTANT: choosing a dwellFrames too small triggers an error when 
                        % making call to Eyelink('GetQueuedData') in collectData.m
                        dwellFrames = input('number of frames between each stimulus update: ');
                end
        
            otherwise
                error('unexpected input');
        end
        
        res = 1*[stimSize stimSize];
        phase = 0;
        sc = 10;
        tilt = 0;
        contrast = 60;
        aspectratio = 1.0;
        tw = res(1);
        th = res(2);
        x=tw/2;
        y=th/2;
        screenWidthCm = 41;
        screenWidthPx = 1024;
        freq = calc_freq_cpd(screenWidthCm, screenWidthPx, viewingDistanceCm, freqCpdDesired);
        fr = 120;
        if movement == 1
            stimFreq = 1/(1/fr + dwellTime/1000);
        elseif movement == 2
            stimFreq = 1/(1/fr + dwellFrames/fr);
        end
    case 2
        % Initial stimulus params for letter
        letter = input('stimulus letter (e.g. "E"): ','s');
        textColor = [0 0 0];
        stimSize = 26;
        stepSize = 120;
        dwellTime = 120;
        dwellFrames = 14;
        conStep = 1.5;
        movement = 2;
        contrast = 100;
        fr = 120;
        if movement == 1
            stimFreq = 1/(1/fr + dwellTime/1000);
        elseif movement == 2
            stimFreq = 1/(1/fr + dwellFrames/fr);
        end
    case 3
        % Initial stimulus params for Aukland Optotype
        % Prompt the experimenter to select the desired optotype
        fprintf('Select the desired optotype:\n');
        fprintf('1: butterfly\n');
        fprintf('2: car\n');
        fprintf('3: duck\n');
        fprintf('4: house\n');
        fprintf('5: rocket\n');
        optoidx = input('Enter the number corresponding to your selection: ');
        optotypes = ["butterfly", "car", "duck", "house", "rocket"];
        stimSize = 40;
        stepSize = 120;
        dwellTime = 120;
        dwellFrames = 14;
        conStep = 1.5;
        movement = 2;
        contrast = 100;
        fr = 120;
        if movement == 1
            stimFreq = 1/(1/fr + dwellTime/1000);
        elseif movement == 2
            stimFreq = 1/(1/fr + dwellFrames/fr);
        end
    case 4
        stimSize = 110;
        stepSize = 120;
        dwellTime = 120;
        dwellFrames = 14;
        conStep = 1.5;
        movement = 2;
        contrast = 100;
        fr = 120;
        if movement == 1
            stimFreq = 1/(1/fr + dwellTime/1000);
        elseif movement == 2
            stimFreq = 1/(1/fr + dwellFrames/fr);
        end
end

% Define screen colours
grey = [0.8 0.8 0.8];
