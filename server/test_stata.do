* THIS IS A SAMPLE STATA FILE
set obs 100
set seed 0912943

gen random_variable = runiform()

summ random_variable, d

disp "Hello from Stata on Rice"
