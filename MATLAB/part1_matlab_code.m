%% Automatic generation of 3D landmark symbols based on topological perception matlab code
% author:Yuan Ding, DongMing Chen,FuMing Jin,XinYu Huang
% e-mail:dingyuanhhu@hhu.edu.cn
% illustrate:Run the code in sections to output images and save the mesh
% Please note that drawing may be slower. Please comment out the drawing code as needed
%% 1.Calculate resolution and voxelization
clear
clc
close all

% 1.1 parameters
addpath('Fun'); % Add function path
ex_voxel=1; % Is voxel level topology exaggeration performed
ex_num=5; % Topological exaggeration parameter: number of exaggerated voxels
getNN_nn=5; % Calculate voxel resolution parameters and how many voxels should be used to represent minimum topological perception
getNN_camera_angle_nums=4;% Multi perspective selection: Divide 360° by this value
tp_ex=2; % Subdividing topological voxel parameters, expanding 1 * 1 to n * n
borderSize=2; % Reserved number of boundary voxels

% 1.2 Data Reading&Data Preprocessing
[vertices, faces, normals] = read_obj2('tiananmen_tri_simple.obj'); % Read test obj file
temp = vertices(:, 2);
vertices(:, 2) = vertices(:, 3);
vertices(:, 3) = temp; % Rotating the model to better conform to visual requirements
min_vertex = min(vertices, [], 1);
max_vertex = max(vertices, [], 1);
vertices = vertices - min_vertex;  % Normalize to zero to avoid negative values affecting subsequent calculations

% 1.3 Automatically calculate voxel resolution
NN=get_voxel_resolution(vertices,faces,getNN_nn,getNN_camera_angle_nums);% Automatically calculate voxel resolution

% 1.4 Voxelization
[voxels.logical, x, y, z] = voxelization(vertices, faces, NN,borderSize);% Execute voxelization

% 1.5 draw
% 1.5.1 Draw the original model
figure
patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'green', 'FaceAlpha', 0.7, 'EdgeColor', 'black');
axis equal;
axis off;
view(-30, 30);
title("Original model")

% 1.5.2 Draw Voxels
figure
axis equal;
axis off;
view(-30, 30);
title("Voxels")
voxel_num=[size(x,2),size(y,2),size(z,2)];
voxel_size = [NN,NN,NN];
for i = 1:voxel_num(1)
    for j = 1:voxel_num(2)
        for k = 1:voxel_num(3)
            if voxels.logical(i, j, k) == 1
                xx = (i - 1/2) * voxel_size(1);
                yy = (j - 1/2) * voxel_size(2);
                zz = (k - 1/2) * voxel_size(3);
                verticess = [xx-NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy+NN/2, zz+NN/2;xx-NN/2, yy+NN/2, zz+NN/2;];
                facess = [1, 2, 3, 4;2, 6, 7, 3;6, 5, 8, 7;5, 1, 4, 8;1, 2, 6, 5;4, 3, 7, 8;];
                patch('Vertices', verticess, 'Faces', facess, 'FaceColor', 'cyan','EdgeColor', '#808080' ,'LineWidth', 0.01);
            end
        end
    end
end
save part1.mat %The reading and drawing time is too long. Consider storing temporary variables for future debugging
%% 2.Topology exaggeration and optimization
clear
clc
load part1.mat %Read temporary variables

% 2.1 Extract and optimize topological voxels
voxels.logical=voxelization_bwlabel(voxels.logical);% Fill in internal holes
[voxels_tp, ~] = voxelization_tp_new(voxels.logical);% Search for topological holes

% 2.2 Calculate enclosed building elements
voxels_all=voxels;
voxels_all.logical(voxels_tp.logical==1)=1;% Constructing enclosed architectural elements

% 2.3 Optimization
% [voxels_tp.logical,voxels.logical] = voxelization_move_tp(voxels_tp.logical,voxels.logical,voxels_all.logical);% Topology voxel optimization configuration

% 2.4 Topological exaggeration
if(ex_voxel) % Topological exaggeration
    [voxels_ex,voxels_tp_ex]=Topological_exaggeration_voxelsmodel(voxels,voxels_tp,ex_num);
    voxels_ex.logical=voxelization_bwlabel(voxels_ex.logical);
else
    voxels_ex=voxels;
    voxels_tp_ex=voxels_tp;
end

% 2.5 Topological voxel subdivision
originalMatrix =voxels_tp_ex.logical; 
originalSize = size(voxels_tp_ex.logical);
expandedMatrix = false(originalSize(1) * tp_ex, originalSize(2) * tp_ex, originalSize(3) * tp_ex);
for layer = 1:originalSize(3) % Subdivision of topological perceptual voxels
    currentLayer = originalMatrix(:,:,layer);
    expandedLayer = kron(currentLayer, ones(tp_ex));% Kronecker product function:Provided by Matlab
    expandedMatrix(:,:,layer) = expandedLayer;
end
expanded_voxels_tp_ex.logical=expandedMatrix;% assignment
for layer = 1:size(expanded_voxels_tp_ex.logical,3)/2 
    currentLayer = expanded_voxels_tp_ex.logical(:,:,layer);
    expandedMatrix(:,:,2*layer-1) = currentLayer;
    expandedMatrix(:,:,2*layer) = currentLayer;
end 
expanded_voxels_tp_ex.logical=expandedMatrix;% Subdivision voxel

