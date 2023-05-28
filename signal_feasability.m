n=10; % num of transmitters
m=100; % num of receievers

transmitters = 10 * rand(2,n); % in 10x10 square at random
receivers = 10 * rand(2,m); %in 10x10 square at random
map = zeros(1,m); % closest transmitter to each receiver

pmax = 1; % maximum of p must be set to zero by the exercise
A = zeros(n, 1, n); % 2nd dimension will expand as needed
N = zeros(n, 1); % noises

% parse input, find the closest transmitter for each receiver
for j=1:m
    mindist = 100000;
    mintrans = -1;
    for k=1:n
        % distance between transmitter and receiver
        dist = sqrt((transmitters(1, k) - receivers(1, j))^2 + (transmitters(2, k) - receivers(2, j))^2);
        if dist < mindist
            mindist = dist;
            mintrans = k;
        end
    end
    map(j) = mintrans;
end

nextindex = 1 + zeros(1,n);
% assign the values to A_{ijk}, the inverse of distance between the
% transmitter and recieiver
for j=1:m
    index = nextindex(map(j));
    nextindex(map(j)) = nextindex(map(j)) + 1;
    for k=1:n
        a = 1/((transmitters(1, k) - receivers(1, j))^2 + (transmitters(2, k) - receivers(2, j))^2);
        A(map(j), index, k) = a;
    end
end

% add random noise N in [0.1, 0.2]
for i=1:n
    for j=1:nextindex(i)-1
        N(i,j) = 0.1 + 0.1*rand;
    end
end
% opt value of t
output = bisection(A,N,pmax);
disp(output)

%functions --------------------------------------------------------

% bisection
function [t] = bisection(A,N,pmax)
    % t must be between 0 and 1
    tmin = 0;
    tmax = 1;
    % z: boolean representing the feasibility, initially False.
    z = 0;
    % do bisection while the range is larger than 0.001 and z no feasible.
    while (tmax - tmin) > 0.001 || z ~= 1
        % shrink bisection space
        t = (tmax + tmin) / 2;
        % check feasibility for t
        [z, p] = feasible(A, N, pmax, t);
        % if feasible, then opt >= tmin
        if z == 1
            tmin = t;
        % if not feasible, then opt < tmax
        else
            tmax = t;
        end
    end
    t = (tmax + tmin) / 2;
end

% is t feasible?
function [z, p] = feasible(A,N,pmax,t)
    cvx_begin
        % create i dimensional vector p
        variable p(size(A,1));
        % constraints: see slide 11 of Lecture 2
        0 <= p <= pmax;
        % constraint for each (i, j)
        for i = 1:size(A, 1)
            for j = 1:size(A, 2)
                % sum(t * A_ijk * p_k ) - t A_iji p_i + t N_ij <= A_iji p_i
                t * reshape(A(i, j, :), [1, size(A, 3)]) * p - t * A(i, j, i) * p(i) + t * N(i, j) <= A(i, j, i) * p(i);
            end
        end
    cvx_end
    % get whether cvx solution is feasible
    z = false;
    if strcmp(cvx_status, 'Solved')
        z = true;
    end
end