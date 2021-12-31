function [dissimilarity,overlap] = DOC(X, diss_type, overlap_type)
% size(X) = [num_species,num_samples];
% X = y_ends';

KLD = @(x,y) sum(x(x>0).*log(x(x>0)./y(x>0)));
rJSD = @(x,y) sqrt(0.5*KLD(x, (x+y)/2) + 0.5*KLD(y,(x+y)/2));
[~, num_tests] = size(X);
overlap = nan(num_tests*(num_tests-1)/2);
dissimilarity = zeros(num_tests*(num_tests-1)/2);
% X = X./sum(X,1);

for i =1:num_tests - 1
    for j = i+1:num_tests
        % Finding the shared species
        SharedSpecies = find(X(:,i)>0 & X(:,j)>0);
        % Calculating the overlap
        switch overlap_type
            case ''
                overlap(i,j) = 0.5*(sum(X(SharedSpecies,i))+sum(X(SharedSpecies,j)));
            case 'jaccard'
                % v1 = X(SharedSpecies,i); v1=v1(v1~=0);
                % v2 = X(SharedSpecies,i); v2=v2(v2~=0);
                % 1-pdist2(X(:,i)', X(:,j)', 'jaccard')
                
                overlap(i,j)=sum(X(:,i) ~=0 & X(:,j)~=0) / sum(X(:,i)~=0 | X(:,j)~=0);  % jaccard index: 1=similar, 0=very far
                %overlap(i,j) = 1-pdist2(X(:,i)', X(:,j)', 'jaccard');
                %v1=X(:,i)';
                %v2=X(:,j)';
                %pdist2(X(:,i)', X(:,j)', 'jaccard');
                
        end
        if overlap(i,j) ~= 0
            
            % Renormalizing the shared species
            v1 = X(SharedSpecies,i)/sum(X(SharedSpecies,i));
            v2 = X(SharedSpecies,j)/sum(X(SharedSpecies,j));
            % v1 = Xf(SharedSpecies,i);
            % v2 = Xf(SharedSpecies,j);
            
            % Calculating the dissimilarity
            switch diss_type
                case 'euclidean'
                    %  dissimilarity(i,j) = 1 - corr(v1,v2,'Type','Spearman');
                    dissimilarity(i,j) = sqrt(sum((v1-v2).^2));
                case 'rjsd'
                    dissimilarity(i,j) = rJSD (v1,v2);
                    
                case 'spearman'
                    dissimilarity(i,j) = pdist2(v1', v2', 'spearman');
            end
            %           dissimilarity(i,j) = norm(v1 - v2);
            %         if dissimilarity(i,j)<1e-5;
            %             a = 1;
            %         end
        end
    end
end

dissimilarity = dissimilarity(:);
overlap = overlap(:);

indx = find(isnan(overlap));
overlap(indx) = [];
dissimilarity(indx) = [];

end