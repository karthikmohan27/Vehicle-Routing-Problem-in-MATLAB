function [newTSP1,newTSP2,TSP1_Dis_new,TSP2_Dis_new,newCC1,newCC2] = Inter_node_relocation(TSP1,TSP2,CC1,CC2,TSP1_Dis,TSP2_Dis,Capacity,Dis,Demand)
%this function is used for placing one node from TSP1 to TSP2 and
%optimising both the TSPs

%calculate total distance
Node1 = -1;
totaldis = TSP1_Dis + TSP2_Dis;
TSP1_Size = size(TSP1,2);
TSP2_Size = size(TSP2,2);

%traverse through all nodes except the depot
for i = 2:TSP1_Size-1
    for j= 2:TSP2_Size-1
        if(TSP1(i)~=TSP2(j))
            NewTSP1_Dis = TSP1_Dis + Dis(TSP1(i-1),TSP1(i+1)) - Dis(TSP1(i-1),TSP1(i)) - Dis(TSP1(i),TSP1(i+1));
            NewTSP2_Dis = TSP2_Dis + Dis(TSP2(j),TSP1(i)) + Dis(TSP1(i),TSP2(j+1)) - Dis(TSP2(j),TSP2(j+1));
            %recompute temporary cluster capacity
            CC1_temp = CC1 - Demand(TSP1(i));
            CC2_temp = CC2 + Demand(TSP1(i));
            new_total_dis = NewTSP1_Dis + NewTSP2_Dis;
            %while checking conditions, check if cluster capacities are
            %exceeded, and if not, check for the distance values
            if(CC1_temp <= Capacity && CC2_temp <= Capacity && new_total_dis < totaldis)
                Node1 = i;
                Node2 = j;
                totaldis = new_total_dis;
                TSP1_Dis_new = NewTSP1_Dis;
                TSP2_Dis_new = NewTSP2_Dis;
            end
        end
    end
end
%finalise the variables which will change the clusters
if(Node1 ~= -1)
    newCC1 = CC1 - Demand(TSP1(Node1));
    newCC2 = CC2 + Demand(TSP1(Node1));
    newTSP1 = [TSP1(1:Node1-1) TSP1(Node1+1:end)];
    newTSP2 = [TSP2(1:Node2-1) TSP1(Node1) TSP2(Node2+1:end)];
else
    newTSP1 = TSP1;
    newTSP2 = TSP2;
    TSP1_Dis_new = TSP1_Dis;
    TSP2_Dis_new = TSP2_Dis;
    newCC1 = CC1;
    newCC2 = CC2;
end
end