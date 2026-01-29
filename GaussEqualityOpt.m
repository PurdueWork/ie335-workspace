function [optVal, x, dirs] = GaussEqualityOpt(c, A, b)
% GaussEqualityOpt Solves max c^T x s.t. A x = b using Gauss-Jordan RREF.
%   [optVal, x, dirs] = GaussEqualityOpt(c, A, b) returns:
%     * optVal  - maximal objective value (numeric) or +Inf if unbounded.
%     * x       - one feasible solution (empty if infeasible).
%     * dirs    - matrix whose columns form non-basic directions of the feasible
%                 set. If unbounded, only one direction that increases the
%                 objective is returned; if bounded, all non-basic directions
%                 (which leave objective unchanged) are returned. Empty if
%                 infeasible.
%
%   Implementation strategy:
%     1) Form augmented matrix with leading column and objective row:
%        [1, -c^T, 0; 0, A, b] and compute its RREF (GaussRREF).
%     2) Detect infeasibility via contradictory rows in constraint rows.
%     3) Extract a particular feasible solution from constraint rows.
%     4) Use reduced costs from objective row to determine boundedness:
%        if any reduced cost < 0 (for non-basic variables), problem is
%        unbounded; otherwise objective is constant (negate top-right).
%
%

% ------------------------- Dimension Checks -----------------------------
[mA, n] = size(A);
if length(c) ~= n
    error('GaussEqualityOpt:DimMismatch', 'Length of c must equal number of columns of A.');
end
if size(b,1) ~= mA || size(b,2) ~= 1
    error('GaussEqualityOpt:DimMismatch', 'b must be a column vector with same number of rows as A.');
end

% --------------------- Augmented Matrix with Leading Column --------------
% Form [1, -c^T, 0; 0, A, b] where first column is for objective value,
% columns 2 to n+1 are x variables, last column is RHS
Aug = [1, -c(:)', 0; zeros(mA,1), A, b];
R = GaussRREF(Aug);

TOL = 1e-10;

% Extract objective row and constraint rows
objRow = R(1, :);
constraintRows = R(2:end, :);

% Column indices: 1 = obj value, 2:(n+1) = x variables, n+2 = RHS
xColStart = 2;
xColEnd = n + 1;
rhsCol = n + 2;

% Check infeasibility: 0 ... 0 | d with |d|>0 in constraint rows
if any(all(abs(constraintRows(:,xColStart:xColEnd))<TOL,2) & ...
       abs(constraintRows(:, rhsCol))>=TOL)
    optVal = [];
    x      = [];
    dirs   = [];
    return;
end

% --------------------- Identify Pivot and Non-basic Columns ------------------
% Use constraint rows to identify pivots (columns 2 to n+1)
% findPivotColumns returns indices relative to the submatrix, which
% directly correspond to variable indices 1 to n
[pivotCols, pivotRows] = findPivotColumns(constraintRows(:,xColStart:xColEnd), TOL);
nonbasicIdx  = setdiff(1:n, pivotCols);
basicIdx = pivotCols;

% --------------------- Particular Solution ------------------------------
% Initialize x with zeros and fill basic variables from RHS of constraints
x = zeros(n,1);
for k = 1:length(basicIdx)
    row = pivotRows(k);
    rhs = constraintRows(row, rhsCol);
    % Subtract contribution from non-basic variables (set to zero)
    nonbasicCols = nonbasicIdx + 1; % shift to matrix column indices
    x(basicIdx(k)) = rhs - constraintRows(row, nonbasicCols) * ...
                     x(nonbasicIdx);
end

% --------------------- Reduced Costs (from Objective Row) ----------------
% After RREF, objective row shows: -c^T x = -optVal + reduced_costs * x_nonbasic
% Reduced costs are in columns corresponding to non-basic variables
% Since we use -c, positive reduced cost means decreasing -c^T x (bad for max)
% and negative reduced cost means increasing -c^T x (good for max c^T x)
nonbasicCols = nonbasicIdx + 1; % shift to matrix column indices
reducedCosts = objRow(nonbasicCols);

% --------------------- Objective Analysis ------------------------------
if any(reducedCosts < -TOL)
    % Unbounded: find one improving direction (negative reduced cost)
    idx = find(reducedCosts < -TOL, 1);
    f = nonbasicIdx(idx);
    v = zeros(n,1);
    v(f) = 1; % non-basic variable parameter
    % Adjust basic variables according to RREF equations
    %--------------------------------------------------------
    % TODO: 1-5 Lines of code, find the direction which increases the objective value to +infty and set it to v
    %--------------------------------------------------------
    for k = 1:length(basicIdx)
        row = pivotRows(k);
        coeff = constraintRows(row, f + 1); % shift to matrix column index
        v(basicIdx(k)) = -coeff;
    end
    %--------------------------------------------------------
    optVal = Inf;
    dirs = v;
    return;
end

% All reduced costs >= 0 => objective constant
optVal = objRow(rhsCol); 
% Construct all non-basic directions (for bounded case)
numNonbasic = length(nonbasicIdx);
dirs = zeros(n, numNonbasic);
for j = 1:numNonbasic
    f = nonbasicIdx(j);
    v = zeros(n,1);
    v(f) = 1;
    % Adjust basic variables according to RREF equations
    for k = 1:length(basicIdx)
        row = pivotRows(k);
        coeff = constraintRows(row, f + 1); % shift to matrix column index
        v(basicIdx(k)) = -coeff;
    end
    dirs(:, j) = v;
end

end

% ------------------------------------------------------------------------
function [pivotCols, pivotRows] = findPivotColumns(RA, tol)
% Helper to identify pivot columns and corresponding rows from RREF matrix
[m, n] = size(RA);
pivotCols = [];
pivotRows = [];
row = 1;
for col = 1:n
    if row > m
        break;
    end
    if abs(RA(row, col)) > tol
        pivotCols(end+1) = col; %#ok<AGROW>
        pivotRows(end+1) = row; %#ok<AGROW>
        row = row + 1;
    end
end
end
