% scenarios
scenarios = {'1', '2', '3', '4'};
% parameters
params = {[0; -0.5], [0.1; -0.5], [0; -0.5], [0.1; -0.5]};
air_resistances = [0, 0.1, 0, 0.1];
winds = {@(x) 0, @(x) 0.1, @(x) 0, @(x) x(2)};
objective_types = {'minimize(sum(norms(u)))', 'minimize(sum(norms(u)))', 'minimize(max(norms(u)))', 'minimize(max(norms(u)))'};

for s = 1:length(scenarios)
    cvx_begin
        variables x(2,20) v(2,20) u(2,20)
        eval(objective_types{s})
        subject to
            x(:,2:20) == x(:,1:19) + v(:,1:19)
            for t = 1:19
                w = winds{s}(x(:,t+1));
                v(:,t+1) == v(:,t) + u(:,t) + params{s} - air_resistances(s)*v(:,t) + w
            end
            norms(u) <= 1
            x(:,1) == [-10; 0]
            v(:,1) == [0; 0]
            x(:,20) == [0; 0]
            v(:,20) == [0; 0]
    cvx_end
    
    figure
    plot(x(1,:), x(2,:))
    xlabel('x')
    ylabel('y')
    title(['Rocket Trajectory - Scenario ', scenarios{s}])
end

