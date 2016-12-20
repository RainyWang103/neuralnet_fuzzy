% sigmoid.m  (same as builtin function logsig in MATLAB)
%
function y = sigmoid(x)
    y = 1/(1 +exp(-x));
