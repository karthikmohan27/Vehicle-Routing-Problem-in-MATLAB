%implenting a loop for running all the construction heuristics
function[VRP, VRP_dis_mx, CDIS, TSP, t] = Construction_Heuristics(k,depot_index, Distance, Location, clusters)
    VRP_dis = zeros(k,6);
    t = zeros(k,6);
    TSP = cell(k,6);
    CDIS = cell(k,6);
    for n = 1:k
        clusters{n}(end+1) = depot_index ;
        for j = 1:6
            switch j
            case 1
                tic
                [CDIS{n,j},TSP{n,j}] = Nearest_Neighbor(depot_index,clusters{n},Distance);
                t(n,j) = toc;
            case 2
                tic
                [CDIS{n,j},TSP{n,j}]  = Cheapest_Insertion(depot_index,clusters{n},Distance);
                t(n,j) = toc;
            case 3
                tic
                [CDIS{n,j},TSP{n,j}] = Arbitrary_Insertion(depot_index,clusters{n},Distance);
                t(n,j) = toc;
            case 4
                tic
                [CDIS{n,j},TSP{n,j}] = Farthest_Insertion(depot_index,clusters{n},Distance);
                t(n,j) = toc;
            case 5
                tic
                [CDIS{n,j},TSP{n,j}]  = Nearest_Merger(depot_index,clusters{n},Distance,Location);
                t(n,j) = toc;
            case 6
                tic
                [CDIS{n,j},TSP{n,j}] = ClarkandWrightSaving(Location,Distance,size(clusters{n},2),depot_index,clusters{n});
                t(n,j) = toc;    
            end
            VRP_dis(n,j)= VRP_dis(n,j) + CDIS{n,j};
        end
    end
    VRP = TSP;
    VRP_dis_mx = VRP_dis;
end