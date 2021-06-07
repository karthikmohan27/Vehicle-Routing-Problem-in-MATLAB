function [centroids, clusters, cluster_capacity, depot_location, t_clust, Nb_nodes, k] = create_clusters(Location,Demand,Capacity)
%Storing depot separately, and removing it from the location matrix
[depot_demand, depot_index] = min(Demand);
depot_location = Location(Demand == depot_demand, :); %depot_demand should always be zero
Location(depot_index,:) = [];
Demand(depot_index,:) = [];

%Storing the number of nodes not including Depot        
Nb_nodes = size(Location,1);

%for i = 1:Nb_nodes
%    Demand(i,2) = i;
%    Location(i,3) = i;
%end
%Demand = sortrows(Demand);


%Finding total demand - to determine K
Total_demand = sum(Demand);
%Storing truck capacity - cluster capacity
%finding K
k = ceil(Total_demand/Capacity);

%finding K random centroids - we are using nodes for sake of simplicity
% cent_index = randi(Nb_nodes,[k,1]);
cent_index = randperm(Nb_nodes,k);
centroids = Location(cent_index,1:2);
t_clust = 0;
counter = 1;
tic
while(counter <= 30)
    %creating the distance matrix - distance between nodes and centroids
    distance_mx_cent = pdist2(Location, centroids);
    %creating the cluster arrays
    clusters = cell(k,1);
    cluster_capacity = int16.empty(k,0);
    %initialize cluster capacity
    for n = 1:k
        cluster_capacity(n) =  Capacity;
    end
    %sort the demand in ascending order
    sort(Demand);
    Demand_backup = Demand;
    assigned = 0;
    for counter2 = 1:Nb_nodes
        %calculate the maximum of demand
        [max_demand,n] = max(Demand);
        while(assigned==0)
            %calculate the minimum distance among each of the centroids
            [min_row_dist, min_row_idx] = min(distance_mx_cent(n,:));
            %if cluster capacity is exceeded already for the given centroid
            if(cluster_capacity(min_row_idx) > max_demand)
                clusters{min_row_idx}(end+1)  = n;
                cluster_capacity(min_row_idx) = cluster_capacity(min_row_idx) - Demand(n);
                %use a boolean to check if the variable has been assigned
                assigned = 1;
            else
                distance_mx_cent(n,min_row_idx) = inf;
                assigned = 0;
            end
        end
        assigned = 0;
        Demand(n)=0;
    end
    Demand = Demand_backup;
    %Cluster updation
    for n = 1:k
        centroid_x = mean(Location(clusters{n}));
        centroid_y = mean(Location(clusters{n},2));
        centroids(n,1) = centroid_x;
        centroids(n,2) = centroid_y;
    end
    counter = counter + 1;
end
cluster_capacity = 100-cluster_capacity;
t_clust = toc;
end