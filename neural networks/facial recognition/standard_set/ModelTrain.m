function[Ur, W, resulttemp, Record] = ModelTrain(approach,template, row, col, mean, A,V,D, n_eigen,n_node, lr)
% train using 2 method and show test results


%===================================================================================
%  set num of eigen faces and get input
%===================================================================================
n=n_eigen;

Ur = A*V(:,(10-n+1):10);  % To obtain the eigenfaces U
Dr = D((10-n+1):10,(10-n+1):10);
W = inv(Dr)*Ur'*A;         % method 2



if approach ==1
%===================================================================================
%  approach 1:  To use euclidean distance for face recognition
%===================================================================================
%
% To test the recognizer
result = [];
resulttemp=[];
for b=1:2 %test the second set of images
  for a=1:10 %test all 10 persons
    testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
    %calculate weights for the image
   
     Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

    for i=1:10
        euclid(i) = sum((Wtest-W(:,i)).^2)^(1/2); %calculate euclidean distances
    end
    [value index] = min(euclid);  %take the minimum distance
    resulttemp = [resulttemp index]; %the index is the recognized person number, store it
  end
  result = [result; resulttemp]; %form the entire result matrix
  resulttemp=[];
end
resulttemp = result;

Record = []; % useless for this part




else
%===================================================================================
%  approach 2:  To use ANN for face recognition
%===================================================================================

% W gives the weights of the training images
dinput= W;

% Ten output cases (Code)
doutput = [];
for i = 1:10
    doutput(i,i) = 1;
end
    
Record = [];

% Specify the number of hidden nodes
NumNode = n_node;

% -- Start: Create the ANN called net
net = newff(minmax(dinput),[NumNode 10],{'logsig' 'logsig' },'traingda');
net.trainParam.epochs = 2000;    % -- epochs
net.trainParam.show = 1;
net.trainParam.lr = lr;        % -- learning rate
[net,TR]=train(net,dinput,doutput);
disp('Finished training');

% Check the ANN using the dinput if needed
%sim(net,dinput);


 % To test the ANN recognizer
 %---------------------------
    
resulttemp=[];

b=2; %test using the second set of images (i.e. b = 2)
for a=1:10 % ten test images
    testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
    %calculate weights for the image
    Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

    tempd=sim(net,Wtest);      

    resulttemp = [resulttemp tempd ]; % store the ANN output
end

%resulttemp
% The function ANNResult2 is used to get the index of the identified person
[result] = ANNResult2(resulttemp);

% The desired result is [ 1 2 3 4 5 6 7 8 9 10]
% sum(result~=1:10) would give the number of errors
% We store the number of hidden nodes, the error and result in ONE row
Record = [Record;NumNode sum(result~=1:10) result];

%Record


end