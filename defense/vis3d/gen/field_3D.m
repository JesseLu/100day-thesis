% plot the fields in 3D in a pretty way
function [] = field_3D (epsilon, field, params, T, eps_alpha)
close all
field = field{1}.^2 + field{2}.^2 + field{3}.^2;
dims = my_plot_epsilon (epsilon, 6, 0, eps_alpha);
% my_plot_field (abs (field), [2, 10, 1, 1.8, 1e-5], 0);
my_plot_field (abs (field), params, 0);
my_make_pretty (dims);
view (T);


function [dims] = my_plot_epsilon (A, mat_index, skim, alpha)
s = skim+1;
dims = size (A);
A = A (s:dims(1)-(s+1), s:dims(2)-(s+1), s:dims(3)-(s+1));

order = [2 1 3];
v = permute (A, order);
dims = size (v);
[x y z] = meshgrid (1:dims(2), 1:dims(1), 1:dims(3));

hpatch = patch(isosurface(x,y,z,v, mat_index));
isonormals(x,y,z,v,hpatch)
set(hpatch,'FaceAlpha', alpha, 'FaceColor',120*[1 1 1]./255,'EdgeColor','none')



function [] = my_plot_field (A, params, skim)

if (params(3) <= 0) % fully transparent, don't plot anything
	return
end
% get the colormap
cmap = colormap ('winter');
% cmap = cmap (24:64,:); % leave out dark colors
cmap = cmap(54:-1:10,:);
cmap = cmap (size (cmap,1):-1:1, :);

% format the values matrix
A = squeeze(A);
dims = size(A);
s = skim+1;
A = A (s:dims(1)-(s+1), s:dims(2)-(s+1), s:dims(3)-(s+1));

% set the colors and transparencies for different layers
index = params(2) * params(3).^ (-params(1):0)
alpha_index = params (4) * params(5) .^ (-params(1):0);

order = [2 1 3];
v = permute (A, order);
dims = size (v);
[x y z] = meshgrid (1:dims(2), 1:dims(1), 1:dims(3));

for cnt = 1 : length (index)
	hpatch = patch(isosurface(x,y,z,v, index (cnt)));
	isonormals(x,y,z,v,hpatch)
	set(hpatch,'FaceAlpha', alpha_index(cnt), 'FaceColor',cmap (round( ((cnt-1)/(length(index)-1)) * (size (cmap,1)-1) +1),:),'EdgeColor','none')
end


function [] = my_make_pretty (dims)
grid on
daspect([1,1,1])
axis tight
camlight left; lighting phong
% make it more visually intuitive
axis tight
axis ([0 dims(2) 0 dims(1) 0 dims(3)]);
H = gcf; % get the current figure handle
% set (H, 'WindowStyle', 'normal', 'OuterPosition', [100 100 640 480] + [0 0 10 29], 'MenuBar', 'none', 'ToolBar', 'none'); % set the location and size of the window
set (H, 'WindowStyle', 'docked');


