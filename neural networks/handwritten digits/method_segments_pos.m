function[pos] = method_segments_pos(method) % return a num_of_features X 4 vetor storing the segment coordinates
if method == 1 % method A: 7 regions method
    pos = [
        [1,2,2,9];
        [10,11,2,9];
        [19,20,2,9];
        [1,9,1,3];
        [1,9,8,10];
        [11,19,1,3];
        [11,19,8,10]
        ];
   
else            % method B: 36 regions method
    pos = zeros(36, 4);
    % last two entries
    for i=1:36
        remain = mod(i,4);
        if(remain == 1)     % 1st column in divided segments
            pos(i,3)=1;
            pos(i,4)=3;
        elseif(remain == 2) % 2nd column in divided segments
            pos(i,3)=4;
            pos(i,4)=5;
        elseif(remain == 3) % 3rd column in divided segments
            pos(i,3)=6;
            pos(i,4)=7;
        else                % 4rd column in divided segments
            pos(i,3)=8;
            pos(i,4)=10;
        end
    end
    
    % first two entries
    pos(1:4,1)=1;
    pos(1:4,2)=2;
    pos(5:8,1)=3;
    pos(5:8,2)=5;
    pos(9:12,1)=6;
    pos(9:12,2)=7;
    pos(13:16,1)=8;
    pos(13:16,2)=9;
    pos(17:20,1)=10;
    pos(17:20,2)=11;
    pos(21:24,1)=12;
    pos(21:24,2)=13;
    pos(25:28,1)=14;
    pos(25:28,2)=15;
    pos(29:32,1)=16;
    pos(29:32,2)=18;
    pos(33:36,1)=19;
    pos(33:36,2)=20;
    
end