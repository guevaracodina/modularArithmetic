%% Times Tables Demo
% Modular arithmetic or modulo multiplication circle. 
% Display of the times table as secants in a circle.
% Performs the following operation: multiplier mod numberOfPoints.
% Renders a cardioid (a.k.a. the Heart of Mathematics) or Simon Plouffe patterns
% Related to the reflection of light rays in a cup of coffee. 
% Some patterns show up in the Mandelbrot set.
% ______________________________________________________________________________
% Copyright (C) 2019 Edgar Guevara, PhD 
% ______________________________________________________________________________
multiplier = 1:0.1:5;                   % Try 2, 34, 51, 99
numberOfPoints = 200;                   % Must be an integer (e.g. 200)
for iMult = multiplier
    timesTables(iMult, numberOfPoints, [1 0 0], 0.5, 'indexHue',[0.3 0.3 0.3]);
end

% EOF