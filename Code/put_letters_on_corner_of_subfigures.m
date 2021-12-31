function [axn,t] = put_letters_on_corner_of_subfigures(h)
% Input h is a handle of a figure with subfigures
bias = 0.01;
H = h.Position(4); % to make the biases equal in x and y
W = h.Position(3); % to make the biases equal in x and y
letters = 'abcdefghijklmnopqrstuvwxyz';
ax = findobj(h,'type','axes');
axn = axes; % new unvisible axes
set(axn,'Position', [0,0,1,1], 'visible', 'off');

for i=1:length(ax)
%     j=i; % from beginning
    j=length(ax)+1-i; % from end
    pos = ax(j).Position;
    t(i) = text(axn, pos(1)-bias, pos(2)+pos(4)+bias*W/H-0.05 ,letters(i));
    set(t(i),'HorizontalAlignment','right','VerticalAlignment','baseline'...
        ,'Units','normalized','FontWeight','bold','FontSize',24)
end