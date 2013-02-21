function vis_3D_epsilon(A, mat_index, skim, alpha)
    s = skim+1;
    dims = size (A);
    A = A(:,dims(2):-1:1,:);
    A([1:s, dims(1)-(s+1):dims(1)],:,:) = 0;
    A(:,[1:s, dims(2)-(s+1):dims(2)],:) = 0;

    order = [2 1 3];
    v = permute (A, order);
    dims = size (v);
    [x y z] = meshgrid (1:dims(2), 1:dims(1), 1:dims(3));

    hpatch = patch(isosurface(x,y,z,v, mat_index));
    isonormals(x,y,z,v,hpatch)
    set(hpatch,'FaceAlpha', alpha, 'FaceColor',120*[1 1 1]./255,'EdgeColor','none')

    my_make_pretty(dims, alpha);

function my_make_pretty (dims, alpha)

    grid on
    daspect([1,1,1])
    axis tight
    if alpha == 1 % If alpha not equal to 1, don't add lighting
        camlight left; lighting phong
    end
    % make it more visually intuitive
    axis tight
    axis ([0 dims(2) 0 dims(1) 0 dims(3)]);
    H = gcf; % get the current figure handle
    % set (H, 'WindowStyle', 'normal', 'OuterPosition', [100 100 640 480] + [0 0 10 29], 'MenuBar', 'none', 'ToolBar', 'none'); % set the location and size of the window
    set (H, 'WindowStyle', 'docked');
    view(0, 45);
    grid off;
    set(gca, 'XTick', [], 'YTick', [], 'ZTick', [], 'Visible', 'off')


