function fib = fibo_recursion(n)
 
if n <= 2
    fib = 1;
else    
    fib = fibo_recursion(n-1) + ...
			 fibo_recursion(n-2);
end
