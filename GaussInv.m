function B = GaussInv(A)
% GaussInv Computes the inverse of a square matrix using Gauss–Jordan.
%   B = GaussInv(A) returns the inverse of the square matrix A using the
%   GaussRREF routine. The algorithm augments A with the identity matrix,
%   performs Gauss–Jordan elimination, and examines the result:
%       [A | I]  --GaussRREF-->  [I | B]   =>  A is invertible, B = A^{-1}
%       otherwise                =>  A is singular, return [].
%   An error is thrown if A is not square.
%
%   Input:
%       A - Square numeric matrix (n-by-n).
%
%   Output:
%       B - Inverse of A if A is nonsingular; otherwise an empty matrix [].
%
%   Example:
%       A = [1 2; 3 4];
%       invA = GaussInv(A);
%


% ------------------------- Input Validation -----------------------------
[nRows, nCols] = size(A);
if nRows ~= nCols
    error('GaussInv:NonSquare', 'Input matrix must be square.');
end

% ------------------------- Augment Matrix -------------------------------
% TODO: 2-5 Lines of code, form the augmented matrix [A, I] and then simplify it to [I, A^-1] using GaussRREF
% ------------------------- Augment Matrix -------------------------------
I_n = eye(nRows, class(A));      % Identity matrix matching A's class
Aug = [double(A), double(I_n)];  % Form [A | I]
R = GaussRREF(Aug);              % Reduce to [I | A^-1] if invertible



% ------------------------- Check Invertibility --------------------------
TOL = 1e-10; % Numerical tolerance
leftBlock = R(:, 1:nRows);
I_n = eye(nRows, class(A));

if max(abs(leftBlock(:) - I_n(:))) < TOL
    % Successfully reduced to identity on the left -> invertible
    B = R(:, nRows+1:end);
else
    % Singular: return empty to denote None
    B = [];
end
end
