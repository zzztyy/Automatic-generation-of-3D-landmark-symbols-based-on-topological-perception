function [voxels_out,voxels_tp_out]=Topological_exaggeration_voxelsmodel(voxels,voxels_tp,ex_size)
% Topological exaggeration
% input 
%   voxels:Three dimensional logic matrix represents voxels (m*n*l,logical/double)
%   voxels_tp:Three dimensional logic matrix represents voxels (m*n*l,logical/double)
%   ex_size:Number of neighborhood expansions(1*1,uint8/int16 nonnegative)
% output
%   voxels_out:Three dimensional logic matrix represents voxels (m*n*l,logical/double)
%   voxels_tp_out:Three dimensional logic matrix represents voxels (m*n*l,logical/double)

voxels_tp_out=voxels_tp;
voxels_out=voxels;
%
se = strel('sphere',ex_size );
voxels_tp_out.logical = imdilate(voxels_tp.logical, se);
% voxels_tp_out_count.logical=~voxels_tp_out.logical;

voxels_out.logical=voxels_out.logical-voxels_tp_out.logical;
voxels_out.logical(voxels_out.logical==-1)=0;


% voxels_tp_out.logical(voxels_tp_out.logical==1)=2;
% voxels_tp_out.logical(voxels_tp_out.logical==0)=1;
% voxels_tp_out.logical(voxels_tp_out.logical==2)=0;

% aa=voxels_out.logical+voxels_tp_out.logical;
% aa(:,:,41)
% a=voxels_tp_out.logical(:,:,41)
% b=voxels_tp.logical(:,:,41)


% for i=1:size(voxels_tp.logical,3)
%     %对每一层进行计算
%     this_face=voxels_tp.logical(:,:,i);
% 
%     % 使用imdilate进行外扩一层
%     result_dilated = imdilate(this_face, strel('disk', ex_size)); % 使用r3的圆形结构元素进行膨胀
%     voxels_tp_out.logical(:,:,i)=result_dilated;
% 
%     result_dilated(result_dilated==1)=2;
%     result_dilated(result_dilated==0)=1;
%     result_dilated(result_dilated==2)=0;
%     aa=voxels_out.logical(:,:,i)+result_dilated;
%     aa(aa==1)=0;
%     voxels_out.logical(:,:,i)=aa;
% 
% 
% end
% voxels_out.logical(voxels_out.logical==2)=1;
% this_face=[];


end