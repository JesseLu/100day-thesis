function visall3D(vis_dir)
    d = dir(vis_dir);
    names = {};
    for i = 1 : length(d)
        if d(i).isdir & ~isempty(find(d(i).name ~= '.')) & ...
                    isempty(strfind(d(i).name, '2D')) & ...
                    ~isempty(strfind(d(i).name, 'verify'))
            names{end+1} = d(i).name;
        end
    end

    for i = 1 : length(names)
        try
            data = load([vis_dir, names{i}, filesep, 'epsz.mat']);
            epsilon = data.eps_z;
            close all
            vis_3D_epsilon(epsilon, 7.25, 0, 1)
%             if ~isempty(strfind(names{i}, 'fib')) % Need to draw fiber.
%                 epsilon(:,:,1:41) = 2.25;
%                 vis_3D_epsilon(epsilon, 2.45, 0, 1);
%             end
            print('-dpng', '-r200', [vis_dir, names{i}, filesep, '3D']);
        end
    end
    
