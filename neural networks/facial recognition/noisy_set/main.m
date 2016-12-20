% Eigenface method
% Wang Yuli
%
clear all
close all

%===================================================================================
% Part A: Image database input
%===================================================================================

cd Database

% ============ 8 Training, 2 Testing ======================
ImgPath = '';%'/Users/rainywang/Documents/OneDrive/Study/YEAR_5/ELEC4543_Fuzzy&NN/_Assignments/Assignment3_Stage2\Database';
NumS = 10;  % Number of Samples/People
NumP = 10;  % Number of Photos of each sample
NumTr = 8;  % Number of Trained Data
NumTe = 2;  % Number of Test Data
NumITr = NumS*NumTr;

template=[];
imSize = [112 92];
for i=1:NumS 
    for j=1:NumP
        template(:,:,i,j) = double(imresize(imread(strcat(ImgPath,'s',num2str(i),'/',num2str(j),'.jpg')),imSize))/255;% use the set from 1 to 10
        % i-th person's j-th photo
    end
end


%===================================================================================
% Part B: Eigenface methods
%===================================================================================

% build image vector
img=[];
for j=1:NumTr % j-th photo
    for i=1:NumS % i-th person
       [row col] = size(template(:,:,i,j));  % Use the first set of images for training
       img=[img reshape((template(:,:,i,j)), row*col,1)]; %reshape the matrix to a column vector
    end
end

%calculate mean method 1
mean=zeros(row*col,1);
for i=1:(NumITr)
    mean = img(:,i)+mean;
end
mean = mean./NumITr;

% calculate mean method 2
% mean2=mean(img,2);
 
% To calculate difference vector
A=[];
for i=1:NumITr
    A(:,i)=img(:,i)-mean;
end
 
