function [x, y, c_1, c_2, lambda, Lest, Fest, Lest_check, Fest_check, ...
	  f_val, exitflag, output] = catenary_new_b(y_0, y_1, x_0, x_1, L)
%
% file:      	catenary_solver_gen.m, (c) 2012 Matthew Roughan
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
%
% CATENARY_SOLVER: solves the shape of a hanging chain, which we know will be
%                y = c_1*cosh((x-c_2)/c_1) + lambda
%         with fixed length
%                L = c_1.*( sinh((x_1-c_2)./c_1) - sinh((x_0-c_2)./c_1) );
%         but we need to work out the constants of integration c_1, c2 and lambda
%
% INPUTS:
%         y_0       = height of the left pylon (must be > 0)
%         y_1       = height of the right pylon (must be > 0)
%         x_0       = left pylon position
%         x_1       = right pylon position
%         L         = length of chain
%         
% OUTPUTS:        
%         [x, y]    = n (x,y) points along the shape of the catenary
%         c_1,c2     = constants of integration
%         lambda    = Lagrange multiplier
%         Lest      = estimated length, to be used in debugging
%         Fest      = an estimate of the functional which gives the potential energy of the chain
%         Lest_check = a check based on estimated (x,y) positions (only valid for large n)
%         Fest_check = a check based on estimated (x,y) positions (only valid for large n)
%         [f_val, exitflag, output] = output from the optimization used to find the solution
%

if (y_0 < 0)
  error('y_0 must be >= 0');
end

if (y_1 < 0)
  error('y_1 must be >= 0');
end

if (x_1 <= x_0)
  error('x_1 should be > x_0');
end

% check the length is possible
[L_max, L_min, c_1_max, c2_max, lambda_max] = catenary_max_length(y_0, y_1, x_0, x_1);
if (L <= L_min)
  error('L <= L_min, so we cannot have a valid catenary.');
end
if (L > L_max)
  error('L > L_max, so we cannot have a valid catenary.');
end


theta = atanh( (y_1 - y_0) / L );
k = sqrt( L^2 - (y_1 - y_0)^2 ) / (x_1 - x_0);
g = @(a) ( sinh(a) - k*a );
a_est = 100;
% options = optimset('fminsearch');
% options = optimset(options, 'MaxFunEvals', 100000);
% [a, fval, exitflag, output] = fminsearch(g, a_est, options);
phi0 = acosh(k);
phi1 = sqrt(6*(k-1));
[phi, fval, exitflag] = fzero(g,phi1); 
f_val = g(phi);
output = '';

% figure(100)
% hold off
% plot(0,0)
% X = 0:0.1:5;
% hold on
% plot(X, k*X);
% plot(X, sinh(X), 'r');
% plot(X, X + X.^3/6, 'g');
% plot(phi0, sinh(phi0), 'kx')

c_1 = (x_1 - x_0) / (2*phi);
c_2 = 0.5*(x_1 + x_0 - theta*(x_1 - x_0)/phi);
lambda_1 = y_1  - c_1*cosh((x_1-c_2)/c_1) ;
lambda_0 = y_0  - c_1*cosh((x_0-c_2)/c_1) ;
% the two lambdas should be the same

lambda = lambda_1;


% calculate the length to check it is valid
Lest = c_1.*( sinh((x_1-c_2)./c_1) - sinh((x_0-c_2)./c_1) );
if (abs(Lest-L)/L > 0.01)
  L
  Lest
  c_1
  c_2
  error('Lest was invalid');
end

%
% now calculate points on the curve
%
n = 1000;
x = x_0:(x_1 - x_0)/n:x_1;
y = c_1*cosh((x-c_2)/c_1) + lambda;

% second check of the length
Lest_check = sum(sqrt(diff(x).^2 + diff(y).^2));
if (abs(Lest_check-L)/L > 0.01)
  error('Lest was invalid');
end

% calculate the potential a few different ways to compare
Fest_1 =  sum(y(1:end-1).*sqrt(diff(x).^2 + diff(y).^2));
Fest_2 =  c_1*(x_1 - x_0)/2 + ...
	  c_1^2*(sinh(2*(x_1 - c_2)/c_1)-sinh(2*(x_0 - c_2)/c_1))/4 - ...
	  lambda*Lest;

Fest = Fest_2;
Fest_check = Fest_1;
  