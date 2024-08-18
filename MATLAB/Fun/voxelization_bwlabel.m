function voxels_out = voxelization_bwlabel(voxels_logical)
% Fill the internal holes of the building
% input
%   voxels_logical:Three dimensional logic matrix represents voxels (m*n*l,logical/double)
% ouput
%   voxels_out：Three dimensional logic matrix represents voxels (m*n*l,logical/double)
voxels_out=voxels_logical;
maxx=1;
for i=1:size(voxels_logical,3)
    Graph=voxels_logical(:,:,i);
    [label, num] = bwlabel(Graph);

    for iii=1:num
        verctor(iii)=size(label(label==iii),1);
    end

    if(num)
        percentile_75 = max(verctor)/10;
        for iii=1:num
            if(size(label(label==iii),1)<percentile_75||size(label(label==iii),1)<min(size(voxels_logical,1),size(voxels_logical,2))/10) %设置阈值
                label(label==iii)=0;
            end
        end
    end

    if(num>maxx)
        maxx=num;
        maxi=i;
    end
    if(num)
        for j=1:num

            for k =1:size(label,1)
                this_line=label(k,:);
                first_one_index = find(this_line == j, 1, 'first');
                last_one_index = find(this_line == j, 1, 'last');
                if isempty(first_one_index) || isempty(last_one_index)
                else
                    for kk=first_one_index+1:last_one_index-1
                        label(k,kk)=j;

                    end
                end
            end
            for k =1:size(label,2)
                this_line=label(:,k);
                first_one_index = find(this_line == j, 1, 'first');
                last_one_index = find(this_line == j, 1, 'last');
                if isempty(first_one_index) || isempty(last_one_index)
                else
                    for kk=first_one_index+1:last_one_index-1

                        label(kk,k)=j;

                    end
                end
            end



        end

    end

    voxels_out(:,:,i)=label;
end


for i=1:maxx
    voxels_out(voxels_out==i)=1;

end

end