function squareVertices = get_square_faces_points(NN,this_center_point,i)

    squarepoints=center_point_to_squarepoints(NN,this_center_point);
    p1=squarepoints(1,:);
    p2=squarepoints(2,:);
    p3=squarepoints(3,:);
    p4=squarepoints(4,:);
    p5=squarepoints(5,:);
    p6=squarepoints(6,:);
    p7=squarepoints(7,:);
    p8=squarepoints(8,:);
    
    switch i
        case 1
            squareVertices=[p1;p2;p3;p4];
        case 2
            squareVertices=[p5;p6;p7;p8];
        case 3
            squareVertices=[p1;p2;p6;p5];
        case 4
            squareVertices=[p3;p4;p8;p7];
        case 5
            squareVertices=[p2;p3;p7;p6];
        case 6
            squareVertices=[p1;p4;p8;p5];
    end
end