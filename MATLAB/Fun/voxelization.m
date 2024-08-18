function [voxelGrid, voxelCentersX, voxelCentersY, voxelCentersZ] = voxelization(vertices, faces, voxelSize, borderSize)
% input
%  vertices : Point coordinates (n*3,double)
%  faces : Topology (n*3,double/uint8)
%  voxelSize : Voxel resolution, here should be the NN calculated in the previous step
%  borderSize : parameter borderSize
% output
%  voxelGrid : Three dimensional logic matrix represents voxels (m*n*l,logical/double)
%  voxelCentersX,voxelCentersY,voxelCentersZ : Voxel center coordinates (1*m 1*n 1*z,double)
minVertex = min(vertices);
maxVertex = max(vertices);
NN=voxelSize;
% Extend the bounding box by the border size
extendedMinVertex = minVertex - borderSize * voxelSize;
extendedMaxVertex = maxVertex + borderSize * voxelSize;

dimensions = ceil((extendedMaxVertex - extendedMinVertex) / voxelSize);
voxelGrid = zeros(dimensions);

% Calculate voxel centers' coordinates
voxelCentersX = extendedMinVertex(1) + voxelSize/2 + (0:dimensions(1)-1) * voxelSize;
voxelCentersY = extendedMinVertex(2) + voxelSize/2 + (0:dimensions(2)-1) * voxelSize;
voxelCentersZ = extendedMinVertex(3) + voxelSize/2 + (0:dimensions(3)-1) * voxelSize;



for i=1:size(faces,1)  %Calculate for each surface
    disp(i)
    %Find the coordinates of the three vertices of the triangular surface that needs to be calculated in this loop
    tri_point1=vertices(faces(i,1),:);
    tri_point2=vertices(faces(i,2),:);
    tri_point3=vertices(faces(i,3),:);
    tri_points=[tri_point1;tri_point2;tri_point3];
    %Calculate the maximum and minimum values of the outsourcing box
    tri_outbox_min=min([tri_point1;tri_point2;tri_point3], [], 1);
    tri_outbox_max=max([tri_point1;tri_point2;tri_point3], [], 1);

    %The voxel range occupied by the triangular panel bounding box in this cycle
    this_min=floor(tri_outbox_min/NN)+1+borderSize;
    this_max=floor(tri_outbox_max/NN)+1+borderSize;

    for ii=this_min(1):this_max(1)
        for jj=this_min(2):this_max(2)
            for kk=this_min(3):this_max(3)
                this_center_point=[voxelCentersX(ii) voxelCentersY(jj) voxelCentersZ(kk)];%The currently determined center coordinates of the cube


                for ll=1:12  %For each voxel (12 edges), perform radiographic testing on the triangular patch for each edge
                    [segementStart,segementEnd]=center_point_to_line_point(NN,this_center_point,ll);
                    if(checkIntersection(segementStart,segementEnd,tri_points))
                        voxelGrid(ii,jj,kk)=1;
                        break;
                    end
                end


                %Calculate the three sides of a triangle for each voxel
                for mm=1:3
                    switch mm
                        case 1
                            segementStart=tri_point1;
                            segementEnd=tri_point2;
                        case 2
                            segementStart=tri_point2;
                            segementEnd=tri_point3;
                        case 3
                            segementStart=tri_point3;
                            segementEnd=tri_point1;
                    end

                    for nn=1:6
                        squarepoints=get_square_faces_points(NN,this_center_point,nn);

                        if(checkIntersection(segementStart,segementEnd,squarepoints(1:3,:)))
                            voxelGrid(ii,jj,kk)=1;
                            break;
                        end
                        if(checkIntersection(segementStart,segementEnd,squarepoints([1 3 4],:)))
                            voxelGrid(ii,jj,kk)=1;
                            break;
                        end
                    end
                end
            end
        end
    end
end




end
