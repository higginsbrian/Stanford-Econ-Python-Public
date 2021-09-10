%% Preliminary Problem Set

%% Section 1: TripAdvisor Dataset

% Mentiond explicitly what it means to call on a specific sheet
[data textdata] = xlsread('Trip_Advisor.xlsx','Raw');

% Is there a code that can be written to find a string value?

Prices = unique(textdata(2:end,5));

No_Price = strcmp(textdata(2:end,5),Prices(1));
Price_Low = strcmp(textdata(2:end,5),Prices(2));
Price_Med = strcmp(textdata(2:end,5),Prices(3));
Price_Hig = strcmp(textdata(2:end,5),Prices(4));

% Just check that the each row is assigned to one of the above
check = (1-No_Price).*(1-Price_Low).*(1-Price_Med).*(1-Price_Hig);
max(check)

% Our Next Step is to Remove Points With:
% 1. Unsuccessful Merge
% 2. No indication of price range

%1. Does Indicator where Merge is successful (there exists a user rating)
Merged = ~isnan(data(:,3));

%2. Finds rows where Price Indication actually exists
Price_Ind = 1-No_Price;

%The final step is to find rows where both 1. and 2. are true
Price_and_Merged = find(Merged.*Price_Ind==1);

% Make a New Data File with Rows satisfying 1. and 2.
data_matrix = [data Price_Low Price_Med Price_Hig];
data_matrix = data_matrix(Price_and_Merged,:);

% Assignment of Variable Names
placeId = data_matrix(:,1);
reviewNumber = data_matrix(:,2);
userRating = data_matrix(:,3);
userContributions = data_matrix(:,4);
rating_rest = data_matrix(:,6);
NumberofReviews = data_matrix(:,7);
isGreat = data_matrix(:,8);
isFriendly = data_matrix(:,9);
isFresh = data_matrix(:,10);
isOk = data_matrix(:,11);
Price_Low = data_matrix(:,12);
Price_Med = data_matrix(:,13);
Price_Hig = data_matrix(:,14);

% Creation of Figures
figure;
histogram(userRating)

% Generation of Regressions
N = length(userRating);
y = userRating;
X = [ones(size(userRating)) isGreat]; % Mention why length would be wrong here
b = X\y;

% Question 1: Calculation of Standard Errors
e = userRating - X*b; % Error Terms
sigma_2 = (1/(size(X,1)-size(X,2)))*sum(e.^2); % Estimate of error variance
st_err_2 = sigma_2*pinv(X'*X); %pinv can evaluate inverse of matrices that may be singular
t_stat = b./sqrt(diag(st_err_2));

% Generation of Regressions with Multiple Variables
% Note: Price_Low not included in order to avoid multi-collinearity
X = [ones(size(userRating)) isGreat isFresh isOk Price_Hig Price_Med];
b = X\y;

% Calculation of Standard Errors
e = userRating - X*b;
sigma_2 = (1/(size(X,1)-size(X,2)))*sum(e.^2);
st_err_2 = sigma_2*pinv(X'*X); %pinv is an inverse of matrices that may that may be singular
t_stat = b./sqrt(diag(st_err_2));

% Question 2: Construction of Figure
y_pred = X*b;
figure;
scatter(y_pred,y)
hold on;
plot(1:5,1:5)
xlim([3.5 5])


%% Section 2: Fibonacci Numbers

% Part (a): Recursion
tic;
fibo_recursion(30)
toc;
% Part (b): Loop
tic;
fibo_loop(30)
toc;

% Question 1: Loop Providing as Output the First n elements
% fibo_loop_vec.m is when it is written under loops. Through a very similar
% exercise, it can be written with recursions instead.
fibo_loop_vec(30)

% Question 2: Comparison of Performance
N = 30; % Run for small and then large N
run_time = zeros(N,2);
tic; toc;
for n = 1:N
    tic
    fibo_loop(n);
    run_time(n, 1) = toc;
    
    tic
    fibo_recursion(n);
    run_time(n, 2) = toc;
end

% Generating the figure to compare performance
figure;
plot(1:N, run_time); legend('loop','recursion');

%% Section 3: Numerical Integration / Pareto Distribution

% Question 1: paretopdf.m
% Question 2: paretocdf.m

% Question 3: Plotting Pareto Density
x_m = 1;
alpha = 2;
grid = 1.01:0.01:10;

figure;
plot(grid,paretopdf(grid,x_m,alpha),'Linewidth',1.5);
xlabel('x')
ylabel('PDF')

% Question 4: Define the grid
Interval = [3 4];
step_size = 0.01;
grid = Interval(1):step_size:Interval(2);

% Question 5: Evaluate Pareto Density on grid
f_x = paretopdf(grid,x_m,alpha);

% This is plotting the pdf evaluated on the grid
figure;
plot(grid,f_x)

% Question 6: Approximation of Likelihood Variable Drawn within [3 4]
Probability = sum(f_x)*step_size/(Interval(2)-Interval(1));

% Sanity Check: Compare with CDF
a = paretocdf(4,x_m,alpha);
b = paretocdf(3,x_m,alpha);

Probability_CDF = a-b;

