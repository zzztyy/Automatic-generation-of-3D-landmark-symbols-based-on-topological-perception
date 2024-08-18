function draw_fv_patch(varargin)

if nargin == 3
    patch(varargin{1},'FaceColor',varargin{2},'EdgeColor',varargin{3},'LineWidth', 0.001);
    axis equal;
     axis off
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(-30, 30);
    title("原始包络")
    

elseif nargin == 4
    % 实现输入两个参数的操作
   axis off
    patch('Vertices', varargin{1}, 'Faces',varargin{2}, 'FaceColor', varargin{3}, 'FaceAlpha', 0.7, 'EdgeColor', varargin{4},'LineWidth', 0.001);
    axis equal;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    view(-30, 30);

else
    error('Invalid number of input arguments.');

end

end