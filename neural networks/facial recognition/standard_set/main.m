% Eigenface method
%
clear all
close all

%cd 'C:\YOUR DATABASE PATH'

%===================================================================================
% Part A: Input of the image database
%===================================================================================
imSize = [150 100];
template(:,:,1,1)=double(rgb2gray(imresize(imread('01-1B.jpg'),imSize)))/255;
template(:,:,1,2)=double(rgb2gray(imresize(imread('01-2B.jpg'),imSize)))/255;
template(:,:,2,1)=double(rgb2gray(imresize(imread('02-1B.jpg'),imSize)))/255;
template(:,:,2,2)=double(rgb2gray(imresize(imread('02-2B.jpg'),imSize)))/255;
template(:,:,3,1)=double(rgb2gray(imresize(imread('03-1B.jpg'),imSize)))/255;
template(:,:,3,2)=double(rgb2gray(imresize(imread('03-2B.jpg'),imSize)))/255;
template(:,:,4,1)=double(rgb2gray(imresize(imread('04-1B.jpg'),imSize)))/255;
template(:,:,4,2)=double(rgb2gray(imresize(imread('04-2B.jpg'),imSize)))/255;
template(:,:,5,1)=double(rgb2gray(imresize(imread('05-1B.jpg'),imSize)))/255;
template(:,:,5,2)=double(rgb2gray(imresize(imread('05-2B.jpg'),imSize)))/255;
template(:,:,6,1)=double(rgb2gray(imresize(imread('06-1B.jpg'),imSize)))/255;
template(:,:,6,2)=double(rgb2gray(imresize(imread('06-2B.jpg'),imSize)))/255;
template(:,:,7,1)=double(rgb2gray(imresize(imread('07-1B.jpg'),imSize)))/255;
template(:,:,7,2)=double(rgb2gray(imresize(imread('07-2B.jpg'),imSize)))/255;
template(:,:,8,1)=double(rgb2gray(imresize(imread('08-1B.jpg'),imSize)))/255;
template(:,:,8,2)=double(rgb2gray(imresize(imread('08-2B.jpg'),imSize)))/255;
template(:,:,9,1)=double(rgb2gray(imresize(imread('09-1B.jpg'),imSize)))/255;
template(:,:,9,2)=double(rgb2gray(imresize(imread('09-2B.jpg'),imSize)))/255;
template(:,:,10,1)=double(rgb2gray(imresize(imread('10-1B.jpg'),imSize)))/255;
template(:,:,10,2)=double(rgb2gray(imresize(imread('10-2B.jpg'),imSize)))/255;

% build image vector
img=[];
for i=1:10
   [row col] = size(template(:,:,i,1));  % Use the first set of images for training
   img=[img reshape((template(:,:,i,1)), row*col,1)]; %reshape the matrix to a column vector
end

%calculate mean method 1
mean=zeros(row*col,1);
for i=1:10
    mean = img(:,i)+mean;
end
mean = mean./10;

% calculate mean method 2
% mean2=mean(img,2);
 
% To calculate difference vector
A=[];
for i=1:10
    A(:,i)=img(:,i)-mean;
end
 
% To obtain the eigenvectors and eigenfaces
% eig: (A'*A)*eigenvec = eigenvec * eigenval
[V, D] = eig(A'*A); 
D(1,1)=1; % The first eigenvalue is zero and is set to 1 for numerical reason

% Note that all the eigenvectors are already normalized to unit vectors
             
%===================================================================================
%  Part B:  To use euclidean distance for face recognition
%===================================================================================

n_eigen = 10;
n_node = 20;
lr = 0.1;
[Ur, W, resulttemp, Record] = ModelTrain(1,template, row, col, mean, A,V,D, n_eigen,n_node, lr);
resulttemp
%==========================================
% To check the k-th reconstructed sample faces
kface=5; % check the Fifth FACE
faces = zeros(150*100,1);
Wtest = W(:,kface);  % To get the k-th FACE
for i=1:n_eigen
    faces = Wtest(i).*Ur(:,i) + faces;  %add up the weighted eigenfaces
end
faces = faces + mean;  % ADD back the mean

% Alternatively,  faces = Ur*Wtest + mean

figure,imshow(reshape(faces,imSize),[0 1]);

% To compare with the k-th original sample
figure,imshow(template(:,:,kface,1))  %  for comparison with the original

%===================================================================================
% Part C : To use ANN for face recognition
%===================================================================================
n_eigen = 6;
n_node = 50;
lr = 0.01;
[Ur, W, resulttemp, Record] = ModelTrain(2,template, row, col, mean, A,V,D, n_eigen,n_node, lr);
Record




















