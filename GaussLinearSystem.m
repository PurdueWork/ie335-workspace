function x = GaussLinearSystem(A, b)
% GaussLinearSystem Solves a linear system Ax = b via Gauss–Jordan RREF.
%   x = GaussLinearSystem(A, b) returns one solution to the linear
%   system if it is feasible; otherwise returns an empty array []. The
%   method builds the augmented matrix [A | b], reduces it to RREF using
%   GaussRREF, checks for contradictions, and then recovers a solution by
%   assigning all non-basic variables to zero.
%
%   Input:
%       A - m-by-n numeric matrix.
%       b - m-by-1 numeric column vector (or row vector with m elements).
%
%   Output:
%       x - n-by-1 solution vector if system is feasible; otherwise [].
%
%   Example:
%       A = [1 1 1; 0 1 2];
%       b = [6; 4];
%       sol = GaussLinearSystem(A, b);
%
%

% ------------------------- Dimension Check ------------------------------
[mA, nA] = size(A);
[mB, nB] = size(b);
if nB ~= 1 && mB == 1
    % If b is given as row, transpose it
    b = b.';
    [mB, nB] = size(b);
end
if mA ~= mB || nB ~= 1
    error('GaussLinearSystem:DimensionMismatch', ...
        'A must be m-by-n and b must be m-by-1.');
end

% ------------------------- Augmented Matrix -----------------------------
aug = [A, b];
R = GaussRREF(aug);

% ------------------------- Feasibility Check ----------------------------
TOL = 1e-10;
left = R(:, 1:nA);
rhs  = R(:, end);

% Detect contradictory rows: zero in left but non-zero in rhs
contradict = all(abs(left) < TOL, 2) & (abs(rhs) >= TOL);
if any(contradict)
    x = [];
    return;
end

% ----------------------- Identify Pivot Columns -------------------------
% pivotCol(row) = index of first non-zero in that row (or 0 if row is zero)
pivotCols = zeros(1, nA);
row = 1;
for col = 1:nA
    if row > size(R,1)
        break;
    end
    if abs(R(row, col)) > TOL
        pivotCols(col) = 1; 
        row = row + 1;
    end
end
basicIdx = find(pivotCols == 1);
nonBasicIdx  = find(pivotCols == 0);

% ----------------------- Construct Solution -----------------------------
x = zeros(nA, 1);

% Assign free variables zeros (already zero in x)

% ------------------------------------------------------------------
%  TODO: 2-5 Lines of code, reconstruct the solution x from the RREF matrix R
% Reconstruct solution: basic variables = rhs - sum(coeffs * freeVars)
for i = 1:numel(basicIdx)
    r = i; % pivot rows appear in order from the top in RREF
    x(basicIdx(i)) = rhs(r) - left(r, nonBasicIdx) * x(nonBasicIdx);
end
end
