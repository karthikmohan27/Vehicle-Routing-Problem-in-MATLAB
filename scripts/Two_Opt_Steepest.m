%find best possible improvement
function [node1,node2,BestImp]= Two_Opt_Steepest(TSP,Dis)

node1 = -1;
node2 = -1;
BestImp=inf;
TSP_Size=size(TSP,2);
if(TSP_Size>=4)
    % calculate the improvements acheived by all combination of 2-opt and pick the best amongst them
    for i=1:TSP_Size-3 
        for j=i+2:TSP_Size-1 
            imp=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));
            if(imp>BestImp)
                   BestImp=imp;
                   node1=i;
                   node2=j;
            end
        end
    end
else
    BestImp = 0;
end
