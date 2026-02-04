clear; clc

f = [1; 1];

% Constraints are of the form A*x <= b for linprog.
% Convert >= constraints by multiplying by -1:
% 2x1 + x2 >= 10  ->  -2x1 - x2 <= -10
% 2x1 + 3x2 >= 16 ->  -2x1 - 3x2 <= -16
A = [-2 -1;
     -2 -3];
b = [-10;
     -16];

lb = [0; 0];   % x1, x2 >= 0

opts = optimoptions('linprog','Display','none');
[x, fval] = linprog(f, A, b, [], [], lb, [], opts);

x1 = x(1);
x2 = x(2);

fprintf('Optimal days in mine 1 (x1): %.4f\n', x1);
fprintf('Optimal days in mine 2 (x2): %.4f\n', x2);
fprintf('Minimum total days: %.4f\n', fval);

% Optional: check amounts collected
gold   = 2*x1 + 1*x2;
silver = 2*x1 + 3*x2;
fprintf('Gold collected: %.4f lb\n', gold);
fprintf('Silver collected: %.4f lb\n', silver);