% test out the catenary solver


clear;
delta = 0.01;
n = 1000;

y_0s = [1 2 1.1 5 10];
y_1s = [3 2 2 1.3 1.3];
x_0s = [0 0 -3 0 0];
x_1s = [1 1 1 1 1];
Ls = [2.9 1.4 4.4 4.4 8.7574];

for i=1:length(Ls)
% for i=2:3
  y_0 = y_0s(i);
  y_1 = y_1s(i);
  x_0 = x_0s(i);
  x_1 = x_1s(i);
  L = Ls(i);
  
  % compute bounds
  [L_max, L_min, c1_max, c2_max, lambda_max] = catenary_max_length(y_0, y_1, x_0, x_1);

  % compute catenary with a given length
  [x, y, c_1, c_2, lambda, Lest, F_est, Lest_check, F_est_check, ...
   f_val, exitflag, output] = catenary_new_a(y_0, y_1, x_0, x_1, L);
  y_max = c1_max*cosh((x-c2_max)/c1_max) + lambda_max;

  figure(i)
  hold off
  plot(0,0);
  hold on
  plot([x_0 x_0], [0 y_0], 'k-', 'linewidth', 3);
  plot([x_1 x_1], [0 y_1], 'k-', 'linewidth', 3);
  p1 = plot(x, y, 'b-', 'linewidth', 3);
  p2 = plot(x, y_max, 'r-', 'linewidth', 3);
  axis equal
  set(gca, 'ylim', [0 1.1*max(y_1,y_0)]);
  set(gca, 'xlim', [x_0-0.1 x_1+0.1]);

  % compute catenary with a given length
  [x, y, c_1, c_2, lambda, Lestb, F_est, Lest_check, F_est_check, ...
   f_val, exitflag, output] = catenary_new_b(y_0, y_1, x_0, x_1, L);
  figure(i)
  p3 = plot(x, y, 'g--', 'linewidth', 3);

  
end
