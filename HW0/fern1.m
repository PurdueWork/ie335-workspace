% Barnsley Fern Fractal Generator in MATLAB

% --- 1. Initialization ---
% clear all; close all; clc; % Clear workspace, close figures, clear command window

n = 50000; % Number of points to generate (increase for more detail)

% Initialize a matrix to store the (x,y) coordinates of the points.
% We have 2 rows (x and y) and n columns (one for each point).
Fern = zeros(2, n);

% Set the starting point at the origin.
P = [0; 0]; 

% --- 2. Define the Four Affine Transformations (IFS) ---
% Each transformation is of the form: New_Point = A * Old_Point + b

% Transformation 1 (Stem)
A1 = [0    0; 
      0    0.17];
b1 = [0; 0];

% Transformation 2 (Successively smaller leaflets)
A2 = [0.85 -0.05; 
       0.05  0.85];
b2 = [0; 1.6];

% Transformation 3 (Largest left-hand leaflet)
A3 = [0.2  -0.2; 
      0.2 0.2];
b3 = [0; 1.6];

% Transformation 4 (Largest right-hand leaflet)


A4 = [-.2 .2; .2 .2];
b4 = [0; 0.44];


% --- 3. The Main Loop (Chaos Game) ---
% Iterate n times to generate the points of the fern.
for k = 1:n
    % Generate a random number between 0 and 1.
    r = rand;

    % Choose which transformation to apply based on the random number
    % and the predefined probabilities.
    if r < 0.01 % Probability 1%
        P = A1 * P + b1;
    elseif r < 0.86 % Probability 85% (0.01 + 0.85)
        P = A2 * P + b2;
    elseif r < 0.94 % Probability 7% (0.86 + 0.07)
        P = A3 * P + b3;
    else % Probability 7%
        P = A4 * P + b4;
    end
    
    % Store the resulting point in our matrix.
    Fern(:, k) = P;
end


% --- 4. Plot the Result ---
% The first row of Fern contains all x-coordinates, the second all y-coordinates.
% We use a small point marker '.' for a classic fractal look.
figure;
plot(Fern(1,:), Fern(2,:), '.', ...
    'MarkerSize', 1, ...
    'Color', [0 0.6 0]); % A nice dark green color

% Improve the aesthetics
axis 'equal';     % Ensure the aspect ratio is correct
axis off;          % Hide the x and y axes
% set(gcf, 'color', 'k'); % Set the figure background color to black
title('The Fern', 'FontSize', 14);
saveas(gcf, 'fern.png');