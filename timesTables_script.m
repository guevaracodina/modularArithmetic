%% Times Tables Demo
% Modular arithmetic or modulo multiplication circle.
% Display of the times table as secants in a circle.
% Performs the following operation: multiplier mod numberOfPoints.
% Renders a cardioid (a.k.a. the Heart of Mathematics) or Simon Plouffe patterns
% Related to the reflection of light rays in a cup of coffee.
% Some patterns show up in the Mandelbrot set.
% Animated video available on: https://youtu.be/YRQZAqlxbCw
% ______________________________________________________________________________
% Copyright (C) 2019 Edgar Guevara, PhD
% ______________________________________________________________________________
multiplier = [1:0.1:51, 51*ones([1 30])];        % Try 2, 34, 51, 99
% multiplier = 1:51;        % Try 2, 34, 51, 99
numberOfPoints = 200;                   % Must be an integer (e.g. 200)
createVideo = false;
if createVideo
    v = VideoWriter('.\output\modularArithmetic.avi','Uncompressed AVI');
    v.FrameRate = 30;
%     v.Quality = 100;
    open(v);
end
for iMult = multiplier
    timesTables(iMult, numberOfPoints, [1 0 0], 0.5, 'indexHue',[0.3 0.3 0.3]);
    if createVideo
        h = gcf;
        % Specify window units
        set(h, 'units', 'pixels')
        % Change figure and paper size
        set(h, 'Position', [1 1 1920 1080])
        set(h, 'PaperPosition', [1 1 1920 1080])
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end
close(v);

% EOF