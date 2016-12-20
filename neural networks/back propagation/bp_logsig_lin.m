% bp-logsig-lin.m
% Version 3.1  Nov 6, 2002  Copyright by Dr. G. Pang
%
% LOGSIG function is used in hidden layer; LINEAR function is used in the output layer
%
function [convergence,ave_err,max_err,result,v,w,Thres_b,Thres_c]= bp_logsig_lin(inputs,outputs,Num_hid,Alpha,Beta,err,max_stop)
%
% Backpropagation Algorithm
%
% Input arguments:
% inputs - a matrix of dimension (samples x n)
% outputs - a matrix of dimension (samples x q)
% Num_hid - number of hidden units (i.e. p)
% Alpha - learning rate between the output and hidden layer
% Beta - learning rate between the input and hidden layer
% err - error for the stopping criterion
% max_stop - maximum number of iterations
% 
% Output arguments:
% convergence - a vector of dimension 1 x max_stop containing the ave_error at each iteration
% ave_err - average error at the output
% max_err - maximum error at the output
% result - a matrix of dimension (samples x 3) 
%          The three columns give inputs, desired outputs and NN outputs
%
% First the dimension of the input and output matrices are checked
%

disp('Demo on Backpropagation Algorithm by Dr. G. Pang')

[Num_examples,Num_in]=size(inputs);
[tmp,Num_out]=size(outputs);
if (Num_examples ~= tmp), 
    disp('Number of input-output training examples not the same'),end

% Initize the convergence vector
convergence = zeros(1,max_stop);
%
% Initial weights are randomly selectly from [-0.5,0.5]; 
% The "rand" command gives a value between 0 and 1.
%
v=rand(Num_in,Num_hid)-(0.5)*ones(Num_in,Num_hid);
w=rand(Num_hid,Num_out)-0.5*ones(Num_hid,Num_out);
Thres_b =rand(1,Num_hid)-0.5*ones(1,Num_hid);
Thres_c =rand(1,Num_out)-0.5*ones(1,Num_out);
%
% This is the main loop of the program
%
iterations = 0;
max_err = 1000;

%
% Continue the WHILE loop ONLY if BOTH criteria are true.  That is,
% (a) the max_err is larger than the desired max. error amount, AND
% (b) the number of interations is still less than the maximum number of iterations
%
while (max_err >= err & iterations < max_stop)
  iterations = iterations + 1;
 
for N=1:Num_examples, 

%
% a and ck is the N-th pair of training example 
%
 a  = inputs(N,:);
 ck = outputs(N,:);
%
% Get all the b's (outputs from the hidden layer) LOGSIG function
%
    for i=1:Num_hid,
       b(1,i)=sigmoid( a*v(:,i)+Thres_b(i)); 
    end
%
% Get all the c's (outputs from the output layer)  LINEAR function
%
   for j=1:Num_out,
      c(1,j) = b*w(:,j)+Thres_c(j); 
   end 
% 
% Compute the error at the outputs (d)
%
 for j=1:Num_out,
    d(1,j) = ck(j)-c(j);
 end 
%
% Computer the e's (the errors at the hidden layer relative to each d
%
 for i = 1:Num_hid,
    e(1,i) = b(i)*(1-b(i))*(w(i,:)*d');
 end 
%
% Adjust the weights between the hidden and output layers
%
   for i = 1:Num_hid,
     for j = 1:Num_out,
      w(i,j) = w(i,j) + Alpha*b(i)*d(j);
     end
   end
%
% Adjust the thresholds at the output layer
%
  for j = 1:Num_out,
    Thres_c(j) = Thres_c(j) + Alpha*d(j); 
  end
%
% Adjust the weights between the hidden and input layers
%
 for i = 1:Num_in,
  for j = 1:Num_hid,
   v(i,j) = v(i,j) + Beta*a(i)*e(j);
  end
 end
%
% Adjust the thresholds at the hidden layer
    for j = 1:Num_hid,
      Thres_b(j) = Thres_b(j) + Beta*e(j); 
    end

end % End of FOR loop for one iteration
    % The weights have already been adjusted N times.


% Do the recall
% The number of training samples is Num_examples.  Each case is presented.
%
for N=1:Num_examples, 
   a = inputs(N,:);
   ck = outputs(N,:);
% Get all the b's (outputs from the hidden layer)
%
    for i=1:Num_hid,
       b(1,i)=sigmoid( a*v(:,i)+Thres_b(i)); 
    end
%
% Get all the c's (outputs from the output layer)
%
   for j=1:Num_out,
      c(1,j) =  b*w(:,j)+Thres_c(j); 
      save_err(N,j) = abs(ck(j)-c(j)); % Save the amount of error on the Nth row.
   end 
%
end % end FOR loop, finishing all the N samples
%
% 
% Calculate the average error and maximum error
%

       ave_err = sum(sum(save_err))/(N*Num_out);
       max_err = max(max(save_err));
       disp(' ite/1000 ; ave_err ; max_err '),[iterations/1000 ave_err max_err]
       convergence(1,iterations) = ave_err;
%
end % of the while loop 

% If you can reach here, you have exited the WHILE loop, which
% means one of the stopping criteria has been reached.
disp('Stopping criterion has been reached !')
disp('The results after training : inputs, desired outputs, NN outputs')

 % Do the recall
   for N=1:Num_examples,
         a  = inputs(N,:);
         ck = outputs(N,:);
  
 % Get all the b's
         for i=1:Num_hid,
            b(1,i)=sigmoid( a*v(:,i)+Thres_b(i)) ;
         end

 % Get all the c's
         for j=1:Num_out,
            c(1,j) =  b*w(:,j)+Thres_c(j);
         end

      result(N,:) = c;

end  % end of recall loop

 
