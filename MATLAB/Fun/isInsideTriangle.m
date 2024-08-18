% 辅助函数，判断点是否在三角形内部
function inside = isInsideTriangle(point, triangleVertices)
    % 计算三角形的法向量和边向量
    triangleNormal = cross(triangleVertices(2,:) - triangleVertices(1,:), triangleVertices(3,:) - triangleVertices(1,:));
    edge1 = triangleVertices(2,:) - triangleVertices(1,:);
    edge2 = triangleVertices(3,:) - triangleVertices(2,:);
    edge3 = triangleVertices(1,:) - triangleVertices(3,:);
    
    % 计算点到三个边的向量
    toEdge1 = point - triangleVertices(1,:);
    toEdge2 = point - triangleVertices(2,:);
    toEdge3 = point - triangleVertices(3,:);
    
    % 判断点是否在三个边的同侧
    cross1 = dot(triangleNormal, cross(edge1, toEdge1));
    cross2 = dot(triangleNormal, cross(edge2, toEdge2));
    cross3 = dot(triangleNormal, cross(edge3, toEdge3));
    
    % 判断点是否在三角形内部
    inside = cross1 >= 0 && cross2 >= 0 && cross3 >= 0;
end