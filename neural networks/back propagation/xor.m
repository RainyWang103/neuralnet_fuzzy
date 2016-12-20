
% Testing of BP algorithm for learning the XOR function
%

P = [ 0  0
      0  1
      1  1
      1  0 ];
T = [ 0
      1
      0
      1];

% Case 1:
     max_iterations = 1000;
     [Con,Ave,Max,R,V,W,B,C]=bp_logsig_lin(P,T,5,0.3,0.3,0.001,max_iterations);
     %
     disp('Finished bp-logsig-lin.m training') 
     % To view the convergence curve
     figure
     plot(1:max_iterations,Con)
     % To look at the final trained result
     R

% Case 2:
     % The above example illustrate the BP training using just 100 iterations
     % The result is not good enough yet. Change to the use of 1000 iterations
     % and examine the result again.
     % Comment and compare with previous results.

% Case 3:
     % Then, still using a maximum of 1000 iterations, change the learning rates to 0.7.
     % Comment and compare with previous results.

% Case 4:     
     % Then, still using a maximum of 1000 iterations, and the learning rates being 0.7, change
     % the "error for stopping" to 0.0001.
     % Comment and compare with previous results.

% Case 5:      
     % Then, still using a maximum of 1000 iterations, with the learning rates being 0.7, 
     % the "error for stopping" being 0.0001, change the number of hidden nodes to 10.
     % Comment and compare with previous results.
     % How many parameters does your BP ANN contain ?  How many does it contain before ?

% Case 6: The file MATLAB-NNtoolbox-XOR.txt contains a few versions of code if we use 
%     the MATLAB NN toolbox.  Different BP algorithms are used.
%     Run all the three cases in the file and compare with the weights obtained in Case 2 above.









