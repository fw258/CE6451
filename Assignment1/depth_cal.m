function [depth_mat] = depth_cal(maskobj,nf)
m = size(maskobj,1);
n = size(maskobj,2);
mn = m*n;
A = sparse(2*mn,mn); % sparse matrix save space
b = zeros(2*mn,1);
tic
num = 1;
for i = 1:(m-1)
    for j = 1:(n-1)
        index = n*(i-1) + j;
        % if the object mask has value moving one unit right and up
        % can make it two equations
        % the last condition is to make sure not divided by 0
        if maskobj(i,j) ~= 0 && maskobj(i+1,j) ~= 0 && maskobj(i,j+1) ~= 0 && nf(i,j,3) ~= 0
            % mark non-zero columns
            record(num,1) = index;
            record(num,2) = index + 1;
            record(num,3) = index + n;
            b(2*index - 1) = -nf(i,j,1)/nf(i,j,3);
            b(2*index) = -nf(i,j,2)/nf(i,j,3);
            A(2*index - 1, index + n) = 1;
            A(2*index - 1, index) = -1;
            A(2*index, index + 1) = 1;
            A(2*index, index) = -1;
            num = num + 1;
        end
    end
end
% get unique non-zero column index
nonzero_col = unique(record);
% find a point as the reference
mark = nonzero_col(1);
nonzero_col = nonzero_col(2:end);
Asub = A(:,nonzero_col);
% solve for x using cholesky decomposition
Asym = Asub'*Asub;
[R,flag] = chol(Asym); % Asym = R'*R, Asym*x = A'b
depth = R\(R'\Asub'*b);
%d = (R'\Asub'*b);
%depth = R\d;
% normalize values to a range between 0 and 1
depth_min = min(depth);
depth_max = max(depth);
depth_n = (depth - depth_min) / (depth_max - depth_min);
% reconstruct original vector (the reference point automatically has 0
% depth)
depth_full = zeros(mn,1);
depth_full(nonzero_col) = depth_n;
% convert to 600*800 matrix
depth_mat = transpose(reshape(depth_full,size(maskobj,2),size(maskobj,1)));
toc
end
