function mfmat=trimfmat(n,range);
% mfmat=trimfmat(n,range);
% To generate the parameters of n triangular membership functions which are
% complete, consistent and evenly spaced over a given interval
%
% Inputs:
% n = number of evenly spaced triangular membership functions to be generated
%   OR a row vector containing the centres at the peaks of membership functions
% range = [alpha, beta] is a 1x2 vector defining the interval for the mf's 
%
% Output:
% mfmat = nx3 matrix; each row contains the 3 paramters of a triangular
%         membership function, the membership functions are ordered with
%         increasing high set down the rows of the matrix.


% Written by YS Hung (11/2000).
% Modified by TP Ng 7/11/2003 to allow non-evenly spaced membership functions.

if size(n)==[1 1], % n contains the number of membership functions
    alpha=range(1); beta=range(2);
    d=1/(n-1);
    mfmat=[-d 0 d];
    for i=1:(n-1)  % first generate the mf's over the interval [0,1]
        id=i*d;
        mf=[id-d id id+d];
        mfmat=[mfmat; mf];
    end
    mfmat=alpha+(beta-alpha)*mfmat;  % scale and translate the interval to [alpha,beta]
else % n is a vector defining the centres of membership functions
    peak=n;
    np=size(peak, 2);
    end1=peak(1)-abs(peak(2)-peak(1));
    end2=peak(end)+abs(peak(end)-peak(end-1));
    mfmat(:, 2)=peak';
    mfmat(:, 1)=[end1; peak(1:end-1)'];
    mfmat(:, 3)=[peak(2:end)'; end2];
end