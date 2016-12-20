function [result] = ANNResult2( M )
% This function aims to get the index of the identified person
    [iRow,iCol]= size(M);
    
    for i = 1:iCol
        [value, index] = max(M(:,i));
         result(i)=index;
    end
    
end

