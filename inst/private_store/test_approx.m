%
% test_approx.m, (c) Matthew Roughan, 2013
%
% created: 	Wed Feb  6 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% TEST_APPROX 
%    test the parabolic approximation to the catenary
%         
%
%
clear
figure(1);
hold off
plot(0,0);
hold on

x = -1:0.01:1;

a = 0.4;
b = -0.6;
c = 2;
y1 = a*x.^2 + b*x + c;
figure(1)
plot(x, y1);
	     
c_2 = -b/(2*a);
c_1 = sign(a)/sqrt(a);
lambda = c - b^2/(4*a) - c_1;

y2 = c_1 * cosh((x-c_2)/c_1) + lambda;
figure(1)
plot(x, y2, 'r');


