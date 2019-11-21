function hFig = timesTables(multiplier, numberOfPoints, varargin)
% Modular arithmetic or modulo multiplication circle. 
% Display of the times table as secants in a circle.
% Performs the following operation: multiplier mod numberOfPoints.
% Renders a cardioid (a.k.a. the Heart of Mathematics) or Simon Plouffe patterns
% Related to the reflection of light rays in a cup of coffee. 
% Some patterns show up in the Mandelbrot set.
% SYNTAX
% hFig = timesTables(multiplier, numberOfPoints, lineColor, alphaValue, ...
%                   colorMethod, pointColor, darkBackground)
% INPUTS
% multiplier        A positive real number. For multiplier=10, points go from 
%                   0 to 9, 10 to 19, 20 to 29, etc...
% numberOfPoints    Modulus value, i.e. number of points on a circle
% [OPTIONAL INPUTS]
% lineColor         3-element vector [0-1] describing the desired color, if
%                   it is a 3-column matrix, then this colormap will be
%                   used
% alphaValue        [0-1] with 0 being total transparency and 1 fully
%                   opaque
% colorMethod       a character array with any of the following values:
%                   solid
%                   faded
%                   lengthOpacity
%                   lengthHue
%                   indexHue
%                   fadedIndexHue
% pointColor        3-element vector [0-1] describing the desired color of
%                   the points circunscribed to the circle. Use NaN if you
%                   do not want to draw any points
% darkBackground    boolean, if true black background is chosen
% OUTPUT
% hFig              Handle to figure
% 
% Inspired by:
% https://lengler.dev/TimesTableWebGL/
% https://www.youtube.com/watch?v=knAzjnM3koo
% https://www.youtube.com/watch?v=qhbuKbxJsk8
% ______________________________________________________________________________
% Copyright (C) 2019 Edgar Guevara, PhD
% ______________________________________________________________________________
%% Handle optional inputs 
% only want 1 optional input at most
numVarArgs = length(varargin);
if numVarArgs > 5
    error('timesTables:TooManyInputs', ...
        'requires at most 5 optional inputs: lineColor, alphaValue, colorMethod, pointColor, darkBackground');
end

% set defaults for optional inputs ()
optArgs = {[1 1 1], 0.25, 'solid', NaN, true};

% now put these defaults into the optArgs cell array,
% and overwrite the ones specified in varargin.
optArgs(1:numVarArgs) = varargin;

% Place optional args in memorable variable names
lineColor       = optArgs{1};
alphaValue      = optArgs{2};
colorMethod     = optArgs{3};
pointColor      = optArgs{4};
darkBackground  = optArgs{5};

% Sanity check
if multiplier < 0
    multiplier = -multiplier;
end
numberOfPoints = fix(numberOfPoints);
if alphaValue > 1
    alphaValue = 1;
elseif alphaValue < 0
    alphaValue = 0;
end

%% Create or re-use figure 
g = groot;
% True if there are no open graphics objects, false otherwise
if isempty(g.Children) 
    % Create figure
    hFig = figure;
else
    hFig = figure(gcf);
end
if darkBackground
    set(hFig, 'color', 'k')         % Black background
    set(hFig, 'InvertHardcopy', 'off')
else
    set(hFig, 'color', 'w')         % White background
end
hold on

%% Compute modular arithmetic 
% Define center and radius
X = 0; Y = 0;
radius = 1;
% Clear the axes
cla
% Fix the axis limits
xlim([-1.1 1.1]*radius)
ylim([-1.1 1.1]*radius)
% Plot the circle
a = linspace(0, 2*pi, 360*numberOfPoints);	% Assign Angle Vector
xVec = X + radius.*cos(a);                  % Circle ‘x’ Vector
yVec = Y + radius.*sin(a);  
% plot(xVec, yVec, 'color', [0 0 0])        % Plot Circle
% Set the axis aspect ratio to 1:1
axis square
axis off
% Indices of points locations
pointIndices = 1:360:360*numberOfPoints;
% Compute times table
pointsVecBegin = round(1:numberOfPoints);
pointsVecEnd = floor(mod(pointsVecBegin*multiplier, numberOfPoints)) + 1;
% Line opacity
alphaValue = repmat(alphaValue, [numberOfPoints 1]);
% Check if numberOfPoints > length(lineColor)
if isvector(lineColor)
    lineColor = repmat(lineColor, [numberOfPoints 1]);
