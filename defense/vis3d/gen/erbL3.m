function [grid] = erbL3 (filename)

% first, create the grid itself
total_time = 10000;
tt = total_time;
gx = 308;
gy = 212;
gz = 102;
grid = create_grid ([gx gy gz], tt);
Qanaltime = 500;
pml_thick = 5;
Siindex = 3.5^2;
SiNindex = 2.0^2;
% put in a cylinder of dielectric constant 4
%[mid0, grid] = new_material (grid, 'simple_dielectric', [1.0]);
%[mid1, grid] = new_material (grid, 'simple_dielectric', [slabindex]);
slab = 12/2;
a = 20;
r = 6;
offset = a/2;
center = [grid.info.xx, grid.info.yy, grid.info.zz]/2;
grid = draw_slab_corner (grid, [1 1 round(grid.info.zz/2)-slab-slab/2], [grid.info.xx grid.info.yy slab*2.0001], Siindex);
grid = draw_slab_corner (grid, [1 1 round(grid.info.zz/2)+slab/2], [grid.info.xx grid.info.yy slab], SiNindex);
count = 0;

p1 = 5;
p2 = 4;
x1 = 6;
x2 = 2;
y1 = 6;
y2 = 0;
di = [1 2 3 0 4	-1 5		0 1 2 3 4 5		-1 0 1 2 3 4]-2 ;
dj = [7 7 7 7 7 7 7		6 6 6 6 6 6		8 8 8 8 8 8]-7;
rd = [0 0 0 p1 p1 x1 x1		y1 y1 y1 y1 y1 y1	y1 y1 y1 y1 y1 y1];
xd = [0 0 0 -p2 p2 -x2 x2	0 0 0 0 0 0		0 0 0 0 0 0];
yd = [0 0 0 0 0 0 0		-y2 -y2 -y2 -y2 -y2 -y2	y2 y2 y2 y2 y2 y2];


fprintf ('cylinders: '); tic
    for i = -20:20
        for j = -20:20;
             centerx = i*a+j*a/2+center(1);
             centery = round(j*sqrt(3)/2*a)+center(2);
            if ((centerx > r+pml_thick+1) && (centerx < gx-r-pml_thick-1) && (centery > r+pml_thick+1) && (centery < gy-r-pml_thick-1))
                count = count + 1;
		% check if the special guy is in the special thing
		cnt = intersect (find (i == di), find (j == dj));
		if (isempty (cnt)) % just a normal cylinder then
			grid = draw_cylinder (grid, [centerx centery round(grid.info.zz/2)], [r slab*2+10], 1.0);
			fprintf ('.');
		else
			grid = draw_cylinder (grid, [centerx+xd(cnt) centery+yd(cnt) round(grid.info.zz/2)], [rd(cnt) slab*2+10], 1.0);
			fprintf (',');
		end
            end
        end
    end

% %dipole X1    
% for i = 1:length(di)
%             centerx = a*di(i)+dj(i)*a/2+center(1);
%             centery = round(dj(i)*sqrt(3)/2*a)+center(2);
%                 count = count + 1;
%                 
% 		grid = draw_slab_corner (grid, [centerx-r centery-r round(grid.info.zz/2)-slab-slab/2], [2*r+1 2*r+1 slab*2], Siindex);
% 		grid = draw_slab_corner (grid, [centerx-r centery-r round(grid.info.zz/2)+slab/2], [2*r+1 2*r+1 slab], SiNindex);
%                 grid = draw_cylinder (grid, [centerx+xd(i) centery+yd(i) round(grid.info.zz/2)], [rd(i) slab*2+10], 1.0);
% 		fprintf ('.');
%     end
% 

%% normal

% grid = draw_slab_corner (grid, [1 1 1],[gx gy  round(grid.info.zz/2-slab-1)], 1.0);
% grid = draw_slab_corner (grid, [1 1 round(grid.info.zz/2+slab+1)],[gx gy gz], 1.0);



%[mid, grid] = new_material(grid, 'current_source', [16.0, .09696, .002, 3]);
% put in the poynting thing


grid = epsilon_average(grid);

% 5 cell pml
toc
fprintf ('pml: '); tic
grid = make_pml (grid, pml_thick,1);
toc
%grid = TE_symmetry_z (grid);

center = round([grid.info.xx, grid.info.yy, grid.info.zz]/2);

[mid, grid] = new_material(grid, 'current_source', [Siindex, .0808 , .001, 3]);
grid.mat{2}(center(1), center(2), center(3)) = mid;


grid = Pradcap(grid,'zcap',center(3)+12,14,0); % 8 = distance from bottom of the grid (works best for TE/TM symmetry), 
% 12 = buffer from grid edge, need some buffer between PML and where to sum the radiated power
% 0 = groupid, all powerradiated with groupID 0 are summed together
grid = Pradcap(grid,'zcenter',[center(3) 24],14,1);
% 'zcap' makes a capper sitting on +z (catches radiation going up and a little sideways)
% 'zbox' makes a box around +-x, +-y (complement of zcap, catches radiation going mainly sideways)
grid = Pradcap(grid,'zcapn',center(3)-12,14,2);


% % set initial values
% for m = 1:5000
%     m
%     grid = set_invals (grid, [ceil(rand()*(gx-1)), ceil(rand()*(gy-1)), ceil(rand()*(gz-1))], 1, 6);
% end
% grid = set_invals (grid, [20, 20, 20], 1, 6);


grid = define_output (grid, 'point', center, [-1]);
grid = define_output (grid, 'slice', center(3), [grid.info.tt-100:2:grid.info.tt]);
grid = define_output (grid, 'slice', center(3), round([1:grid.info.tt/50:grid.info.tt]));
grid = define_anals (grid, Qanaltime, 3);
%grid = define_output (grid, 'analytic', [2 0 0], [(grid.info.tt-Qanaltime):grid.info.tt]); % here the [-1] for the position means global energy
%grid = define_output (grid, 'analytic', [3 0 0], [(grid.info.tt-Qanaltime):grid.info.tt]); % here the [-1] for the position means global energy
%grid = define_output (grid, 'analytic', [4 0 0], [(grid.info.tt-Qanaltime):grid.info.tt]); % here the [-1] for the position means global energy

%rid = simulate_it (grid,1);

hdf_export(filename, grid); % '_x' num2str(rd(7)) num2str(xd(7)) num2str(yd(7)) '.h5'],grid)

