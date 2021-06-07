%perform the three-opt and return the value of the TSP and it's cost
function [NewCost, NewTSP] =  Perform_3OptMove(TSP,TSP_Size,Dis, i,j,k,Three_Opt_Type);

node1=i;
node2=j;
node3=k;

%change into whichever type the TSP has to become
if (Three_Opt_Type == 1)
    if (node3 >= node2 + 1)
        NewTSP=[TSP(1:node1) fliplr(TSP(node2+1:node3)) TSP(node1+1:node2) TSP(node3+1:end) ];
    elseif (node3 + 1 <= node1)
            NewTSP=[ fliplr(TSP(node2+1:end)) TSP(node1+1:node2) TSP(node3+1:node1) fliplr(TSP(1:node3))];
    end
elseif (Three_Opt_Type == 2)
        if (node3 >= node2 + 1)
            NewTSP=[TSP(1:node1) TSP(node2+1:node3) TSP(node1+1:node2) TSP(node3+1:end) ];
        elseif (node3 + 1 <= node1)
                NewTSP=[TSP(1:node3) TSP(node1+1:node2) TSP(node3+1:node1) TSP(node2+1:end) ];
        end
end

%calculate the total cost associated with the NewTSP
Total_Dis = 0;
for i=1:size(NewTSP,2)-1;
    Total_Dis = Total_Dis + Dis(NewTSP(i),NewTSP(i+1));
end

NewCost = Total_Dis;
end

