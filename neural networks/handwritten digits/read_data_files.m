function[nV, nVnoise, nS, nSnoise] = read_data_files(method)

% ********************************
% ****** reading from files ******
% ********************************
num = 10;

numV_Files = dir('numV/*.bmp');
numS_Files = dir('numS/*.bmp');
numVnoise_Files = dir('numVnoise/*.bmp');
numSnoise_Files = dir('numSnoise/*.bmp');

numV_raw = cell(1, num);
numS_raw = cell(1, num);
numVnoise_raw = cell(1, num);
numSnoise_raw = cell(1, num);

for i = 1:num 
  numV_raw{i} = imread([numV_Files(i).folder  '/' numV_Files(i).name]); 
  numS_raw{i} = imread([numS_Files(i).folder  '/' numS_Files(i).name]);
  numVnoise_raw{i} = imread([numVnoise_Files(i).folder  '/' numVnoise_Files(i).name]);
  numSnoise_raw{i} = imread([numSnoise_Files(i).folder  '/' numSnoise_Files(i).name]);
end


% ********************************
% ****** date preprocessing ******
% ********************************
 
% step 1: convert to double

numV_double = cell(1, num);
numS_double = cell(1, num);
numVnoise_double = cell(1, num);
numSnoise_double = cell(1, num);
for i = 1:num
   numV_double{i} = double(numV_raw{i}(:,:,1))/255;  
   numS_double{i} = double(numS_raw{i}(:,:,1))/255;
   numVnoise_double{i} = double(numVnoise_raw{i}(:,:,1))/255;
   numSnoise_double{i} = double(numSnoise_raw{i}(:,:,1))/255;
end

% step 2: obtain input vectors

if method == 1                      % method A: 7 regions method
    nV = zeros(10, 7);
    nS = zeros(10, 7);
    nVnoise = zeros(10, 7);
    nSnoise = zeros(10, 7);
    p = method_segments_pos(method);
    for i = 1: 10 % 10 numbers, i.e. 10 rows
        for j = 1: 7 % 7 features, i.e. 7 columns
            nV(i,j) = mean_matrix(numV_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nS(i,j) = mean_matrix(numS_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nVnoise(i,j) = mean_matrix(numVnoise_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nSnoise(i,j) = mean_matrix(numSnoise_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
        end
    end
    
    
elseif method == 2                  % method B: 36 regions method
    nV = zeros(10, 36);
    nS = zeros(10, 36);
    nVnoise = zeros(10, 36);
    nSnoise = zeros(10, 36);
    p = method_segments_pos(method);
    for i = 1: 10 % 10 numbers, i.e. 10 rows
        for j = 1: 36 % 7 features, i.e. 36 columns
            nV(i,j) = mean_matrix(numV_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nS(i,j) = mean_matrix(numS_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nVnoise(i,j) = mean_matrix(numVnoise_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
            nSnoise(i,j) = mean_matrix(numSnoise_double{i}(p(j,1):p(j,2), p(j,3):p(j,4)));
        end
    end

    
else                                % method C: point-by-point method
    nV = zeros(10, 200);
    nS = zeros(10, 200);
    nVnoise = zeros(10, 200);
    nSnoise = zeros(10, 200);
    for i = 1:10 % 10 numbers
        % squeeze to 1X200 vectors
           nV(i,:) = reshape(numV_double{i}, 1, []);  
           nS(i,:) = reshape(numS_double{i}, 1, []); 
           nVnoise(i,:) = reshape(numVnoise_double{i}, 1, []);
           nSnoise(i,:) = reshape(numSnoise_double{i}, 1, []);
    end
    
end

