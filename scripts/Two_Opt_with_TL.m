%find best possible improvement
function [node1,node2,BestImp,Tabu_idx]= Two_Opt_with_TL(TSP,TSP_Cost,Best_TSPCost,TSP_Size,Dis,TabuList)

if(TSP_Size>5)
        %. Dis[i,j]+Dis[i+1, j+1]-Dis[i,i+1]-Dis[j,j+1];
    Tabu_idx=0;
    BestImp=inf;

    % calculate the improvements acheived by all combination of 2-opt and pick the best amongst them
    for i=1:TSP_Size-3

        %check if the first edge is in the tabu list
        T1=[i i+1];
        [tf1]=ismember( TabuList, T1,'rows' );
        if(sum(tf1)==0 )
            T1=[i+1 i];
            [tf1]=ismember( TabuList, T1,'rows' );
        end
        idx1=find(tf1==1);
        for j=i+2:TSP_Size-1

            %check if the second edge is in the tabu list
            T2=[j j+1];
            [tf2]=ismember( TabuList, T2,'rows' );
            if(sum(tf2)==0)
                T2=[j+1 j];
                [tf2]=ismember( TabuList, T2,'rows' );
            end
            idx2=find(tf2==1);
            %Calculate the cost of breaking two edges and adding two new edges
            imp=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));


            %  if this combination has at least one of the edges are non-tabu   &
            %  a leads to a less  cost of deleting and adding two new edges
            if(sum(tf1)==0 || sum(tf2)==0)

                if(imp<BestImp) 
                    BestImp=imp;
                    node1=i;
                    node2=j;
                    Tabu_idx=[idx1 idx2];
                end
            else %  if at both of the edges are non tabu at this combination ;
                 % but the aspiration criterion overrides its tabu status; e.g., 
                 % the new neighbor is better than the best solution found so far
                if(TSP_Cost+imp<Best_TSPCost)
                    BestImp=imp;
                    node1=i;
                    node2=j;
                    Tabu_idx=[idx1 idx2];
                end
            end
        end
    end
else
    node1 = 0;
    node2 = 0;
    Tabu_idx = [ ];
    BestImp = 0;
    
end
end