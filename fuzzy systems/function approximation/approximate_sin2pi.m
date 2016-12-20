% This fuzzy system is constructed to approximate function sin(2pix) using
% 9 data points, with method of:
% 1. triangular fuzzifier
% 2. product inference engine
% 3. center of area defuzzifier
%
% Experiments are conducted to observe the accuracy of the system
%
% data points we use to estimate g(x) = sin(2pix) 
% (0, 0), (0.125,0.7071), (0.25,1),
% (0.375,0.7071), (0.5, 0), (0.625, -0.7071),
% (0.75, -1), (0.875,-0.707), (1,0)

clear all;
clear all;
% ***********************************
% ******** Step1: system model ******
% ***********************************
% create fuzzy system model
% a = newfis   ( fisName,  fisType,   and,    or,    imp,    agg,   defuzz)
fuzzySys = newfis('sin2pix','mamdani', 'prod', 'max', 'prod', 'max', 'centroid');
% note: the aggMethod is max, representing the 'union' of individual rules


% ***********************************
% *** Step2: membership functions ***
% ***********************************
% add input membership functions
fuzzySys = addvar(fuzzySys, 'input', 'x', [0 1]);
num = 1;
for ak = 0:0.125:1
    fuzzySys = addmf(fuzzySys, 'input', 1, strcat('A', num2str(num)), 'trimf', [ak-0.125 ak, ak+0.125]);
    num = num + 1;
end

% add output membership functions
fuzzySys = addvar (fuzzySys, 'output', 'y', [-1.5 1.5]);
fuzzySys = addmf(fuzzySys, 'output', 1, 'B1', 'trimf', [-1.2071 -1 -0.7929]);
fuzzySys = addmf(fuzzySys, 'output', 1, 'B2', 'trimf', [-0.9142 -0.7071 -0.5]);
fuzzySys = addmf(fuzzySys, 'output', 1, 'B3', 'trimf', [-0.2071 0 0.2071]);
fuzzySys = addmf(fuzzySys, 'output', 1, 'B4', 'trimf', [0.5 0.7071 0.9142]);
fuzzySys = addmf(fuzzySys, 'output', 1, 'B5', 'trimf', [0.7929 1 1.2071]);

plotmf(fuzzySys,'input',1);
title('input member functions');
plotmf(fuzzySys,'output',1);
title('output member functions');

% ***********************************
% ********* Step3: Rules ************
% ***********************************
w = 1;     % weights: each rule are weighted 1
c = 1;     % rules are composited by AND method

r1 = [1 3 w c];
r2 = [2 4 w c];
r3 = [3 5 w c];
r4 = [4 4 w c];
r5 = [5 3 w c];
r6 = [6 2 w c];
r7 = [7 1 w c];
r8 = [8 2 w c];
r9 = [9 3 w c];

ruleList = [r1;r2;r3;r4;r5;r6;r7;r8;r9];
fuzzySys = addrule(fuzzySys, ruleList);

showrule(fuzzySys);
ruleview(fuzzySys);

writefis(fuzzySys, 'fuzzy_sin2pi'); % save the system

% ***********************************
% **** Step4: test & evaluation *****
% ***********************************
% view the whole system
plotfis(fuzzySys);

% view the plotted surface
surfview(fuzzySys);

% compare output with actual function to obtain the error score plot
% 1. error within original 9 data points
input = 0:0.125:1;
out = evalfis(input, fuzzySys);
expected = sin(2*pi*input);

error = expected' - out;
plot(input, abs(error)), grid on;
title('error between fuzzy system and function sin(2pix)');
xlabel('x');
ylabel('error (abs)');

% 2. error in 101 data points in range [0,1]

% gensurf(fuzzySys);
input = 0:0.01:1;
out = evalfis(input, fuzzySys);
expected = sin(2*pi*input);

% plotting estimated & expected output for comparison
plot(input, out, input, expected);
title('estimated & expected output comparison');
xlabel('x (101 data points)');
ylabel('y estimated/expected')

% plotting difference between estimated & expected output
error = expected' - out;
plot(input, abs(error)), grid on;
title('error between fuzzy system and function sin(2pix)');
xlabel('x (101 data points)');
ylabel('error (abs)');

% find data points with max error value
max_error = max(error); 
max_error_occur = abs(abs(error) - max_error) < 0.0001; % whether the error is the maximum error
indices = find(max_error_occur == 1); % the indices of inputs that result in maximum error
max_error_inputs = input(indices); % the input(x) values that result in maximum error

sin(2*pi*max_error_inputs) % Actual function result
evalfis(max_error_inputs, fuzzySys) % Fuzzy system result

