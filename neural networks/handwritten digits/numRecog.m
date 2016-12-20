clear all, close all

% desired output: 10 nodes
B01=[1 0 0 0 0 0 0 0 0 0]; % digit 0
B11=[0 1 0 0 0 0 0 0 0 0]; % digit 1
B21=[0 0 1 0 0 0 0 0 0 0]; % digit 2
B31=[0 0 0 1 0 0 0 0 0 0]; % digit 3
B41=[0 0 0 0 1 0 0 0 0 0]; % digit 4
B51=[0 0 0 0 0 1 0 0 0 0]; % digit 5
B61=[0 0 0 0 0 0 1 0 0 0]; % digit 6
B71=[0 0 0 0 0 0 0 1 0 0]; % digit 7
B81=[0 0 0 0 0 0 0 0 1 0]; % digit 8
B91=[0 0 0 0 0 0 0 0 0 1]; % digit 9

T_ten=[B01;B11;B21;B31;B41;B51;B61;B71;B81;B91];

% desired output: 4 nodes
A01=[0 0 0 0]; % digit 0
A11=[0 0 0 1]; % digit 1
A21=[0 0 1 0]; % digit 2
A31=[0 0 1 1]; % digit 3
A41=[0 1 0 0]; % digit 4
A51=[0 1 0 1]; % digit 5
A61=[0 1 1 0]; % digit 6
A71=[0 1 1 1]; % digit 7
A81=[1 0 0 0]; % digit 8
A91=[1 0 0 1]; % digit 9
T_four=[A01;A11;A21;A31;A41;A51;A61;A71;A81;A91]; 



% Step 1
% Method A
% model: input-7, output-10
% training data: numV, 
% testing data: numVnoise, numS, numSnoise

% read data and preprocessing
[nV1, nVnoise1, nS1, nSnoise1] = read_data_files(1);  % method = 1 for Method A

% training
disp('Start training');
input1 = nV1';
output1 = T_ten;
net1=newff(minmax(input1),[20 10],{'logsig' 'purelin' },'traingda');
net1.trainParam.epochs = 100;
net1.trainParam.show = 1;
net1.trainParam.lr = 0.1;

[net1,TR]=train(net1,input1,output1);
disp('Finished training');

% testing
testInput1_1 = nVnoise1';
testInput1_2 = nS1';
testInput1_3 = nSnoise1';

disp('use testing input numVnoise, get:');
anstest=sim(net1,testInput1_1)';
anstest > 0.5
disp('use testing input numS, get:');
anstest=sim(net1,testInput1_2)';
anstest > 0.5
disp('use testing input numSnoise, get:');
anstest=sim(net1,testInput1_3)';
anstest > 0.5

% Step 2
% Method A
% model: input-7, output-10
% training data: numV, numS 
% testing data: numVnoise, numSnoise

% read data and preprocessing
[nV2, nVnoise2, nS2, nSnoise2] = read_data_files(1);  % method = 1 for Method A

% training
disp('Start training');
input2 = [nV2;nS2]';
output2 = [T_ten;T_ten]';
net2=newff(minmax(input2),[30 10],{'logsig' 'purelin' },'traingda');
net2.trainParam.epochs = 1000;
net2.trainParam.show = 1;
net2.trainParam.lr = 0.1;

[net2,TR]=train(net2,input2,output2);
disp('Finished training');

% testing
testInput2_1 = nVnoise2';
testInput2_2 = nSnoise2';

disp('use testing input numVnoise, get:');
anstest=sim(net2,testInput2_1)';
anstest > 0.5
disp('use testing input numSnoise, get:');
anstest=sim(net2,testInput2_2)';
anstest > 0.5

% Step 3
% Method A
% model: input-7, output-4
% training data: numV, numS 
% testing data: numVnoise, numSnoise
[nV3, nVnoise3, nS3, nSnoise3] = read_data_files(1);  % method = 1 for Method A

% training
disp('Start training');
input3 = [nV3;nS3]';
output3 = [T_four;T_four]';
net3=newff(minmax(input3),[20 4],{'logsig' 'purelin' },'traingda');
net3.trainParam.epochs = 200;
net3.trainParam.show = 1;
net3.trainParam.lr = 0.1;

[net3,TR]=train(net3,input3,output3);
disp('Finished training');

% testing
testInput3_1 = nVnoise3';
testInput3_2 = nSnoise3';

disp('use testing input numVnoise, get:');
anstest=sim(net3,testInput3_1)';
anstest > 0.5
disp('use testing input numSnoise, get:');
anstest=sim(net3,testInput3_2)';
anstest > 0.5

% Step 4
% Method B
% model: input-36, output-10
% training data: numV 
% testing data: numS, numVnoise, numSnoise

% read data and preprocessing
[nV4, nVnoise4, nS4, nSnoise4] = read_data_files(2);  % method = 2 for Method B

% training
disp('Start training');
input4 = nV4';
output4 = T_ten;
net4=newff(minmax(input4),[10 10],{'logsig' 'purelin' },'traingda');
net4.trainParam.epochs = 2000;
net4.trainParam.show = 1;
net4.trainParam.lr = 0.1;

[net4,TR]=train(net4,input4,output4);
disp('Finished training');

% testing
testInput4_1 = nVnoise4';
testInput4_2 = nS4';
testInput4_3 = nSnoise4';

disp('use testing input numVnoise, get:');
anstest=sim(net4,testInput4_1)';
anstest > 0.5
disp('use testing input numS, get:');
anstest=sim(net4,testInput4_2)';
anstest > 0.5
disp('use testing input numSnoise, get:');
anstest=sim(net4,testInput4_3)';
anstest > 0.5

% Step 5
% Method C
% model: input-200, output-10
% training data: numV 
% testing data: numS, numVnoise, numSnoise

% read data and preprocessing
[nV5, nVnoise5, nS5, nSnoise5] = read_data_files(3);  % method = 3 for Method C

% training
disp('Start training');
input5 = nV5';
output5 = T_ten;
net5=newff(minmax(input5),[15 10],{'logsig' 'purelin' },'traingda');
net5.trainParam.epochs = 1000;
net5.trainParam.show = 1;
net5.trainParam.lr = 0.1;

[net5,TR]=train(net5,input5,output5);
disp('Finished training');

% testing
testInput5_1 = nVnoise5';
testInput5_2 = nS5';
testInput5_3 = nSnoise5';

disp('use testing input numVnoise, get:');
anstest=sim(net5,testInput5_1)';
anstest > 0.5
disp('use testing input numS, get:');
anstest=sim(net5,testInput5_2)';
anstest > 0.5
disp('use testing input numSnoise, get:');
anstest=sim(net5,testInput5_3)';
anstest > 0.5


