%{
Connor Bramhall
email: bramhalc@my.erau.edu
date: 11/16/2020
EGR 115 - Section 15DB
Assignment: Final Project V0.4.0
Program Description: My final project will be a program that allows any
number of people to play chess with a custom GUI. Due to the reshuffling of 
my code, the scoring markers are below, with a reference to where they are 
in the code.
<SM:IF>
<SM:SWITCH>
<SM:ROP>
<SM:BOP>
<SM:FOR>
<SM:WHILE>
<SM:NEST>
<SM:PDF_CALL>
<SM:PDF_PARAM>
<SM:PDF_RETURN>
<SM:STRING>
<SM:REF>
<SM:SLICE>
<SM:RTOTAL>
<SM:RANDGEN>
<SM:RANDUSE>
<SM:PLOT>
<SM:READ>
<SM:WRITE>
<SM:NEWFUN>
Worked With: Online references are commented at the start of function
files, or below here if they were used in the main script.
https://www.mathworks.com/matlabcentral/answers/515880-how-can-i-change-the-colours-of-segmentation-on-a-chart-pie
https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/15877/versions/3/previews/html/heatmapdemo.html
https://www.mathworks.com/matlabcentral/answers/96023-how-do-i-add-a-background-image-to-my-gui-or-figure-window
%}
clear;
clc;
close all;

scrsz = get(groot,'ScreenSize');
titlescreen = figure('Position', [scrsz]);
set(titlescreen, 'MenuBar', 'none');
set(titlescreen, 'NumberTitle', 'off');
set(titlescreen, 'Name', 'Infinichess');
titleaxis = axes('units', 'normalized', 'position', [0 0 1 1]);
uistack(titleaxis, 'bottom');
backgroundPic = imread('pexels-sebastian-voortman-411207-2.jpg');
bg = imagesc(backgroundPic);
set(titleaxis,'handlevisibility','off','visible','off');
startbut = uicontrol('Style', 'PushButton', 'Units', 'Normalized');
loadbut = uicontrol('Style', 'PushButton', 'Units', 'Normalized');
optbut = uicontrol('Style', 'PushButton', 'Units', 'Normalized');
set(startbut, 'Position', [0.22, 0.2, 0.16, 0.10], 'String', 'New Game');
set(startbut, 'Callback', {@cb_NewGameButton, titlescreen});
set(loadbut, 'Position', [0.42, 0.2, 0.16, 0.10], 'String', 'Load Game');
set(loadbut, 'Callback', {@cb_LoadGameButton, titlescreen});
set(optbut, 'Position', [0.62, 0.2, 0.16, 0.10], 'String', 'Options');