else
    % Interpolate colormap to the required number of points
    lineColor_interp = zeros(numberOfPoints, 3);
    for iChannels = 1:3
        lineColor_interp(:,iChannels) = interp1(1:size(lineColor,1), ...
            lineColor(:, iChannels), linspace(1, size(lineColor,1),numberOfPoints));
    end
    lineColor = lineColor_interp;
end

%% Create colormap and transparency 
% Color method
switch(colorMethod)
    case 'solid'
        % solid color, constant transparency
        lineColor = lineColor .* alphaValue;
    case 'faded'
        % faded color
        lineColor = lineColor .* repmat(linspace(0,1,numberOfPoints)', [1 3]);
    case 'lengthOpacity'
        % Opacity varies according to line length
        lineLength = zeros([numberOfPoints 1]);
        for iLines = 1:numberOfPoints
            lineLength(iLines) = norm([xVec(pointIndices(pointsVecBegin(iLines))), ...
                yVec(pointIndices(pointsVecBegin(iLines)));
                xVec(pointIndices(pointsVecEnd(iLines))), ...
                yVec(pointIndices(pointsVecEnd(iLines)))]);
        end
        alphaFactor = lineLength / (max(lineLength));
        alphaFactor = mat2gray(alphaFactor);
        alphaValue = alphaValue .* alphaFactor;
    case 'lengthHue'
        % Hue varies according to line length
        lineLength = zeros([numberOfPoints 1]);
        for iLines = 1:numberOfPoints
            lineLength(iLines) = norm([xVec(pointIndices(pointsVecBegin(iLines))), ...
                yVec(pointIndices(pointsVecBegin(iLines)));
                xVec(pointIndices(pointsVecEnd(iLines))), ...
                yVec(pointIndices(pointsVecEnd(iLines)))]);
        end
        hueFactor = lineLength / (max(lineLength));
        hueFactor = mat2gray(hueFactor);
        lineColor = lineColor .* hueFactor;
    case 'indexHue'
        % Hue is granted according to index
        lineColor = hsv(numberOfPoints);
    case 'fadedIndexHue'
        % Hue is faded according to index
        lineColor = hsv(numberOfPoints).*repmat(linspace(0,1,numberOfPoints )', [1 3]);
    case default
        % Use HSV colormap as default
        lineColor = hsv(numberOfPoints);
end
        
%% Plot lines 
for iLines = 1:numberOfPoints
    % Plot Lines
    hPlot = plot([xVec(pointIndices(pointsVecBegin(iLines))), ...
        xVec(pointIndices(pointsVecEnd(iLines)))], ...
        [yVec(pointIndices(pointsVecBegin(iLines))), ...
        yVec(pointIndices(pointsVecEnd(iLines)))], '-', 'Color', lineColor(iLines,:));
    hPlot.Color(4) = alphaValue(iLines);% Modify line opacity
end

%% Plot points 
if ~isnan(pointColor)
%     hPoint = plot(xVec(pointIndices), yVec(pointIndices), '.', 'Color', pointColor);
    plot(xVec(pointIndices), yVec(pointIndices), '.', 'Color', pointColor);
end
% hPoint.Color(4) = alphaValue;         % Does not change transparency...

%% Add title 
if darkBackground
    title(sprintf('%gx, N=%d', multiplier, numberOfPoints), ...
        'Color', [1 1 1])               % White letters
else
    title(sprintf('%gx, N=%d', multiplier, numberOfPoints), ...
        'Color', [0 0 0])               % Black letters
end
drawnow()                               % Refresh
end

% EOF