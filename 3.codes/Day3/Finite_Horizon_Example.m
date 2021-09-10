%% --------------------------------------------------------------------%%
%%                        Finite Horizon Example                       %%
%% --------------------------------------------------------------------%%

% Primitives
T = 50;
N_state = 50;
N_opt = 10000;

V_grid = zeros(N_state,T+1);
V_grid(:,end) = zeros(N_state,1);
x_opt = zeros(N_state,T+1);

% State Variable Grid

y0_state = linspace(0.01,10,N_state);

% Utility functions

u = @(x)(log(x));
beta = 0.90;

for i = T:-1:1
    
    % Generation of Spline for Continuation Value Next Period
    
    V_prime_spline = spline(y0_state,V_grid(:,i+1));
    
    for j = 1:N_state
        
        % x_grid is the set of possible choices we can make. We ensure that
        % the set lies within (0,y0_state(i)) in order to satisfy the
        % constraints of the problem.
        
        x_grid = linspace(0.001,y0_state(j) - 0.001,N_opt)';
        
        
        [V_grid(j,i), x_opt_indic] = max(u(x_grid) + beta*fnval(V_prime_spline,y0_state(j) - x_grid));
        
        
        x_opt(j,i) = x_grid(x_opt_indic);
        
    end
    
end

% Saving Values

x_opt_finite = x_opt;
y0_state_finite = y0_state;

save('x_opt_finite','x_opt_finite')
save('y0_state_finite','y0_state_finite')


