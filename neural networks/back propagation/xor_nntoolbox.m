
% NN toolbox for the XOR problem
%

% Case 1: Using trainlm

xorinput=[ 0 0 1 1;0 1 1 0];
xoroutput=[0 1 0 1];
disp('Start training')
net=newff(minmax(xorinput),[5 1],{'logsig' 'purelin' },'trainlm')
%
net.trainParam.epochs = 100;
net.trainParam.show = 1;

net=train(net,xorinput,xoroutput)
disp('Finished training')

sim(net,xorinput)
disp('The weights are net.IW{1}, net.LW{2}')
---------------------------------------------------------------------------------

% Case 2: Using traingd (Gradient Descent )

xorinput=[ 0 0 1 1;0 1 1 0];
xoroutput=[0 1 0 1];
disp('Start training')
net=newff(minmax(xorinput),[5 1],{'logsig' 'purelin' },'traingd')
%
net.trainParam.epochs = 100;
net.trainParam.show = 1;
net.trainParam.lr = 0.1; % vary this parameter from 0.01 to 0.1, 0.3, 1

net=train(net,xorinput,xoroutput)
disp('Finished training')
sim(net,xorinput)
-----------------------------------------------------------------------------------

% Case 3: Using traingda (Gradient Descent with Adaptive learning rate)

xorinput=[ 0 0 1 1;0 1 1 0];
xoroutput=[0 1 0 1];
disp('Start training')
net=newff(minmax(xorinput),[5 1],{'logsig' 'purelin' },'traingda')
%
net.trainParam.epochs = 100;
net.trainParam.show = 1;
net.trainParam.lr = 0.1;

[net,TR]=train(net,xorinput,xoroutput)
disp('Finished training')

sim(net,xorinput)
figure
plot(1:100,TR.lr(1:100))

