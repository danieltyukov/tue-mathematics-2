rng(17);
n=4;
m = 12;
xt = [2,3,-7, 1];
A = random('Normal',0,10,m,n);
b = A*xt' + random('Normal', 0,1,m,1);

cvx_begin
    variables x(n) t(m);
    dual variables y w;
    minimize(sum(t));
    subject to
        y: -t<=b-A*x
        w: b-A*x<=t
cvx_end

t
x
[y; w]