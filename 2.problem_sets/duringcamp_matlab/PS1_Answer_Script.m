%% Problem_Set_2 Script

%% Q1(a)

% Take a note on:
% 1) You need to put [ . ] brackets in the maximum
% 2) The value today when not realized starts with a cash flow of -k
T = 20;
p = 0.5;
k = 100;
K = 150;
r = 0.05;
[v, d] = patent_recursion(p,r,0,k,K,0,T);

Value_Recursion = v;
Renewed = d;
%% Q1(b) 

% We now go through all possible values of p to see the value of the patent
N_p = 100;
p_vec = linspace(0.01,1,N_p);
v = zeros(N_p,1);

for i = 1:N_p
    v(i) = patent_recursion(p_vec(i),r,0,k,K,0,T);
end

% We now evaluate the value function where there is no choice to not renew
v_renew = zeros(N_p,1);

for i = 1:N_p
    v_renew(i) = patent_recursion_renew(p_vec(i),r,0,k,K,0,T);
end

% Plotting the Figure
figure;
plot(p_vec,v,'Linewidth',2)
hold on;
plot(p_vec,v_renew,'Linewidth',2)
ylim([-100,600])
legend('Option','No Option','Location','southeast');
xlabel('Probability (p)')
ylabel('Patent Value')

%% Question 2(a)

% Note that, as T -> infinity, the realized patent is basically just 
% valuing a perpetuity at (K-k) + (K-k)/r.

p = 0.2;
T = 21;
[V, D] = patent_loop(p,r,k,K,T);

figure;
plot(0:1:T+1,V(1,:),'Linewidth',2);
hold on
plot(0:1:T+1,V(2,:),'Linewidth',2);
legend('Realized','Unrealized','Location','northeast');
xlabel('t')
ylabel('Patent Value')

%% Question 3

% Now notice here that, when moving from t to t+1, the number of states
% expands by 1
p = 0.8;
q = 1.03;
r = 0.05;
k = 100;
x = 80;
T = 50;

% Construct Graph for the Solution
[X,T,V,D] = patent_value_Q3(p,q,r,k,x,T,2); 

% Now, "triu" makes the upper triangular matrix of X, but sets
% the lower triangular part to 0. Thus, we set these values to NaN.
% Finally, we only go down 20 rows for the diagonal because beyond this the
% function explodes and makes the graph look terrible

X = triu(X);
V = triu(V);
X(X==0) = NaN;

figure;mesh(X,T,V,D)
xlabel('cashflow');
ylabel('period');
zlabel('patent value');
colormap(cool)

%% Question 3(b): Patent Value when you Always Renew

% Make a note that the mesh can look a little bit off when we have high
% payoffs
p = 0.8;
q = 1.03;
r = 0.05;
k = 0;
x = 60;
T = 50;

% Construct Graph for the Solution
[X,T,V,D] = patent_value_Q3(p,q,r,k,K,T,2); 

% Now, "triu" makes the upper triangular matrix of X, but sets
% the lower triangular part to 0. Thus, we set these values to NaN.
% Finally, we only go down 20 rows for the diagonal because beyond this the
% function explodes and makes the graph look terrible

X = triu(X,-20);
X(X==0) = NaN;

figure;mesh(X,T,V,D)
xlabel('cashflow');
ylabel('period');
zlabel('patent value');
colormap(cool)

