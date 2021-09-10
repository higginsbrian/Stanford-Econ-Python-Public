%% --------------------------------------------------------------------%%
%%                        Solving Endowment Economy                    %%
%% --------------------------------------------------------------------%%


%% Setting Up Endowments and Initial Demand

clear all; close all; clc;

y = [10,5;5,40];

totals = sum(y); % This sums over each column, which is what we want.

% Assign the preference parameter (sigma = 1/(1-r))
r = 0.6;

utility = @(x)(ces_utility(x,r));
indiff = @(u,x)(ces_indiff(u,x,r));

%% Creation of demand and totaldemand

% 1. demand.m writes out the fmincon code for each individual agent. It
% follows exactly the steps we covered in Lecture 2. 
% 2. totaldemand generates total demand of good 2 given price p of good 2.
% By Walras Law, we just need to clear Good 2 market.

% Testing totaldemand function works
p2 =.5;
totaldemand(y,p2,utility)


% The next preliminary step is to draw the supply and the demand curve. I 
% will fix the price of good 1 as the numeraire, and then vary the price of
% good 2 along the y axis. It will indicate to us the market-clearing
% price.


p2_vec = 0.1:0.01:1;
x2_vec = zeros(size(p2_vec));

for i = 1:length(p2_vec)
    x_temp = totaldemand(y,p2_vec(i),utility);
    x2_vec(i) = x_temp;
end

figure;
plot(x2_vec,p2_vec,'Linewidth',2);
hold on;
plot(totals(2)*ones(size(p2_vec)),p2_vec,'Linewidth',2)
xlabel('Quantity')
ylabel('Price')
legend('Demand','Supply','Location','northeast')


%% Optimization Problem

% This then leads to the core problem: solving for the market-clearing
% price of good 2. What we do here is generate a function,  called
% Net_Demand_Given_p, that evaluates excess demand for good 2.

Net_Demand_Given_p = @(p)(totaldemand(y,p,utility)-totals(2));

% This is just a test that it works
Net_Demand_Given_p(.5)

% To solve for the market-clearing price, we use the fzero function, which 
% finds the value x_star for the function f(x) such that f(x_star)=0. It 
% has two arguments: 1. the function, and 2. the starting value for x, x_0.

market_clearing_p2 = fzero(Net_Demand_Given_p,.5);


