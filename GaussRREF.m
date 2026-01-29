function R = GaussRREF(A)
% GaussRREF Computes the reduced row-echelon form (RREF) of a matrix.
%   R = GaussRREF(A) returns the matrix R which is the RREF of the input
%   matrix A. The function performs partial pivoting, row scaling, and row
%   elimination to achieve RREF. No built-in rref function is used.
%
%   Input:
%       A - A numeric matrix (m-by-n).
%
%   Output:
%       R - The reduced row-echelon form of A.
%
%   Example:
%       A = [1 2 1; 2 4 0; 3 6 3];
%       R = GaussRREF(A);
%


% Make a working copy so original matrix is not modified.
R = double(A);

% Get matrix dimensions.
[rows, cols] = size(R);

% Row index of the current pivot position.
pivotRow = 1;
% Tolerance for detecting zero pivots (relative to machine precision).
PIVOT_TOL = eps(class(R)) * 10;

for col = 1:cols
    if pivotRow > rows
        break; % No more rows to pivot.
    end

    % ------------------------------------------------------------------
    % TODO: 4-5 lines of code 
    % 1) PARTIAL PIVOTING: find the largest absolute value in the current
    %    column at or below the pivot row and swap rows if necessary.
    % ------------------------------------------------------------------
    [~, idxRel] = max(abs(R(pivotRow:rows, col)));
    pivotIdx = pivotRow + idxRel - 1;

    % If the pivot is effectively zero, move to next column.
    if abs(R(pivotIdx, col)) < PIVOT_TOL
        continue;
    end

    % Swap rows to move pivot into position.
    if pivotIdx ~= pivotRow
        R([pivotRow, pivotIdx], :) = R([pivotIdx, pivotRow], :);
    end

    % ------------------------------------------------------------------
    % 2) TODO: NORMALIZE: Scale the pivot row so that the pivot element is 1. 1 line of code 
    % ------------------------------------------------------------------
    R(pivotRow, :) = R(pivotRow, :) / R(pivotRow, col);

    % ------------------------------------------------------------------
    % 3) TODO: ELIMINATE: Use the pivot row to zero-out all other entries in the
    %    current column. 5-10 lines of code
    % ------------------------------------------------------------------
    for r = 1:rows
        if r == pivotRow
            continue;
        end
        factor = R(r, col);
        if abs(factor) > PIVOT_TOL
            R(r, :) = R(r, :) - factor * R(pivotRow, :);
            % optional cleanup for tiny roundoff:
            if abs(R(r, col)) < PIVOT_TOL
                R(r, col) = 0;
            end
        end
    end

    % Move to the next pivot row.
    pivotRow = pivotRow + 1;
end
end
