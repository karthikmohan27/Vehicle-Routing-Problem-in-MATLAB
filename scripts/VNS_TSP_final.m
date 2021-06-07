%implementation of the Variable Neighborhood Search
function [ Best_TSP ,BestCost] = VNS_TSP_final(TSP,BestCost,Dis)
BestImp=-2;
TSP_Size = size(TSP,2);
if(TSP_Size>5)   
    
    %initialize the variables
    Nb_NoImp=0;
    Cost=BestCost;
    iter=0;
    Improvement_in_Cost=Inf;
    
    node1=-1;
    node2=-1;
    node3=-1;
    
    %select the Neighborhood Order
    Neighbor_order=[5 4 3 2 1];
    Neighbor_Str=1;
    
    while(BestImp<0 )
        switch Neighbor_order(Neighbor_Str)
            case 1
                [node1,node2,Improvement_in_Cost]=Two_Opt_Random(TSP,Dis);
            case 2
                [node1,node2,node3,Improvement_in_Cost,Three_Opt_Type]=Or_Opt(TSP,Dis,1);
            case 3
                [node1,node2,node3,Improvement_in_Cost,Three_Opt_Type]=Or_Opt(TSP,Dis,2);
            case 4
                [node1,node2,node3,Improvement_in_Cost,Three_Opt_Type]=Or_Opt(TSP,Dis,3);                
            case 5
               [node1,node2,node3,Improvement_in_Cost,Three_Opt_Type]= Three_Opt(TSP,Dis);                
        end
        
        BestImp=round(Improvement_in_Cost,3);       
        if(BestImp<0)
            NewTSP=zeros(size(TSP,1),size(TSP,2));
            Cost=BestCost+Improvement_in_Cost;
            BestCost=Cost;
            %%perform move
            if(Neighbor_order(Neighbor_Str)==1)% perform 2opt
                NewTSP=[TSP(1:node1) fliplr(TSP(node1+1:node2)) TSP(node2+1:end) ];
            else% perform 3-opt & Or-opt
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
            end
            TSP=NewTSP;
            Best_TSP=TSP;
            NewTSP=[];      
            Neighbor_Str=1;
            Nb_NoImp=0;
        else % no improvement found

            Nb_NoImp=Nb_NoImp+1;
            if(Nb_NoImp>=6)
                BestImp=0;
            else

                if(Neighbor_Str>=5)
                    Neighbor_Str=1;
                    BestImp=-2;
                else
                    Neighbor_Str=Neighbor_Str+1;
                    BestImp=-2;
                end
            end
        end
    end    
end
Best_TSP = TSP;
end

