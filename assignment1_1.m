rng(17)
n = 4;
m = 12;
xt= [2,3,-7,1];
A = random('Normal',0,10,m,n);
b = A*xt'+ random('Normal', 0,1, m,1);

[t, x] = bisection(A,b)

function [t, x] = bisection(A,b)
    tmin = 0;
    tmax = 2;
    z = 0;
    while (tmax - tmin) > 0.001 || z ~= 1
        t = (tmax + tmin) / 2;
        [z, x] = feasible(t,A,b);
        if z == 0
            tmin = t;
        else
            tmax = t;
        end
    end
    t = (tmax + tmin) / 2;
end

function [z, x] = feasible(t,A,b)
    cvx_begin
   		variable x(4)
   		minimize 0
   		max(abs(b-A*x))<=t;
    cvx_end
    z = 0;
    if strcmp(cvx_status, 'Solved')
        z = 1;
    end
end
