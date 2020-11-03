function [] = openSisotool(G)
% mycustomcontrolsysdesignerfcn(G)
%
% Creates the following Control System Designer session:
%   1) Configuration 4 with the plant specified by G
%   2) Root locus and bode editors for the outer-loop
%   3) Bode editor for the inner-loop.

%   Copyright 1986-2005 The MathWorks, Inc.

% Create initialization object with configuration 4
    s = sisoinit(1);

    % Set the value of the plant
    s.G.Value = G;

    % Specify the editors for the Open-Loop Responses
    s.OL1.View = {'rlocus','bode'};

    controlSystemDesigner(s)

end
