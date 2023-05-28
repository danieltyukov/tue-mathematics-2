n = 2;
% compare with 2,4,8,16

cvx_begin
    variables h(n+1,n+1) a(n,n)
    minimize(sum(sum(a)))
    
    subject to
        % Constraints
        % (1) Surface area of each triangle
        for i = 1:n
            for j = 1:n
                a(i,j) >= 0.5 * norm([(i-1) (j-1) h(i,j)] - [(i-1) j h(i,j+1)] - [i (j-1) h(i+1,j)], 2);
                a(i,j) >= 0.5 * norm([(i-1) j h(i,j+1)] - [i (j-1) h(i+1,j)] - [i j h(i+1,j+1)], 2);
            end
        end
        
        % (2) Boundary conditions
        for j = 1:n+1
            h(1,j) == (j-1)*(n-(j-1))/(n^2);
            h(n+1,j) == (j-1)/n;
        end
cvx_end

% Display the optimal solution
fprintf('Optimal Surface Area: %.4f\n', cvx_optval);

