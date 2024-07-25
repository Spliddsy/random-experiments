% StarfieldMapper
% Here's just a simple little project I made on the road. It takes
% information about nearby stars and plots it in a 3 different 2D
% cross-sections. This is in it's own separate folder because you
% need an Excel document ("Starfield.xlsx") to store data on the
% nearby stars.
%
% JRW, 7/25/2024

clear;
clc;
fprintf('Program start...');

num_stars = 10;
border_width = 25;
style_sol = '^';
style_pt = '+';
style_outerln = '-';
style_innerln = '--';
size_sol = 250;
size_pt  = 100;
size_ln  = 1;
size_border = 1;
length_outer = 5;
length_inner = 1;

for count = 1:3
    if count == 1
        coord1 = 1;
        coord1name = 'X';
        coord2 = 2;
        coord2name = 'Y';
    elseif count == 2
        coord1 = 1;
        coord1name = 'X';
        coord2 = 3;
        coord2name = 'Z';
    else
        coord1 = 2;
        coord1name = 'Y';
        coord2 = 3;
        coord2name = 'Z';
    end

pos = readmatrix('Starfield.xlsx', 'Range', 'M2:O100');
x = pos(:,coord1);
y = pos(:,coord2);

stars = 1;
inc = 0;
dist = sqrt( x.^2 + y.^2 );
while stars < num_stars
    inc = inc + 1;
    if dist(inc) < length_inner
        dist(inc) = NaN;
        x(inc) = NaN;
        y(inc) = NaN;
    else
        stars = stars + 1;
    end
end
x = rmmissing(x(1:inc));
y = rmmissing(y(1:inc));
dist = rmmissing(dist(1:inc));

figure(count);
hold on;
scatter(x, y, size_pt, style_pt, 'k');
scatter(0, 0, size_sol, style_sol, 'k');
title(sprintf('%c-%c Plane, %d Total Stars',coord1name,coord2name,length(x)+1));
axis equal;
axis off;
circle(0,0,length_inner,size_ln);
circle(0,0,length_outer,size_ln);
for k = 1:1:length(x)
    x_inner_start = length_inner * x(k) / dist(k);
    y_inner_start = length_inner * y(k) / dist(k);

    if dist(k) > length_outer
        x_outer_start = length_outer * x(k) / dist(k);
        y_outer_start = length_outer * y(k) / dist(k);

        line([x_outer_start x(k)], [y_outer_start y(k)], 'linewidth', size_ln, 'color', 'k', 'linestyle', style_outerln);
        line([x_outer_start x_inner_start], [y_outer_start y_inner_start], 'linewidth', size_ln, 'color', 'k', 'linestyle', style_innerln);
    else
        line([x(k) x_inner_start], [y(k) y_inner_start], 'linewidth', size_ln, 'color', 'k', 'linestyle', style_innerln);
    end
end
hold off;

pbaspect([1 1 1])
line([-border_width/2 border_width/2], [border_width/2 border_width/2], 'linewidth', size_border, 'color', 'k', 'linestyle', '-');
line([-border_width/2 border_width/2], [-border_width/2 -border_width/2], 'linewidth', size_border, 'color', 'k', 'linestyle', '-');
line([border_width/2 border_width/2], [-border_width/2 border_width/2], 'linewidth', size_border, 'color', 'k', 'linestyle', '-');
line([-border_width/2 -border_width/2], [-border_width/2 border_width/2], 'linewidth', size_border, 'color', 'k', 'linestyle', '-');

saveas(figure(count), sprintf('Figure%d.png',count));
fprintf('.');

end

fprintf('\nProgram complete \n');

function circle(x,y,r,width)
%PLOT_CIRCLE draws a circle at a certain (x,y) position with a radius and
%line width.
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
plot(xunit,yunit,'k','linewidth',width);
end
