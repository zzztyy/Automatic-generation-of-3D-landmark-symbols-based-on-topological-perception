function isIntersect = checkIntersection(segmentStart, segmentEnd, triangleVertices)
    % 计算线段的方向向量
    segmentVector = segmentEnd - segmentStart;
    
    % 计算三角形的法向量
    triangleNormal = cross(triangleVertices(2,:) - triangleVertices(1,:), triangleVertices(3,:) - triangleVertices(1,:));
    
    % 判断线段与三角形是否平行
    if norm(segmentVector) < eps || norm(triangleNormal) < eps
        isIntersect = false; % 线段与三角形平行，不相交
        return;
    end
    
    % 计算线段参数方程的分母
    segmentDenominator = dot(triangleNormal, segmentVector);
    
    % 判断线段与三角形是否共面
    if abs(segmentDenominator) < eps
        isIntersect = false; % 线段与三角形共面，不相交
        return;
    end
    
    % 计算线段的起点到三角形顶点1的向量
    startToVertex1 = triangleVertices(1,:) - segmentStart;
    
    % 计算线段参数方程的参数t
    t = dot(triangleNormal, startToVertex1) / segmentDenominator;
    
    % 判断t是否在[0,1]的范围内
    if t < 0 || t > 1
        isIntersect = false; % t不在[0,1]范围内，线段不与三角形相交
        return;
    end
    
    % 计算交点
    intersectionPoint = segmentStart + t * segmentVector;
    
    % 判断交点是否在三角形内部
    isIntersect = isInsideTriangle(intersectionPoint, triangleVertices);
end