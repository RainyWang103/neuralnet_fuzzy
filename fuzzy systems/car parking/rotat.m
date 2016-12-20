function [rxy]=rotat(xy,theta);

% [rxy]=rotat(xy,theta);
% 'rotat' rotates the (x,y) coordinates of N points given in
% 'xy' through an angle 'theta'
% inputs:
% xy = 2xN matrices defining the points to be rotated
% theta = angle of rotation
% output:
% rxy = 2xN matrices containing the rotated points

R=[cos(theta) -sin(theta); sin(theta) cos(theta)];
rxy=R*xy;