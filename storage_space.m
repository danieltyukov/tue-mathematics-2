% optimal solution x*
% optimal dual solution u*
% the common optimal value

p = [3,7,5,8,7,3,11,9,6,5,13,11,10,8,4,15,13,12,11,8,5];
d = [410, 530, 220, 750, 170, 210]';
m=6;
A = zeros(m, m*(m+1)/2);

for k = 1:m
    for i = 1:k
        for j = k:m
            A(k, j*(j-1)/2+i) = 1;
        end
    end
end
disp(A)

cvx_begin
    variables x(m*(m+1)/2)
    dual variables u w
    u: A*x>=d;
    w: x>=0;
    minimize p*x
cvx_end
disp("Optimal sol x*")
disp(x)
disp("Optimal dual sol u*")
disp(u)