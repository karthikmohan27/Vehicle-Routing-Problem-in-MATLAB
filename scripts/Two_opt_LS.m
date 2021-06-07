function [BestCost, TSP ] = Two_opt_LS(TSP,TSPCost,Dis,TSPType)
% Note that the initial feasible solution is TSP and the corresponding objective function 
% value is TSPCost

BestImp=-1;
Improvement_in_Cost=Inf;
%Initialize  node1 & node2 to -1
node1=-1;
node2=-1;
%Initialize BestCost to TSPCost
BestCost=TSPCost;
%REPEAT until stopping condition = true // e.g., (TSP is a local optimum [BestImp<0] )
while(BestImp<0)   
    % search the neighborhood of TSP given the neighborhood structure
    switch TSPType
        case 1
            [node1,node2,Improvement_in_Cost]=Two_Opt_Steepest(TSP,Dis); 
        case 2
            [node1,node2,Improvement_in_Cost]=Two_Opt_Random(TSP,Dis); 
        case 3
            [node1,node2,Improvement_in_Cost]=Two_Opt_Per_Random(TSP,Dis);
    end
    BestImp=round(Improvement_in_Cost,3);
    % if the BestImp is less than zero (i.e. a better neighbor is found
    % that improves the tour by Improvement_in_Cost, update the BestCost
    % and current neighbor TSP
    if(BestImp<0 && node1~=-1)       
        Cost=BestCost+Improvement_in_Cost;        
        BestCost=Cost;
        %%% easy way of updating the tour
        NewTSP=[TSP(1:node1) fliplr(TSP(node1+1:node2)) TSP(node2+1:end) ];
        TSP=NewTSP;
        NewTSP=[];
    else      
        BestImp=0;
    end
end
end