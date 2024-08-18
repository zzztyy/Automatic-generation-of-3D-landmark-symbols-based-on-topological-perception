function NN = get_voxel_resolution(vertices,faces,n,camera_angle)
% input
%  vertices: Point coordinates (n*3,double)
%  faces: Topology (n*3,double/uint8)
%  n: parameters getNN_nn(unit8)
%  camera_angle: Number of projection images(unit8)
%
%
% output
%  NN: Voxel resolution (double)

NN=0;
min_vertex = min(vertices, [], 1);
max_vertex = max(vertices, [], 1);
vertices = vertices - min_vertex;
angle=360/camera_angle;
for i=1:camera_angle
    h = figure('Visible', 'off');

    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'none', 'FaceAlpha', 0.7, 'EdgeColor', 'none');
    xlim([ 0 -min_vertex(1)+max_vertex(1)])
    ylim([ 0 -min_vertex(2)+max_vertex(2)])
    zlim([ 0 -min_vertex(3)+max_vertex(3)])
    axis equal;
    axis off;
    view(angle*i, 0);
    saveas(h, "GetNN_axis_"+mat2str(i)+".png");
    close(h);

    h = figure('Visible', 'off');


    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'black', 'FaceAlpha', 0.7, 'EdgeColor', 'none');
    xlim([ 0 -min_vertex(1)+max_vertex(1)])
    ylim([ 0 -min_vertex(2)+max_vertex(2)])
    zlim([ 0 -min_vertex(3)+max_vertex(3)])
    axis equal;
    axis off;
    camlight
    lighting flat
    view(angle*i, 0);
    saveas(h, "GetNN_mat_"+mat2str(i)+".png");
    close(h);

    imdata_im=imread("GetNN_mat_"+mat2str(i)+".png");
    imdata_axis=imread("GetNN_axis_"+mat2str(i)+".png");
    imdata_im=rgb2gray(imdata_im);
    imdata_axis=rgb2gray(imdata_axis);
    result_image = im2double(imsubtract(imdata_axis,imdata_im));


    result_image(result_image==0)=255;

    result_image(result_image~=255)=0;


    bbox=[0 0 ; 0 0];

    for ii =1:size(result_image,1)
        if(~isempty(find(result_image(ii,:)==0, 1)))
            bbox(1,1)=ii;
            break;
        end

    end
    for ii =size(result_image,1):-1:1
        if(~isempty(find(result_image(ii,:)==0, 1)))
            bbox(1,2)=ii;
            break;
        end

    end
    for ii =1:size(result_image,2)
        if(~isempty(find(result_image(:,ii)==0, 1)))
            bbox(2,1)=ii;
            break;
        end

    end
    for ii =size(result_image,2):-1:1
        if(~isempty(find(result_image(:,ii)==0, 1)))
            bbox(2,2)=ii;
            break;
        end

    end
    result_image=result_image(bbox(1,1):bbox(1,2),bbox(2,1):bbox(2,2));
    result_image=im_tran(result_image,1);




    first_one_index = find(result_image(1,:) == 0 ,1, 'first'); %第一行
    last_one_index = find(result_image(1,:) == 0, 1, 'last');
    if isempty(first_one_index) || isempty(last_one_index)
    else

        for k=first_one_index+1:last_one_index-1
            if(result_image(1,k)~=0)
                result_image(1,k)=0;
            end
        end
    end

    first_one_index = find(result_image(end,:) == 0 ,1, 'first');%第max行
    last_one_index = find(result_image(end,:) == 0, 1, 'last');
    if isempty(first_one_index) || isempty(last_one_index)
    else

        for k=first_one_index+1:last_one_index-1
            if(result_image(end,k)~=0)
                result_image(end,k)=0;
            end
        end
    end

    first_one_index = find(result_image(:,1) == 0 ,1, 'first');
    last_one_index = find(result_image(:,1) == 0, 1, 'last');
    if isempty(first_one_index) || isempty(last_one_index)
    else

        for k=first_one_index+1:last_one_index-1
            if(result_image(k,1)~=0)
                result_image(k,1)=0;
            end
        end
    end
    first_one_index = find(result_image(:,end) == 0 ,1, 'first');
    last_one_index = find(result_image(:,end) == 0, 1, 'last');
    if isempty(first_one_index) || isempty(last_one_index)
    else

        for k=first_one_index+1:last_one_index-1
            if(result_image(k,end)~=0)
                result_image(k,end)=0;
            end
        end
    end


    result_image(result_image==1)=2;
    result_image(result_image==0)=1;
    result_image(result_image==2)=0;
    I1=imfill(result_image,'holes');
    img=I1-result_image;

    [label,num]=bwlabel(img);

    for ii=1:num
        verctor(ii)=size(label(label==ii),1);
    end
    if(num)
        percentile_75 = max(verctor)/10  ;

        for iii=1:num
            if(size(label(label==iii),1)<percentile_75||size(label(label==iii),1)<size(label,1)*size(label,2)/400) %设置阈值

                label(label==iii)=0;
            else
                label(label==iii)=1;
            end
        end
    end

    result_image_tp=label;

    [label, num] = bwlabel(result_image_tp);
    mmin_index=0;
    if(num)
        mmin=size(label(label==1),1);
        mmin_index=1;

        for ii=1:num
            if(mmin>size(label(label==ii),1))
                mmin=size(label(label==ii),1);
                mmin_index=ii;
            end
        end
        for ii=1:num
            if(ii~=mmin_index)
                label(label==ii)=0;
            end
        end
        label(label==mmin_index)=1;
    end
    result_image_tp=label;

    ssum=0;
    kk=0;
    for  ii=1:size(result_image_tp,1)
        if( size(find(result_image_tp(ii,:)==1),2))
            ssum=ssum+size(find(result_image_tp(ii,:)==1),2);
            kk=kk+1;
        end
    end
    bbox_size_min=min(-min_vertex+max_vertex);
    mean_voxel=ssum/kk;

    imborder_size=min(size(label,1),size(label,2));

    tp_border=mean_voxel/imborder_size*bbox_size_min;

    NN(i)=tp_border/n;

end
NNmin=0;

NN(isnan(NN)) = [];

if(~isempty(NN))

    NNmin=min(NN);
    NN=NNmin;
else
    NN=min(max_vertex-min_vertex)/25;

end




end