% To obtain the eigenvectors and eigenfaces
% eig: (A'*A)*eigenvec = eigenvec * eigenval
[V, D] = eig(A'*A); 
D(1,1)=1; % The first eigenvalue is zero and is set to 1 for numerical reason

% Note that all the eigenvectors are already normalized to unit vectors

%===================================================================================
% Part C: To determine the number of eigenfaces
%===================================================================================

eigval=diag(D);
eigsum = sum(eigval); 
csum = 0; 
for i = NumITr:-1:1 
csum = csum + eigval(i); 
tv = csum/eigsum; 
if tv > 0.95
k95 = i
break 
end ;
end;

sprintf(' The number of eigenvalues is %d',NumITr)
sprintf('Keep the index from %d to %d',k95,NumITr)
sprintf('The last %d are kept',(NumITr-k95+1))

%===================================================================================
%  Part D:  To use only the last n eigenvectors for Euclidean Distance measure
%===================================================================================

% -------------------------- Default settings --------------------------

nums_of_faces = 50:1:80;
accuracies = [];

for n = 50:1:80   % number of eigen faces
    
    Ur = A*V(:,(NumITr-n+1):NumITr);  % To obtain the eigenfaces U
    Dr = D((NumITr-n+1):NumITr,(NumITr-n+1):NumITr);
    W = inv(Dr)*Ur'*A;         % method 2

    %------------------------------- testing ---------------------------
    % To test the recognizer
    result = [];
    resulttemp=[];

    for b = 9:10  % test sets of ten images, test 20 images at the same time
        for a=1:NumS %test all samples/persons
            testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
            %calculate weights for the image
            Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

            for i=1:NumITr
                euclid(i) = sum((Wtest-W(:,i)).^2)^(1/2); %calculate euclidean distances
            end
            [value index] = min(euclid);  %take the minimum distance
            if (rem(index,NumS) == 0) % If remainder is 0, means the recognized person number is NumS
                resulttemp = [resulttemp NumS];
            else
                resulttemp = [resulttemp rem(index,NumS)]; %the index is the recognized person number, store it
            end
        end
        result = [result; resulttemp]; %form the entire result matrix
        resulttemp=[];
    end

    ResultError = 0;
    for i = 1:2 
        for j = 1:NumS
            if (result(i,j)~= j)
                ResultError = ResultError+1;
            end
        end
    end
    accuracyTemp = (20-ResultError)/20;
    accuracies = [accuracies accuracyTemp];
end

% -------------------------- plotting --------------------------

plot(nums_of_faces, accuracies, 'go:', 'LineWidth',2, 'MarkerFaceColor','g','MarkerSize',8)
title('Accuracy Scores For Euclidean Distance Model');
xlabel('number of eigen faces');
ylabel('accuracy scores');


%===================================================================================
% Part E : To use ANN for face recognition
%===================================================================================
 
% ----------------------------------------------------------
% Experiment 1: Tuning # of hidden nodes of 5, 10, 20....500
% ----------------------------------------------------------

% -------------------------- Constants ---------------------------
n = 70; % number of eigen faces

Ur = A*V(:,(NumITr-n+1):NumITr);  % To obtain the eigenfaces U
Dr = D((NumITr-n+1):NumITr,(NumITr-n+1):NumITr);
W = inv(Dr)*Ur'*A;

% initialize input & output
dinput = W;
doutput = [];
for i = 1:NumTr
    for j = 1:NumS
        doutput((i-1)*10+j,j)=1;
    end
end

% -------------------------- Default settings ---------------------
nums_of_nodes = 5:5:500;
accuracies = [];

for numNode = 5:5:500 % number of hidden nodes
    
    % -------------------------- training -------------------------
    % disp('Start training');
    net = newff(minmax(dinput),[numNode 10],{'logsig' 'logsig' },'traingda');
    net.trainParam.epochs = 500;    % -- epochs
    net.trainParam.lr = 0.1;        % -- learning rate
    net.trainParam.show = 1;
    [net,TR]=train(net,dinput,doutput');
    % disp('Finished training');

    % -------------------------- testing --------------------------
    % disp('Start testing')
    result = [];
    resulttemp = [];
    for b = 9:10  % test sets of ten images, test 20 images at the same time
        for a=1:NumS %test all samples/persons
            testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
            %calculate weights for the image
            Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

            tempd=sim(net,Wtest);       
            resulttemp = [resulttemp tempd ]; % store the ANN output
        end
        [result] = [result;ANNResult2(resulttemp)];
        resulttemp = [];
    end

    ResultError = 0;
        for i = 1:2 
            for j = 1:NumS
                if (result(i,j)~= j)
                    ResultError = ResultError+1;
                end
            end
        end
    accuracyTemp = (20-ResultError)/20;
    accuracies = [accuracies accuracyTemp];
end

% -------------------------- plotting --------------------------
plot(nums_of_nodes, accuracies, 'ro:', 'LineWidth',2, 'MarkerFaceColor','r','MarkerSize',5)
title('Accuracy Scores For ANN (tuning hidden nodes)');
xlabel('number of hidden nodes');
ylabel('accuracy scores');




% ----------------------------------------------------------
% Experiment 2: Tuning # of eigenfaces of 50, 51, 52 ... 80
% ----------------------------------------------------------

% -------------------------- Constants ---------------------------
numNode = 165;

% -------------------------- Default settings --------------------------
nums_of_faces = 50:1:80;
accuracies = [];

for n = 50:1:80   % number of eigen faces
    
    Ur = A*V(:,(NumITr-n+1):NumITr);  % To obtain the eigenfaces U
    Dr = D((NumITr-n+1):NumITr,(NumITr-n+1):NumITr);
    W = inv(Dr)*Ur'*A;         % method 2
    
    % initialize input & output
    dinput = W;
    doutput = [];
    for i = 1:NumTr
        for j = 1:NumS
            doutput((i-1)*10+j,j)=1;
        end
    end
    
    % -------------------------- training -------------------------
    % disp('Start training');
    net = newff(minmax(dinput),[numNode 10],{'logsig' 'logsig' },'traingda');
    net.trainParam.epochs = 500;    % -- epochs
    net.trainParam.lr = 0.1;        % -- learning rate
    net.trainParam.show = 1;
    [net,TR]=train(net,dinput,doutput');
    % disp('Finished training');

    % -------------------------- testing --------------------------
    % disp('Start testing')
    result = [];
    resulttemp = [];
    for b = 9:10  % test sets of ten images, test 20 images at the same time
        for a=1:NumS %test all samples/persons
            testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
            %calculate weights for the image
            Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

            tempd=sim(net,Wtest);       
            resulttemp = [resulttemp tempd ]; % store the ANN output
        end
        [result] = [result;ANNResult2(resulttemp)];
        resulttemp = [];
    end

    ResultError = 0;
        for i = 1:2 
            for j = 1:NumS
                if (result(i,j)~= j)
                    ResultError = ResultError+1;
                end
            end
        end
    accuracyTemp = (20-ResultError)/20;
    accuracies = [accuracies accuracyTemp];
end

% -------------------------- plotting --------------------------
plot(nums_of_faces, accuracies, 'ro:', 'LineWidth',2, 'MarkerFaceColor','r','MarkerSize',5)
title('Accuracy Scores For ANN (tuning eigenfaces)');
xlabel('number of eigen faces');
ylabel('accuracy scores');

% ----------------------------------------------------------
% Experiment 3: Tuning # of eigenfaces & hidden nodes
% ----------------------------------------------------------

% -------------------------- Default settings --------------------------
nums_of_faces = 10:5:80;
nums_of_nodes = 10:10:300;
accuracies = [];

for n = 10:5:80   % number of eigen faces (x-axis)
    accuracyRow = [];
    for numNode = 10:10:300 % number of hidden nodes (y-axis)
        
        Ur = A*V(:,(NumITr-n+1):NumITr);  % To obtain the eigenfaces U
        Dr = D((NumITr-n+1):NumITr,(NumITr-n+1):NumITr);
        W = inv(Dr)*Ur'*A;         % method 2

        % initialize input & output
        dinput = W;
        doutput = [];
        for i = 1:NumTr
            for j = 1:NumS
                doutput((i-1)*10+j,j)=1;
            end
        end

        % -------------------------- training -------------------------
        % disp('Start training');
        net = newff(minmax(dinput),[numNode 10],{'logsig' 'logsig' },'traingda');
        net.trainParam.epochs = 500;    % -- epochs
        net.trainParam.lr = 0.1;        % -- learning rate
        net.trainParam.show = 1;
        [net,TR]=train(net,dinput,doutput');
        % disp('Finished training');

        % -------------------------- testing --------------------------
        % disp('Start testing')
        result = [];
        resulttemp = [];
        for b = 9:10  % test sets of ten images, test 20 images at the same time
            for a=1:NumS %test all samples/persons
                testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
                %calculate weights for the image
                Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

                tempd=sim(net,Wtest);       
                resulttemp = [resulttemp tempd ]; % store the ANN output
            end
            [result] = [result;ANNResult2(resulttemp)];
            resulttemp = [];
        end

        ResultError = 0;
            for i = 1:2 
                for j = 1:NumS
                    if (result(i,j)~= j)
                        ResultError = ResultError+1;
                    end
                end
            end
        accuracyTemp = (20-ResultError)/20;
        accuracyRow = [accuracyRow accuracyTemp];
    end
     accuracies = [accuracies; accuracyRow];
end

% -------------------------- plotting --------------------------
surf(nums_of_nodes, nums_of_faces, accuracies);
title('Accuracy Scores For ANN (tuning hidden nodes & eigenfaces)');
xlabel('number of hidden nodes');
ylabel('number of eigen faces');
zlabel('accuracy scores')
shading interp;


% ----------------------------------------------------------
% Experiment 4: Tuning training rates
% ----------------------------------------------------------

% -------------------------- Default settings --------------------------
numNode = 150; % number of hidden nodes
n = 60;        % number of eigen faces
LRS = [1,0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001, 0.00000001, 0.000000001];
accuracies = [];
converges = [];

Ur = A*V(:,(NumITr-n+1):NumITr);  % To obtain the eigenfaces U
Dr = D((NumITr-n+1):NumITr,(NumITr-n+1):NumITr);
W = inv(Dr)*Ur'*A;         % method 2
% initialize input & output
dinput = W;
doutput = [];
for i = 1:NumTr
    for j = 1:NumS
        doutput((i-1)*10+j,j)=1;
    end
end
    
for lr = LRS     
    % -------------------------- training -------------------------
    % disp('Start training');
    net = newff(minmax(dinput),[numNode 10],{'logsig' 'logsig' },'traingda');
    net.trainParam.epochs = 5000;    % -- epochs
    net.trainParam.lr = lr;        % -- learning rate
    net.trainParam.show = 1;
    [net,TR]=train(net,dinput,doutput');
    % disp('Finished training');

    % -------------------------- testing --------------------------
    % disp('Start testing')
    result = [];
    resulttemp = [];
    for b = 9:10  % test sets of ten images, test 20 images at the same time
        for a=1:NumS %test all samples/persons
            testimage=reshape(template(:,:,a,b),row*col,1); %create column vectors
            %calculate weights for the image
            Wtest = inv(Dr)*Ur'*(testimage-mean); % method 2

            tempd=sim(net,Wtest);       
            resulttemp = [resulttemp tempd ]; % store the ANN output
        end
        [result] = [result;ANNResult2(resulttemp)];
        resulttemp = [];
    end

    ResultError = 0;
        for i = 1:2 
            for j = 1:NumS
                if (result(i,j)~= j)
                    ResultError = ResultError+1;
                end
            end
        end
    accuracyTemp = (20-ResultError)/20;
    
    accuracies = [accuracies accuracyTemp];
    converges = [converges TR.num_epochs];
end

% -------------------------- plotting --------------------------
semilogx(LRS, accuracies, 'bo:', 'LineWidth',2, 'MarkerFaceColor','b','MarkerSize',5)
title('Accuracy Scores For ANN (tuning training rates)');
xlabel('training rate');
ylabel('accuracy scores');

semilogx(LRS, converges, 'bo:', 'LineWidth',2, 'MarkerFaceColor','b','MarkerSize',5)
title('Epochs of Converging For ANN (tuning training rates)');
xlabel('training rate');
ylabel('epochs used to converge');

       

