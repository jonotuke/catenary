function [L_max, L_min, c_1, c_2, lambda] = catenary_max_length(y_0, y_1, x_0, x_1)
%
% file:         catenary_max_length.m, (c) 2012 Matthew Roughan
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
%
% CATENARY_SOLVER: calculate the maximum (and min) length of a hangling chain before it dangles on the
%                  ground (is drawn taught), where it takes catenary shape
%                y = c_1*cosh((x-c_2)/c_1) - c_1
%         with fixed length
%                L = c_1.*( sinh((x_1-c_2)./c_1) - sinh((x_0-c_2)./c_1) );
%         but we need to work out the constants of integration c_1, c_2 and lambda
%
% INPUTS:
%         y_0       = height of the left pylon
%         y_1       = height of the right pylon
%         x_0       = left pylon position
%         x_1       = right pylon position
%         
% OUTPUTS:        
%         L_max     = the maximum length of the chain
%         L_min     = the infimum length of the chain
%         c_1,c_2,lambda = parameters of maximal catenary
%         
%         
%         
%
L_min =  sqrt( (x_1 - x_0).^2 + (y_1 - y_0).^2 );

% create a function which we will minimize to find the solution
%   g1 is the left end-point constraint
%   g2 is the right end-point constraint
%   a = [c_1, c_2], lambda = c_1
g1 = @(a) ( y_0 - a(1)*cosh( (x_0 - a(2))/a(1) ) + a(1) ).^2;
g2 = @(a) ( y_1 - a(1)*cosh( (x_1 - a(2))/a(1) ) + a(1) ).^2;
g = @(a) g1(a) + g2(a);
a_est = [100, (x_0+x_1)/2];
options = optimset('fminsearch');
options = optimset(options, 'MaxFunEvals', 100000, 'MaxIter', 1000);
[a, fval, exitflag, output] = fminsearch(g, a_est, options);
c_1 = a(1); % must be > 0
c_2 = a(2); % must be between x_0 and x_1 for the maximum
lambda = -c_1; % for the maximum

g_val = [g1(a), g2(a)];

% compute the maximum length
L_max = c_1.*( sinh((x_1-c_2)./c_1) - sinh((x_0-c_2)./c_1) );
