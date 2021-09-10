function x2 = ces_indiff(u,x1,r)
x2 = (u.^r - x1.^r).^(1/r);
