clc;
clear;
parpool

N_state = 10000;

% grids and inialized vectors
x_grid = linspace(0.01,10,N_state);
choice = repmat(x_grid,[N_state,1]);
utility = zeros(N_state,N_state);
max_utility_loop = zeros(N_state,N_state);
max_index_loop = zeros(N_state,N_state);

u = @(x)(log(x));

% compute utility
utility = u(choice) ;
utility(choice>x_grid') =-10;

% create gpu array of utility
utility_gpu =  gpuArray(utility) ;

% compute maximum
tic
disp('CPU, loop: ')
for i = 1:1:N_state
    [max_utility_loop(i), max_index_loop(i)] = max(utility(i,:));
end
time_cpu_loop = toc

tic
disp('CPU, par loop: ')
parfor i = 1:1:N_state
    [max_utility_loop(i), max_index_loop(i)] = max(utility(i,:));
end
time_cpu_parloop = toc

tic
disp('CPU vectorized: ')
[max_utility, max_index] = max(utility,[],2);
time_cpu = toc

tic
disp('GPU: ')
[max_utility_gpu, max_index_gpu] = max(utility_gpu,[],2);
time_gpu = toc


disp('speedup par loop')
disp(time_cpu_loop/time_cpu_parloop)
disp('speedup Vectorize')
disp(time_cpu_loop/time_cpu)
disp('speedup GPU (vs vec)')
disp(time_cpu/time_gpu)
disp('speedup GPU (vs loop)')
disp(time_cpu_loop/time_gpu)

figure
hold on
plot(x_grid,x_grid(max_index))
plot(x_grid,x_grid(max_index_gpu), '--')
legend('CPU','GPU')
hold off

disp('end')



