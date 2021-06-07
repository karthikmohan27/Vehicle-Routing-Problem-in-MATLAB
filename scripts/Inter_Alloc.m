function [VRP, VRP_dis_mx] = Inter_Alloc(TSP,CDIS,Capacity,Cluster_Capacity,Dis,Demand,k)
VRP_dis = zeros(k,6);
for ctr = 1:6
    for n = 1:k
        for j = 1:k
            if(n~=j)
                [TSP{n,ctr},TSP{j,ctr},CDIS(n,ctr),CDIS(j,ctr),Cluster_Capacity(n),Cluster_Capacity(j)] = Inter_node_relocation(TSP{n,ctr},TSP{j,ctr},Cluster_Capacity(n),Cluster_Capacity(j),CDIS(n,ctr),CDIS(j,ctr),Capacity,Dis,Demand);
            end
            VRP_dis(n,ctr) = CDIS(n,ctr);
            VRP_dis(j,ctr) = CDIS(j,ctr);
        end

    end
end
VRP=TSP;
VRP_dis_mx = VRP_dis;
end