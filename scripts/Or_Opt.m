%this function performs or-opt with k = opt
function [node1,node2,node3,Improvement_in_Cost,Three_Opt_Type]= Or_Opt(TSP,Dis,opt)

Three_Opt_Type = 2;
Improvement_in_Cost=inf;
TSP_Size=size(TSP,2);

node1 = -1;
node2 = -1;
node3 = -1;

%find best possible improvement if it is feasible to perform or-opt
if(TSP_Size>4+opt)
% calculate the improvements acheived by all combination of 3-opt and pick the best amongst them
    for i=1:TSP_Size-opt-4
        for j=i+2:TSP_Size-opt-2
            k=j+1+opt;
            
            DelCost=Dis(TSP(i),TSP(i+1))+Dis(TSP(j),TSP(j+1))+Dis(TSP(k),TSP(k+1));
            temp_Imp_in_Cost = Dis(TSP(i),TSP(j+1))+Dis(TSP(k), TSP(i+1))+Dis(TSP(j), TSP(k+1))-DelCost;
            
            %if there is improvement in the best solution, replace
            if(temp_Imp_in_Cost< Improvement_in_Cost) 
                Improvement_in_Cost = temp_Imp_in_Cost;
                node1=i; 
                node2=j;
                node3=k;  
            end
        end
    end
else
    %if infeasible due to number of nodes, return 0 improvement in cost
    Improvement_in_Cost=0;
end
end