%% --------------------------------------------------------------------%%
%%                        Solving Endowment Economy                    %%
%% --------------------------------------------------------------------%%


%% Setting Up Endowments and Initial Demand

clear all; close all; clc;

y = [10,5;5,40];

totals = sum(y); % This sums over each column, which is what we want.

figure;
hold on;
rectangle('Position',[0 0 totals],'LineWidth', 2);
scatter(y(1,1),y(1,2),50, 'k', 'filled');

% INDIFFERENCE CURVE FOR A

% Assign the preference parameter (sigma = 1/(1-r))
r = 0.6;

% Now we will create the indifference curves for this model. These
% functions below rid of the argument 'r' which we have fixed and will not
% change hereafter


utility = @(x)(ces_utility(x,r));
indiff = @(u,x)(ces_indiff(u,x,r));

% This is evaluating the utility at endowment point

u_A = utility(y(1,:));

% Grids of all choices that are feasible
x_A1 = 0.0:0.01:totals(1);

% The corresponding choice of x_2 that achieves endowment utility
x_A2 = indiff(u_A,x_A1);

% Plotting the indifference curve
plot(x_A1,x_A2, 'r', 'LineWidth',2);

% INDIFFERENCE CURVE FOR B

% This is evaluating the utility at endowment point
u_B = utility(y(2,:));

% This is a grid of all choices that are feasible
% I set the minimum at 3.5 because otherwise required holdings of Good 2
% goes beyond Edgeworth Box
x_B1 = 3.5:0.01:totals(1);

% The corresponding choice of x_2 that achieves endowment utility
x_B2 = indiff(u_B,x_B1);



% Plotting the indifference curve
hold on;
plot(totals(1)-x_B1,totals(2)-x_B2,'b','Linewidth',2)

% BUDGET CONSTRAINT OF A
p1 = 1;
p2 = 0.5;
w = p1*y(1,1) + p2*y(1,2); % Evaluation of wealth

x_1 = 0:0.01:(w/p1);

x_2 = (p2^(-1))*(w-x_1);

% Add the budget constraint to the graph
plot(x_1,x_2,'Linewidth',1.5)

% SOLVING THE MAXIMIZATION PROBLEM

% Here write out the minimisation problem


f = @(x)(-utility(x));
x0 = y(1,:)';
p = [1 1];
A = [p;-eye(2)];
b = [p*x0;0;0];
[x, u] = fmincon(f,x0,A,b);
u = -u;

% Examine construction of "demand" function
%% Construction of Graph with Original Demand

% Re-Creating the figure for the Edgeworth Box with Endowment Point
figure;
hold on;
rectangle('Position',[0 0 totals],'LineWidth', 2);
scatter(y(1,1),y(1,2),50, 'k', 'filled');

% Construct The Budget Constraints for Agent A and Agent B (overlap)
p1 = 1;
p2 = 0.5;
p = [p1 p2];
w = p1*y(1,1) + p2*y(1,2); % Evaluation of wealth

x_1 = 0:0.01:(w/p1);

x_2 = (p2^(-1))*(w-x_1);

plot(x_1,x_2,'Linewidth',2)

% Find the Demand Points for each of the two agents

[xA u] = demand(y(1,:),p,utility);
scatter(xA(1),xA(2),50,'r','filled');

[xB u] = demand(y(2,:),p,utility);
scatter(totals(1) - xB(1),totals(2) - xB(2),50,'y','filled');

% Creation of Indifference Curves
u_A = utility(xA);
x_A1 = 0:0.01:totals(1);
x_A2 = indiff(u_A,x_A1);
plot(x_A1,x_A2,'Linewidth',1);

u_B = utility(xB);
x_B1 = 3.3:0.01:totals(1);
x_B2 = indiff(u_B,x_B1);
plot(totals(1) - x_B1,totals(2) - x_B2,'Linewidth',1);

%% Finding the Equilibrium

% Deriving the equilibrium requires equilibrating aggregate demand and
% supply. Recall you can set one good as a numeraire. Supply is fixed but
% demand can vary.

% This is the function that evaluates total demand given price, endowments
% and utility function
totaldemand(y,p,utility)

% The next step is to explicitly calculate the demand curve. I will fix the
% price of good 1 as the numeraire, and then vary the price of good 2

p2_vec = 0.1:0.01:1;
x2_vec = zeros(size(p2_vec));

for i = 1:length(p2_vec)
    x_temp = totaldemand(y,[1 p2_vec(i)],utility);
    x2_vec(i) = x_temp(2);
end

% Plotting the Demand and Supply Curve for visuals
figure;
plot(x2_vec,p2_vec,'Linewidth',2);
hold on;
plot(totals(2)*ones(size(p2_vec)),p2_vec,'Linewidth',2)
xlabel('Quantity')
ylabel('Price')
legend('Demand','Supply','Location','northeast')

% Explicit Calculation of the Equilibrium

% Now, given the graph, we can easily understand a reasonable lower and
% upper bound for the price of good 2
p_L = 0.1;
p_H = 1;
d = 1;

while abs(d) > 0.01
    p = (p_L + p_H)/2;
    x = totaldemand(y,[1 p],utility);
    d = x(2) - totals(2);
    
    if d > 0
        p_L = p;
    else
        p_H = p;
    end
end

% Set what the optimal price is
p_optimal = p;

%% Creation of Edgeworth Box at the Optimal Point

% Creating the figure for the Edgeworth Box with Endowment Point
figure;
hold on;
rectangle('Position',[0 0 totals],'LineWidth', 2);
scatter(y(1,1),y(1,2),50, 'k', 'filled');

% Optimal Demand Points
[xA u] = demand(y(1,:),[1 p_optimal],utility);
scatter(xA(1),xA(2),50,'r','filled');

[xB u] = demand(y(2,:),[1 p_optimal],utility);
scatter(totals(1) - xB(1),totals(2) - xB(2),50,'b','filled');

% Drawing of Budget Constraint
w = y(1,1) + p_optimal*y(1,2); % Evaluation of wealth

x_1 = 0:0.01:w;

x_2 = (p_optimal^(-1))*(w-x_1);

plot(x_1,x_2,'Linewidth',2)

% Drawing of Indifference Curves (again I manually set the boundaries to
% get the indifference curves to fit within the box nicely

u_A = utility(xA);
x_A1 = 0.5:0.01:totals(1);
x_A2 = ces_indiff(u_A,x_A1,r);
plot(x_A1,x_A2,'Linewidth',1);

u_B = utility(xB);
x_B1 = 4:0.01:totals(1);
x_B2 = ces_indiff(u_B,x_B1,r);
plot(totals(1) - x_B1,totals(2) - x_B2,'Linewidth',1);

% Note that, by increasing r, you are decreasing the degree of
% complementarity and bringing them closer to perfect substitutes. 