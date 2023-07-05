% Continuous Psychophysics with Eye Tracking (CPET): generateRefractiveSeries.m
% Author: Ethan Pirso
% Description: This script generates a refractive series for a given subject and trial range. The script prompts the 
%              user for a subject ID and trial range, then loads the corresponding data from .mat files. The data includes 
%              the contrast thresholds and the diopter values for each trial, as well as the 95% confidence intervals for 
%              the contrast thresholds. The script then plots the contrast thresholds as a function of diopter and fits a 
%              3rd degree polynomial to the data. The minimum of the polynomial fit is marked on the plot and considered as 
%              the 'best' diopter. The script also calculates the R-squared value for the polynomial fit and displays it on 
%              the plot. Finally, the figure and all data are saved to files.
% Dependencies: MATLAB built-in functions (input, isfile, load, figure, plot, title, xlabel, ylabel, polyfit, polyval, 
%               sum, var, hold on, xline, legend, text, errorbar, savefig, save)
%
% Input variables in the workspace:
% - None
%
% Output variables in the workspace:
% - None (All results are saved to files. The saved files include a .fig file for the figure and a .mat file for the data.)
%
% Output files:
% - subjectID_trialStart-trialEnd_refraction.fig: The figure showing the contrast thresholds as a function of diopter with 
%                                                 the polynomial fit and the 'best' diopter marked.
% - subjectID_trialStart-trialEnd_refraction.mat: The data including the subject ID, trial range, contrast thresholds, 
%                                                 diopters, and confidence intervals for the contrast thresholds.

% Prompt for subject ID and trial range
subjectID = input('Please enter a subject identifier code (e.g. 001): ', 's');
trialStart = input('Please enter the start trial number: ');
trialEnd = input('Please enter the end trial number: ');

% Initialize arrays to store contrast thresholds, diopters and confidence intervals
conThresholds = [];
diopters = [];
conCIs = [];

% Load data for each trial
for trial = trialStart:trialEnd
    % Construct the file name
    fileName = sprintf('../DATA/MAT/%s_%d.mat', subjectID, trial);
    
    % Check if file exists
    if isfile(fileName)
        % Load the data
        data = load(fileName);
        
        % Extract and store the variables
        conThresholds = [conThresholds; data.conThreshold];
        diopters = [diopters; data.diopters];
        conCIs = [conCIs; data.conCI];
    else
        fprintf('File %s does not exist. Skipping this trial.\n', fileName);
    end
end

% Compute error values as the difference between the confidence interval bounds and the contrast thresholds
lowerErrors = conThresholds - conCIs(:, 1);
upperErrors = conCIs(:, 2) - conThresholds;

% Plot the contrast thresholds as a function of diopter with error bars
figure; 
errorbar(diopters, conThresholds, lowerErrors, upperErrors, '.--');
title(sprintf('Contrast Thresholds for Subject %s, Trials %d to %d', subjectID, trialStart, trialEnd));
xlabel('Diopter');
ylabel('Contrast Threshold (%)');

% Fit a 3rd degree polynomial to the data
p = polyfit(diopters, conThresholds, 3);
x2 = linspace(min(diopters), max(diopters), 100);
y2 = polyval(p, x2);

% Compute the R-squared value
yfit = polyval(p, diopters); % fitted values
yresid = conThresholds - yfit; % residuals
SSresid = sum(yresid.^2); % sum of squares of residuals
SStotal = (length(conThresholds)-1) * var(conThresholds); % total sum of squares
rsq = 1 - SSresid/SStotal; % R-squared value

% Add the fit to the plot
hold on;
plot(x2, y2, 'b');

% Find the minimum of the fit
[minY, minIdx] = min(y2);
minX = x2(minIdx);

% Add a vertical line at the minimum
xline(minX, '-', {'',strcat(string(round(minX,2)),'D')}, 'FontSize', 11, 'LabelOrientation', ...
    'horizontal', 'LabelVerticalAlignment', 'top', 'LabelHorizontalAlignment', 'right');
legend('Data', 'Polynomial fit', 'Best Lens Power', 'Location', 'best');

% Display R-squared value on the plot
% text(max(x2)-2, max(y2), sprintf('R^2 = %.2f', rsq), 'FontSize', 12);

% Save the figure
figName = sprintf('%s_%d-%d_refraction.fig', subjectID, trialStart, trialEnd);
savefig(figName);
movefile(figName,'../DATA/FIG');

% Save the data
dataFileName = sprintf('%s_%d-%d_refraction.mat', subjectID, trialStart, trialEnd);
save(dataFileName, 'subjectID', 'trialStart', 'trialEnd', 'conThresholds', ...
    'diopters', 'conCIs', 'rsq', 'minX');
movefile(dataFileName,'../DATA/MAT');
