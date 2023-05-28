n_values = 10:10:100;
t_values = zeros(size(n_values));  % Array to store optimal values of t

step = 0.0003;
omega_low = 100;
omega_high = 2000;
omega_0 = 1000;
step_size = 50;

% Optimal values of t for increasing filter step numbers
for i = 1:length(n_values)
    n = n_values(i);
    M = floor((omega_high - omega_low) / step_size);  % Number of frequency bands

    cvx_begin
        variable x(n)
        variable t
        minimize(t)
        % Constraints
        for m = 1:M
            omega_m = omega_low + (m - 0.5) * step_size;
            Am = 2 * cos(2 * pi * omega_m * (1:n) / omega_0) * x;
            norm(Am) <= t;
        end
    cvx_end
    t_values(i) = cvx_optval;
end

figure;
plot(n_values, t_values, 'o-')
xlabel('n')
ylabel('Optimal t')
title('Optimal t vs. n')

% Attenuation factor for the optimal solution
n = 50;
M = floor((omega_high - omega_low) / step_size);  % Number of frequency bands

cvx_begin
    variable x(n)
    variable t
    minimize(t)
    for m = 1:M
        omega_m = omega_low + (m - 0.5) * step_size;
        Am = 2 * cos(2 * pi * omega_m * (1:n) / omega_0) * x;
        norm(Am) <= t;
    end
cvx_end

a = zeros(M+1, 1);  % Increase the length of 'a' vector by 1
for m = 1:M+1  % Iterate from 1 to M+1
    omega_m = omega_low + (m - 1) * step_size;  % Adjust the index
    Am = 2 * cos(2 * pi * omega_m * (1:n) / omega_0) * x;
    a(m) = norm(Am);
end

% Plot the attenuation factor
figure;
omega = omega_low + (0:M) * step_size;
plot(omega, a, 'o-')
xlabel('omega')
ylabel('Attenuation Factor')
title('Attenuation Factor vs. omega')