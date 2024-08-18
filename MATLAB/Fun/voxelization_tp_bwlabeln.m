function [voxels_tp,voxels] = voxelization_tp_bwlabeln(voxels_tp_in,voxels_in,nn)
% nn为计算体素分辨率给的n
% nn=3;
% voxels_tp_in=voxels_tp.logical;
% voxels_in=voxels.logical;
voxels_tp=voxels_tp_in;

voxels=voxels_in;

voxels_tp(:)=0;
[bw_voxels_tp_label,n]=bwlabeln(voxels_tp_in); %三维体素聚类

for i=1:n
    this_label=bw_voxels_tp_label; 
    this_label(this_label~=i)=0; %找到当前类的所有体素单元
    

    % 使用 bwconncomp 获取连通区域
    connComp = bwconncomp(this_label);

    % 获取每个连通区域的外包框
    stats = regionprops(connComp, 'BoundingBox');

%     [row, col, depth] = ind2sub(size(this_label), find(this_label == i));
%     minRow = min(row);
%     maxRow = max(row);
%     minCol = min(col);
%     maxCol = max(col);
%     minDepth = min(depth);
%     maxDepth = max(depth);

    if((stats.BoundingBox(4))<nn||(stats.BoundingBox(5))<nn||(stats.BoundingBox(6))<nn) %某一方向分辨率小于设置最小拓扑体素长度

%     if((maxRow-minRow)<nn||(maxCol-minCol)<nn||(maxDepth-minDepth)<nn) %某一方向分辨率小于设置最小拓扑体素长度
    voxels(this_label==i)=1;
    else
    this_label(this_label==i)=1;
    voxels_tp=voxels_tp+this_label;
    end

end



end
