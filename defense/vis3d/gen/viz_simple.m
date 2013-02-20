% simple view of epsilons
function [] = viz_simple (grid, z, c)

titletext = {'\epsilon_x', '\epsilon_y', '\epsilon_z'};
for cnt = 1 : length (z)
	for i = 1 : 3
		subplot (1, 3, i);
		imagesc (grid.epsilon{i}(:,:,z(cnt))', c);
		title ([titletext{i} ' (' num2str(z(cnt)) ')']);
		axis equal tight
	end
	pause
end
