% GaborTracking: params.m
% Author: Ethan Pirso
% Description: Initializes various parameters for the experiment, such as stimulus size, viewing distance,
% spatial frequency, step size, dwell time, and contrast step size.
% Dependencies: prefs.m (optional), calc_freq_cpd.m
% Called by: run.m
%
% Output variables in the workspace:
% - subject: The subject identifier code.
% - trial: The trial number.
% - diopters: The diopter of the spherical concave lens.
% - trialName: The concatenated subject and trial identifier.
% - size: The size of the Gabor patch stimulus in pixels.
% - viewingDistanceCm: The distance from the observer to the screen in cm.
% - freqCpdDesired: The spatial frequency of the Gabor patch in cycles per degree (CPD).
% - stepSize: The step size of the Gabor patch movement in pixels.
% - dwellTime: The time interval between each movement step of the Gabor patch in milliseconds.
% - conStep: The step size for adjusting the contrast of the Gabor patch in percent decrease.
% - movement: The movement of the Gabor stimulus ("saccadic" or "smooth").
% - dist: The distribution of the step size ("normal" or "uniform").
% - res: The resolution of the Gabor patch stimulus in pixels.
% - phase: The phase of the Gabor patch.
% - sc: The standard deviation of the Gaussian envelope.
% - tilt: The tilt of the Gabor patch.
% - contrast: The initial contrast of the Gabor patch.
% - aspectratio: The aspect ratio of the Gabor patch.
% - tw: The width of the Gabor patch.
% - th: The height of the Gabor patch.
% - x: The horizontal center of the Gabor patch.
% - y: The vertical center of the Gabor patch.
% - screenWidthCm: The width of the screen in cm.
% - screenWidthPx: The width of the screen in pixels.
% - freq: The spatial frequency of the Gabor calculated using calc_freq_cpd.m.
% - fr: The desired PTB window frame rate in Hz. 
% - stimFreq: The frequency of Gabor stimulus position updates.
% - grey: The screen background color in RGB format.

commandwindow; % bring command window forward for inputs

demo = input('\nrun as demo without EyeLink? 1 or 0 (yes or no): ');
if ~demo
    subject = input('enter subject identifier code: ','s');
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
                stepSize = input('stepSize, pixels (e.g. 150): ');
                dwellTime = input(['dwell time for each target presentation, ' ...
                    'msec (e.g. 50): ']);
                conStep = input('constrast step size, percent decrease (e.g. 1): ');
                movement = input('"saccadic" or "smooth" stimulus movement: ','s');
                if movement == "saccadic"
                    dist = input('"normal" or "uniform" distributed step size: ','s');
                end
        
            otherwise
                error('unexpected input');
        end
        
        res = 1*[stimSize stimSize];
        phase = 0;
        sc = 10;
        tilt = 0;
        contrast = 20;
        aspectratio = 1.0;
        tw = res(1);
        th = res(2);
        x=tw/2;
        y=th/2;
        screenWidthCm = 41;
        screenWidthPx = 1024;
        freq = calc_freq_cpd(screenWidthCm, screenWidthPx, viewingDistanceCm, freqCpdDesired);
        fr = 120;
        stimFreq = 1/(1/fr + dwellTime/1000);

    case 2
        % Initial stimulus params for letter
        letter = input('stimulus letter (e.g. "E"): ','s');
        textColor = [0 0 0];
        stimSize = 20;
        stepSize = 120;
        dwellTime = 120;
        conStep = 1.5;
        movement = "smooth";
%         stepSize = input('stepSize, pixels (e.g. 150): ');
%         dwellTime = input(['dwell time for each target presentation, ' ...
%             'msec (e.g. 50): ']);
%         conStep = input('constrast step size, percent decrease (e.g. 1): ');
%         movement = input('"saccadic" or "smooth" stimulus movement: ','s');
%         if movement == "saccadic"
%             dist = input('"normal" or "uniform" distributed step size: ','s');
%         end
        contrast = 100;
        fr = 120;
        stimFreq = 1/(1/fr + dwellTime/1000);
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
        conStep = 1.5;
        movement = "smooth";
        contrast = 100;
        fr = 120;
        stimFreq = 1/(1/fr + dwellTime/1000);
    case 4
        stimSize = 120;
        stepSize = 120;
        dwellTime = 120;
        conStep = 1.5;
        movement = "smooth";
        contrast = 100;
        fr = 120;
        stimFreq = 1/(1/fr + dwellTime/1000);
end

% Define screen colours
grey = [0.8 0.8 0.8];
