function [car] = plotb(state, steer_angle, car_size); % stored in file plotb.m
% [car]=plotb(state,steer_angle,car_size)
% plotb is a function to find out the outline of a car together 
% with the steered front wheels and back wheels
% inputs:
% state=[x,y,o] indicates the position (x,y) of the car and its 
%               orientation o relative to the x-axis
% steer_angle   is the angle of the front wheels relative to the
%               car's centre line
% car_size=[cw,cl] defines the width and length of the car
hold on;
carxy = [state(1,1) state(1,2)]';
cw = car_size(1); 
cl = car_size(2);
x = state(1,1);
y = state(1,2);
caror = state(1,3) + pi/2;   % +pi/2 because different definition of orientation between the MATLAB system and the source
frontleftwheelcen = [-cw/2; 3*(cl/4)];
frontrightwheelcen = [cw/2; 3*(cl/4)];
backleftwheelcen = [-cw/2; cl/4];
backrightwheelcen = [cw/2; cl/4];

initcar = [-cw/2 cw/2 cw/2 -cw/2 -cw/2; cl cl 0 0 cl]; 
initcar1 = [-cw/3 cw/3 cw/3 -cw/3 -cw/3; 5*(cl/8) 5*(cl/8) cl/8 cl/8 5*(cl/8)]; 

shape = [-cw/2 cw/2 cw/2 -cw/2 -cw/2; cl/2 cl/2 -cl/2 -cl/2 cl/2]; 

%vectors of outline of a rectangle
wheel = [ shape(1,:)/8 ; shape(2,:)/4 ]; %vectors of outline of a wheel
rotwheel = rotat(wheel,steer_angle);
leftwheel = rotwheel + frontleftwheelcen*ones(1,5);
rightwheel = rotwheel + frontrightwheelcen*ones(1,5);
backleftwheel = wheel + backleftwheelcen*ones(1,5);
backrightwheel = wheel + backrightwheelcen*ones(1,5);
dum = rotat([initcar leftwheel rightwheel backleftwheel backrightwheel initcar1],caror);

car = dum + carxy*ones(1,30);