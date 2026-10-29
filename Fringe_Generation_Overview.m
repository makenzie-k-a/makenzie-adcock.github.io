%Makenzie Adcock
%SOLAR LAB, Deflectometry

clear;
close all;
clc;

%Fringe Generation
%define screen size
imageWidth = 1920;
imageHeight = 1200;
L = max(imageWidth, imageHeight);

%create grid that matches screen size
x = 0:(imageWidth - 1);
y = 0:(imageHeight - 1);

%use X for horizontal, Y for vertical
[X, Y] = meshgrid(x, y);

%generate image
phaseShifts = [0, pi/2, pi, 3*pi/2];
patterns = cell(1, 8);

for k = 1:4

    phaseShift = phaseShifts(k);

    % First four patterns: intensity varies with X
    patterns{k} = 0.5 * (1 + cos(2*pi*X/L + phaseShift));

    % Next four patterns: intensity varies with Y
    patterns{k+4} = 0.5 * (1 + cos(2*pi*Y/L + phaseShift));

end

%display image
figure;

for k = 1:8
    subplot(2, 4, k);

    imagesc(patterns{k}, [0 1]);
    colormap(gray(256));
    axis image off;

    %label
    if k <= 4
        orientation = 'Horizontal';
        phaseIndex = k;
    else
        orientation = 'Vertical';
        phaseIndex = k - 4;
    end

    title(sprintf('%s, Phase = %g\\pi', orientation, phaseShifts(phaseIndex)/pi));

end