% 2.6 3D convolution
expanded_voxels_tp_ex.logical = smooth3(expanded_voxels_tp_ex.logical,'box',[3 3 3], 0.65); %3D convolution

% 2.7 Post processing for drawing
[m, n, p] = size(expanded_voxels_tp_ex.logical);
expanded_voxels_tp_ex.logical (1, :, :) = 0;
expanded_voxels_tp_ex.logical (m, :, :) = 0;
expanded_voxels_tp_ex.logical (:, 1, :) = 0;
expanded_voxels_tp_ex.logical (:, n, :) = 0;
expanded_voxels_tp_ex.logical (:, :, 1) = 0;
expanded_voxels_tp_ex.logical (:, :, p) = 0;% Set boundaries
countt=tp_ex*2; % Calculate the voxel center coordinates after subdivision
for i=1:numel(x)
    x1(i*2-1)=x(i)-NN/countt;
    x1(i*2)=x(i)+NN/countt;
end
for i=1:numel(y)
    y1(i*2-1)=y(i)-NN/countt;
    y1(i*2)=y(i)+NN/countt;
end
for i=1:numel(z)
    z1(i*2-1)=z(i)-NN/countt;
    z1(i*2)=z(i)+NN/countt;
end
for i =1:size(x,2)% Calculate voxel center coordinates
    for j =1:size(y,2)
        for k =1:size(z,2)
            voxels.centerpoint_x(i,j,k)=x(i);
            voxels.centerpoint_y(i,j,k)=y(j);
            voxels.centerpoint_z(i,j,k)=z(k);

            voxels_tp.centerpoint_x(i,j,k)=x(i);
            voxels_tp.centerpoint_y(i,j,k)=y(j);
            voxels_tp.centerpoint_z(i,j,k)=z(k);
            
        end
    end
end
for i =1:size(x1,2) % Calculate voxel (Expanded) center coordinates
    for j =1:size(y1,2)
        for k =1:size(z1,2)  
            expanded_voxels_tp_ex.centerpoint_x(i,j,k)=x1(i);
            expanded_voxels_tp_ex.centerpoint_y(i,j,k)=y1(j);
            expanded_voxels_tp_ex.centerpoint_z(i,j,k)=z1(k);   
        end
    end
end
voxel_num=[ size(voxels.centerpoint_x,1)  size(voxels.centerpoint_x,2)  size(voxels.centerpoint_x,3) ];
voxel_size = [NN,NN,NN]; % Statistical voxel basic information
% 2.8 drawing
% 2.8.1 Draw topological voxels
figure
hold on
axis equal;
view(-30, 30);
axis off
for i = 1:voxel_num(1)
    for j = 1:voxel_num(2)
        for k = 1:voxel_num(3)
                if voxels_all.logical(i, j, k) == 1
                    xx = (i - 1/2) * voxel_size(1);
                    yy = (j - 1/2) * voxel_size(2);
                    zz = (k - 1/2) * voxel_size(3);
                    verticess = [xx-NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy+NN/2, zz+NN/2;xx-NN/2, yy+NN/2, zz+NN/2;];
                    facess = [1, 2, 3, 4;2, 6, 7, 3;6, 5, 8, 7;5, 1, 4, 8;1, 2, 6, 5;4, 3, 7, 8;];
                    patch('Vertices', verticess, 'Faces', facess, 'FaceColor', 'cyan','EdgeColor', '#808080' ,'LineWidth', 0.01);
            end
        end
    end
end
% 2.8.2 Draw enclosed architectural voxels
figure
hold on
axis equal;
view(-30, 30);
axis off
for i = 1:voxel_num(1)
    for j = 1:voxel_num(2)
        for k = 1:voxel_num(3)
                if expanded_voxels_tp_ex.logical(i, j, k) ~= 0
                    xx = (i - 1/2) * voxel_size(1);
                    yy = (j - 1/2) * voxel_size(2);
                    zz = (k - 1/2) * voxel_size(3);
                    verticess = [xx-NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy-NN/2, zz-NN/2;xx+NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy+NN/2, zz-NN/2;xx-NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy-NN/2, zz+NN/2;xx+NN/2, yy+NN/2, zz+NN/2;xx-NN/2, yy+NN/2, zz+NN/2;];
                    facess = [1, 2, 3, 4;2, 6, 7, 3;6, 5, 8, 7;5, 1, 4, 8;1, 2, 6, 5;4, 3, 7, 8;];
                    patch('Vertices', verticess, 'Faces', facess, 'FaceColor', 'cyan','EdgeColor', '#808080' ,'LineWidth', 0.01);
            end
        end
    end
end
%% 3.Mesh generation based on MarchingCubes algorithm

% isosurface:Calculate iso surface
fv3=isosurface( expanded_voxels_tp_ex.centerpoint_x, expanded_voxels_tp_ex.centerpoint_y, expanded_voxels_tp_ex.centerpoint_z,expanded_voxels_tp_ex.logical,0.5);
draw_fv_patch(fv3,'cyan','black') %drawing function
fv2=isosurface( voxels.centerpoint_x, voxels.centerpoint_y, voxels.centerpoint_z,voxels_all.logical,0.5);
draw_fv_patch(fv2,'green','black')

export_to_obj('topo.obj',fv3)
export_to_obj('building.obj',fv2)
% Then we need to convert the obj format to off format, can be easily converted using Meshlab
