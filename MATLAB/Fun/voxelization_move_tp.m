function [voxels_tp_logical_out,voxels_logical_out] = voxelization_move_tp(voxels_tp_logical,voxels_logical,voxels_all_logical)
%
% voxels_logical=voxels.logical;
% voxels_tp_logical=voxels_tp.logical;
% voxels_all_logical=voxels_all.logical;
voxels_tp_logical_out=voxels_tp_logical;
voxels_logical_out=voxels_all_logical;

voxels_tp_logical_out(:,:,:)=0;
[bw_voxels_tp_label,n]=bwlabeln(voxels_tp_logical); %三维体素聚类
stats = regionprops(bw_voxels_tp_label, 'Centroid');
% find(bw_voxels_tp_label==5)
% 提取每个聚类的几何中心坐标
centroids = cat(1, stats.Centroid);
% 天安门X和Z的标准差最小，说明孔洞沿着Y轴分布
move_steps=4;

% find(bw_voxels_tp_label(:,:,:)==1)


for i=1:size(bw_voxels_tp_label,1)
    for j=1:size(bw_voxels_tp_label,2)
        for k=1:size(bw_voxels_tp_label,3)

%             if(bw_voxels_tp_label(i,j,k)==0)
%                 voxels_tp_logical_out(i,j,k)=0;
%             end

            if(bw_voxels_tp_label(i,j,k)==1)
                voxels_tp_logical_out(i-move_steps*2,j,k)=1;
            end

            if(bw_voxels_tp_label(i,j,k)==2)
                voxels_tp_logical_out(i - move_steps,j,k)=1;
            end

            if(bw_voxels_tp_label(i,j,k)==3)
                voxels_tp_logical_out(i,j,k)=1;
            end

            if(bw_voxels_tp_label(i,j,k)==4)
                voxels_tp_logical_out(i + move_steps,j,k)=1;
            end

            if(bw_voxels_tp_label(i,j,k)==5)
                voxels_tp_logical_out(i + move_steps*2,j,k)=1;
            end


        end
    end
end
% voxels_tp_logical_out(:,:,3)
 voxels_logical_out(voxels_tp_logical_out==1)=0;
