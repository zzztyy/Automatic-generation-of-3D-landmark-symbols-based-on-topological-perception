function [vertices, faces, normals] = read_obj2(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error(['Cannot open file ' filename]);
    end
    
    vertices = [];
    normals = [];
    faces = [];

    while ~feof(fid)
        line = fgetl(fid);
        if isempty(line) || line(1) == '#' % 忽略空行和注释
            continue;
        end
        
        tokens = strsplit(line);
        
        if strcmp(tokens{1}, 'v')
            % 读取顶点坐标
            x = str2double(tokens{2});
            y = str2double(tokens{3});
            z = str2double(tokens{4});
            vertices(end+1,:) = [x y z];
        elseif strcmp(tokens{1}, 'vn')
            % 读取法向量
            x = str2double(tokens{2});
            y = str2double(tokens{3});
            z = str2double(tokens{4});
            normals(end+1,:) = [x y z];
        elseif strcmp(tokens{1}, 'f')
            % 读取面
            v1 = str2double(strsplit(tokens{2}, '/'));
            v2 = str2double(strsplit(tokens{3}, '/'));
            v3 = str2double(strsplit(tokens{4}, '/'));
            faces(end+1,:) = [v1(1) v2(1) v3(1)];
        end
    end
    
    fclose(fid);
end
