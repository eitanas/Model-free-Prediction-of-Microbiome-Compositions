function d = calculate_distance_from_known_elems(v1, v2, mean_v )
%
% suggested_abundance needs to be modified according to the non zero
% indices of real
% v1 = true_abundance;
% v2 = suggested_abundance;
% 
% v is the result vector
v = zeros(1, length(v1));
% indices that I need to take values from "suggested"
nonzero_idxs = intersect( find(v1>0), find(v2>0));
v(nonzero_idxs) = v2(nonzero_idxs);

%C = setdiff( find(suggested_abundance>0), find(true_abundance>0))
C = setdiff(find(v1>0), find(v2>0));
v(C) = mean_v(C);
%idx=find(v==0);
v = v./sum(v);
% calculate distance
d=sqrt(sum((v-v1).^2));

    

end

