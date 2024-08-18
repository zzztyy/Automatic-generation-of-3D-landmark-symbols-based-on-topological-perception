function [line_start line_end] = center_point_to_line_point(NN,centerpoint,index)
%输入正方体中心坐标和边长和对应编号，获取对应的线段起始结束坐标
    squarepoints=center_point_to_squarepoints(NN,centerpoint);
    p1=squarepoints(1,:);
    p2=squarepoints(2,:);
    p3=squarepoints(3,:);
    p4=squarepoints(4,:);
    p5=squarepoints(5,:);
    p6=squarepoints(6,:);
    p7=squarepoints(7,:);
    p8=squarepoints(8,:);
    switch index
        case 1
            line_start=p1;
            line_end=p2;
        case 2
            line_start=p2;
            line_end=p3;
        case 3
            line_start=p3;
            line_end=p4;
        case 4
            line_start=p4;
            line_end=p1;
        case 5
            line_start=p5;
            line_end=p6;
        case 6
            line_start=p6;
            line_end=p7;
        case 7
            line_start=p7;
            line_end=p8;
        case 8
            line_start=p8;
            line_end=p5;
        case 9
            line_start=p6;
            line_end=p2;
        case 10
            line_start=p5;
            line_end=p1;
        case 11
            line_start=p8;
            line_end=p4;
        case 12
            line_start=p7;
            line_end=p3;
    end

end