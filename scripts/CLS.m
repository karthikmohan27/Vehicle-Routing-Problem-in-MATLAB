%the implementation of CLS algorithms
function[VRP, VRP_dis_mx] = CLS(k, Distance, TSP, CDIS, Capacity, Cluster_Capacity, Demand)
VRP_dis = zeros(k,6);
temp_dis = zeros(1,3);
temp_tsp = cell(1:3);
for n = 1:k
    for j = 1:6
        %doing the different types of methods like Steepest, Random,
        %Percentage Random
        for i = 1:3
             [temp_dis(1,i),temp_tsp{1,i}] = Two_opt_LS(TSP{n,j},CDIS{n,j},Distance,i);
        end
        [CDIS{n,j},i]=min(temp_dis);
        TSP{n,j} = temp_tsp{1,i};
        VRP_dis(n,j)= VRP_dis(n,j) + CDIS{n,j};
    end
end
%Inter-node relocation is being done across different TSPs in the VRP
[VRP, VRP_dis_mx] = Inter_Alloc(TSP,VRP_dis,Capacity,Cluster_Capacity,Distance,Demand,k);
end