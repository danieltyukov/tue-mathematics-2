% Set the canvas group number
g = 17;

% Set the seed for the random number generator
rng(g);

% Define the dimensions and true parameters
n = 4;
m = 12;
xt = [2, 3, -7, 1];

% Generate the A matrix and b vector
A = random('Normal', 0, 10, m, n);
disp(A')
b = A * xt' + random('Normal', 0, 1, m, 1);

cvx_begin
    variables x(n) t(m)
    dual variables y1 y2 y3 y4
    minimize(sum(t))
    subject to
        y1:  2 * (A * x - b) <= t + 1
        y2: -2 * (A * x - b) <= t + 1
        y3:      A * x - b  <= t
        y4:     -A * x + b  <= t
cvx_end

% Optimal primal solution x* and optimal objective value
x_star = x
min_value = cvx_optval

% Optimal dual solution
opt_dual_solution = [y1; y2; y3; y4]