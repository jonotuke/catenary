%
% ctesiphon.m, (c) Matthew Roughan, 2012
%
% created: 	Fri Oct 19 2012 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% Fit a catenary to the vault of cetisphon
%    do fits to the intrados and extrados by changing the 'edge' variable
%

clear;
colors = [[1 0 0];
	  [1 0.5 0];
	  [1 1 0];
	  [0 1 0];
	  [0 1 1];
	  [0 0 1];
	  [0 0.5 0.5];
	  [0.5 0 0.5];
	 ];
device = '-depsc';
suffix = 'eps';
seed = 1;
set(0,'DefaultTextFontsize', 18); % not working
set(0,'DefaultAxesFontsize', 18); % not working
set(0,'DefaultLineLinewidth', 2);
plotdir = './Plots';


% read a set of coordinates for a file

% display an image
FileName = 'ctesiphon.jpg';
PathName = 'Pics/';
filename = fullfile(PathName, FileName);
[A, map] = imread(filename);
figure(1);
hold off
image(A);
hold on
axis image
colormap('gray')

% read in the data
edge = 'intrados';
% edge = 'extrados';
arch_file = ['Data/', regexprep(FileName, '\..*', sprintf('.%s.dat', edge))]
[x_arch, y_arch, b_arch] = textread(arch_file, '%f %f %f', 'commentstyle', 'shell');

region_file = ['Data/', regexprep(FileName, '\..*', '.region.dat')]
[x_region, y_region] = textread(region_file, '%f %f', 'commentstyle', 'shell');

% plot on the figure
figure(1)
plot(x_arch(1:end), y_arch(1:end), 'co', 'markersize', 10);
set(gca, 'xlim', x_region);
set(gca, 'ylim', y_region);
set(gca, 'fontsize', 12, 'linewidth', 2);


% transform to a set of normalized coordinates
max_x = max(x_arch);
min_x = min(x_arch);
max_y = max(y_arch);
min_y = min(y_arch);
Dx = max_x - min_x;
Dy = max_y - min_y;
x_c = 2*(x_arch-min_x)/Dx - 1
y_c = 2*(y_arch-min_y)/Dx

m = 2;
x_c = [x_c(1)*ones(m,1); x_c; x_c(1)*ones(m,1)];
y_c = [y_c(1)*ones(m,1); y_c; y_c(1)*ones(m,1)];

figure(3)
hold off
plot(x_c, y_c, 'bo');
x = -2:0.01:2;
hold on

%
% fit the curves 
%

% hemisphere
figure(3)
g = @(a) sum( (a(1) - sqrt(abs(a(2)^2 - (x_c(4:end)+a(3)).^2))  - y_c(4:end) ).^2 );

options = optimset('fminsearch');
options = optimset(options, 'MaxFunEvals', 100000);
a_est = [1, 1.2, 0.2];
[a, fval, exitflag, output] = fminsearch(g, a_est, options);
y_sphere = a(1) - sqrt(a(2)^2 - (x+a(3)).^2);
plot(x, y_sphere, 'm');
f_val_sphere = fval

x_arch4 = Dx*(x+1)/2 + min_x;
y_arch4 = Dx*(y_sphere)/2 + min_y;
figure(1)
p1 = plot(x_arch4, y_arch4, 'b--', 'linewidth', 2);



% catenary
g = @(a) sum( (a(1)*cosh(x_c/a(1)) - a(2)  - y_c ).^2 );

options = optimset('fminsearch');
options = optimset(options, 'MaxFunEvals', 100000, 'MaxIter', 10000);
a_est = [1, 0];
[a, fval, exitflag, output] = fminsearch(g, a_est, options);
y_cat = a(1)*cosh(x/a(1)) - a(2);
figure(3)
plot(x, y_cat, '--', 'color', 'r');
f_val_cat = fval

set(gca,'ylim', [-0.2 1.6]);


x_arch5 = Dx*(x+1)/2 + min_x;
y_arch5 = Dx*(y_cat)/2 + min_y;
figure(1)
p4 = plot(x_arch5, y_arch5, '--', 'color', 'r');



% quadratic approximation
g = @(a) sum( ( a(1) + a(2)*x_c + a(3)*x_c.^2 - y_c ).^2 );
options = optimset('fminsearch');
options = optimset(options, 'MaxFunEvals', 100000);
a_est = [1, 1, 1];
[a, fval, exitflag, output] = fminsearch(g, a_est, options);
plot(x, a(1) + a(2)*x + a(3)*x.^2, 'g');

x_arch6 = Dx*(x+1)/2 + min_x;
y_arch6 = Dx*(a(1) + a(2)*x + a(3)*x.^2)/2 + min_y;
figure(1)
p6 = plot(x_arch6, y_arch6, 'g--');
f_val_quadratic = fval



figure(1)
legend([p1 p6 p4], 'semicircle', 'quadratic', 'catenary', ...
       'location', 'northeast');
filename = sprintf('%s/%s_%d.%s', plotdir, FileName, i, suffix);
print(device,filename);

figure(3)
set(gca,'ylim', [-0.2 1.6]);



fprintf(' RMS error in semicircle fit = %.4f\n', sqrt(f_val_sphere));
fprintf(' RMS error in quadratic fit  = %.4f\n', sqrt(f_val_quadratic));
fprintf(' RMS error in catenary fit   = %.4f\n', sqrt(f_val_cat));
