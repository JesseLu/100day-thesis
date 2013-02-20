% [grid] = Pradcap (grid, direction, distance, buffer, gid)
% direction - zcap, zcapn, zbox, zcenter
% distance - distance from bottom to set cut off for zcap,box
% buffer - buffer from PML, should be > PML _thick+2
% gid - aanlytics with same gid are summed together
%
function [grid] = Pradcap(grid,direction,distance,buffer,gid)
dims = [grid.info.xx grid.info.yy grid.info.zz];

if (strcmp(direction, 'zcap'))
	ps = [buffer buffer dims(3)-buffer; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+z',gid);
	ps = [buffer buffer distance; dims(1)-buffer buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'-y',gid);
	ps = [buffer dims(2)-buffer distance; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+y',gid);
	ps = [buffer buffer distance; buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'-x',gid);
	ps = [dims(1)-buffer buffer distance; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+x',gid);
elseif(strcmp(direction, 'zcapn'))
	ps = [buffer buffer buffer; dims(1)-buffer dims(2)-buffer buffer];
	grid = Pradplane(grid,ps,'-z',gid);
	ps = [buffer buffer buffer; dims(1)-buffer buffer distance];
	grid = Pradplane(grid,ps,'-y',gid);
	ps = [buffer dims(2)-buffer buffer; dims(1)-buffer dims(2)-buffer distance];
	grid = Pradplane(grid,ps,'+y',gid);
	ps = [buffer buffer buffer; buffer dims(2)-buffer distance];
	grid = Pradplane(grid,ps,'-x',gid);
	ps = [dims(1)-buffer buffer buffer; dims(1)-buffer dims(2)-buffer distance];
	grid = Pradplane(grid,ps,'+x',gid);
elseif (strcmp (direction, 'zbox'))
	ps = [buffer buffer 1; dims(1)-buffer buffer distance];
        grid = Pradplane(grid,ps,'-y',gid);
        ps = [buffer dims(2)-buffer 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+y',gid);
        ps = [buffer buffer 1; buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'-x',gid);
        ps = [dims(1)-buffer buffer 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+x',gid);

elseif (strcmp (direction, 'ysides'))
	ps = [buffer buffer 1; dims(1)-buffer buffer distance];
        grid = Pradplane(grid,ps,'-y',gid);
        ps = [buffer dims(2)-buffer 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+y',gid);
elseif (strcmp (direction, 'xsides'))
        ps = [buffer buffer 1; buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'-x',gid);
        ps = [dims(1)-buffer buffer 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+x',gid);
elseif (strcmp (direction, '+x8'))
        ps = [dims(1)-buffer 1 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+x',gid);
elseif (strcmp (direction, '-x'))
        ps = [buffer buffer 1; buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'-x',gid);
elseif (strcmp (direction, '-y'))
	ps = [buffer buffer 1; dims(1)-buffer buffer distance];
        grid = Pradplane(grid,ps,'-y',gid);
elseif (strcmp (direction, '+y8'))
        ps = [1 dims(2)-buffer 1; dims(1)-buffer dims(2)-buffer distance];
        grid = Pradplane(grid,ps,'+y',gid);
elseif (strcmp(direction, 'zcap8'))
	ps = [buffer buffer dims(3)-buffer; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+z',gid);
	ps = [buffer dims(2)-buffer distance; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+y',gid);
	ps = [dims(1)-buffer buffer distance; dims(1)-buffer dims(2)-buffer dims(3)-buffer];
	grid = Pradplane(grid,ps,'+x',gid);

elseif (strcmp (direction, 'zcenter'))
	c1 = distance(1);
	distance = round(distance(2)/2);
	ps = [buffer buffer c1-distance; dims(1)-buffer buffer c1+distance];
        grid = Pradplane(grid,ps,'-y',gid);
        ps = [buffer dims(2)-buffer c1-distance; dims(1)-buffer dims(2)-buffer c1+distance];
        grid = Pradplane(grid,ps,'+y',gid);
        ps = [buffer buffer c1-distance; buffer dims(2)-buffer c1+distance];
        grid = Pradplane(grid,ps,'-x',gid);
        ps = [dims(1)-buffer buffer c1-distance; dims(1)-buffer dims(2)-buffer c1+distance];
        grid = Pradplane(grid,ps,'+x',gid);

else
	error ('invalid special feature');
end

