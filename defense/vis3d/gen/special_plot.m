function [m] = plot_slice_movie (slice, delay, rescale_factor, epsilon, eps_alpha)
log_on = 0;
skip = 1;
skim = 0;
moviename = 'none';
dims = size (slice);
slice = slice (skim+1:dims(1)-skim, skim+1:dims(2)-skim, :);

% alpha_data
adata = (epsilon-1) ./ max(max(epsilon));

fig = figure;
if (strcmp (moviename, 'none') == 0)
	set (fig, 'DoubleBuffer', 'on');
       % set(gca,'xlim',[-80 80],'ylim',[-80 80],'NextPlot','replace','Visible','off')
       % set(gca,'NextPlot','replace','Visible','off')
	%mov=avifile (moviename,'fps',15,'quality',100, 'compression', 'none');
	movie = 1;
else
	movie = 0;
end
close all
d = size (slice);
% slice=reshape(slice, [d(3) d(2) d(1)]);
tmax=length(slice(1,1,:));
if log_on==1
    cmax=20*log10(max(max(max(abs(slice)))));
    if (cmax == Inf || cmax == NaN)
    	cmax = 100;
	cmax
    end
    cmax
    % cmax = 100;
    cmin=-200;
else
    cmax=max(max(max(abs(slice))))/rescale_factor;
    cmin=-cmax;
end

caxis([cmin cmax]);
% colorbar
axis([1 length(slice(1,:,1))-1 1 length(slice(:,1,1))]);
hold on
cnt = 0;
for t = 1 : skip : tmax
    cla
    cnt = cnt + 1;
    if log_on==1
        h = imagesc (20*log10(abs(slice(:,:,t)')));
    else
        % h = imagesc (slice(:,:,t)');
	% h = imagesc (slice(:,:,t)', 'AlphaData', (1-eps_alpha) + eps_alpha*(adata'));
	h = imagesc (slice(:,:,t)', 'AlphaData', eps_alpha + (1-eps_alpha)*(adata'));
    end
    axis equal
    axis tight
set (gcf, 'WindowStyle', 'docked');
	if (movie == 1)
	% set (h, 'EraseMode', 'xor');
    m(t)=getframe;
    % mov=addframe(mov,F);
    end
    pause(delay);
end
return
%if (movie == 1)
%mov=close(mov);
%end
