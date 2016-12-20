function []=genparkfis(n,filename)
% genparkfis(n,filename);
%
% Program to generate the 'parkcar.fis' file for fuzzy control of the 
% truck backer-upper problem. Input-output data is loaded from a file
% with filename contained in the string variable 'filename'.
%
% inputs: 
% n is a cell matrix - each cell contains one of the following information
%     the number of evenly spaced triangular membership functions 
%     OR a row vector containing the centres of triangular membership functions
%       n{1}:  For input variable x 
%       n{2}:  For input variable phi
%       n{3}:  For output variable theta 
%     Default is: n{1}=5; n{2}=7; n{3}=7;
%     i.e. use 5,7 and 7 evenly spaced triangular membership functions
%       for x, phi and theta, respectively
%     e.g. to use 7 membership functions for x with uneven spacing, set
%       n{1}=[-20 -10 -5 0 5 10 20];
% filename is a string containing name of the file which stores the array
%     named 'iodata' generated by the park.m simulation program.
%     Default filename is 'iodata.mat'.

% Written Nov 2000 by YS Hung.
% Modified Nov 2003 by TP Ng to allow the number of membership function to be
% changed and to enable unevenly spaced membership function to be generated


if nargin<1, % define default values if n is not provided
   n{1}=5;
   n{2}=7;
   n{3}=7;
end
if nargin<2, % define default filename
   filename='iodata.mat';
end

% If the input is a number, it is taken as the number of evenly spaced
% triangular membership functions
% If the input is a vector, it is taken as the centres of triangular
% membership functions where the peak occurs
if size(n{1})==[1, 1], 
    nA=n{1};
    A=trimfmat(nA,[-20,20]);   % mf matrix for input x
else
    peakA=n{1};
    nA=size(peakA, 2);
    A=trimfmat(peakA);
end
        
if size(n{2})==[1, 1], 
    nB=n{2};
    B=trimfmat(nB,[-180,180]); % mf matrix for input phi
else
    peakB=n{2};
    nB=size(peakB, 2);
    B=trimfmat(peakB);
end
    
if size(n{3})==[1, 1], 
    nC=n{3};
    C=trimfmat(nC,[-40,40]);   % mf matrix for input theta
else
    peakC=n{3};
    nC=size(peakC, 2);
    C=trimfmat(peakC);
end

% creates Mamdani-style FIS structure
a=newfis('parkcar');  % new FIS referred to as 'a'

% add membership functions to fuzzy system
a=addvar(a,'input','x',[-20,20]);     % add 1st input variable x
for i=1:nA,   % membership functions for x named A1, A2, etc
   mfname=['A' int2str(i)];
   a=addmf(a,'input',1,mfname,'trimf',[A(i,:)]);
end

a=addvar(a,'input','phi',[-180,180]);  % add 2nd input phi
for i=1:nB,   % membership functions for phi named B1, B2, etc
   mfname=['B' int2str(i)];
a=addmf(a,'input',2,mfname,'trimf',[B(i,:)]);
end

a=addvar(a,'output','theta',[-40,40]); % add output variable theta
for i=1:nC,  % membership functions for theta named C1, C2, etc
   mfname=['C' int2str(i)];
a=addmf(a,'output',1,mfname,'trimf',[C(i,:)]);
end

% generate the rules and add to the fuzzy system
load(filename);
rulelist=genrules(iodata,A,B,C);
a=addrule(a,rulelist);
writefis(a,'parkcar','dialog');