function square_points = center_point_to_squarepoints(NN,centerpoint)
%输入正方体中心坐标和边长,获取所有顶点坐标
    square_points=zeros(8,3);
    square_points(1,:)=[centerpoint(1)-NN/2 centerpoint(2)-NN/2 centerpoint(3)-NN/2];
    square_points(2,:)=[centerpoint(1)+NN/2 centerpoint(2)-NN/2 centerpoint(3)-NN/2];
    square_points(3,:)=[centerpoint(1)+NN/2 centerpoint(2)+NN/2 centerpoint(3)-NN/2];
    square_points(4,:)=[centerpoint(1)-NN/2 centerpoint(2)+NN/2 centerpoint(3)-NN/2];
    square_points(5,:)=[centerpoint(1)-NN/2 centerpoint(2)-NN/2 centerpoint(3)+NN/2];
    square_points(6,:)=[centerpoint(1)+NN/2 centerpoint(2)-NN/2 centerpoint(3)+NN/2];
    square_points(7,:)=[centerpoint(1)+NN/2 centerpoint(2)+NN/2 centerpoint(3)+NN/2];
    square_points(8,:)=[centerpoint(1)-NN/2 centerpoint(2)+NN/2 centerpoint(3)+NN/2];
end