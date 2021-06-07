%find best possible improvement
function [node1,node2,BestImp]= Two_Opt_Random(TSP,Dis)

node1 = -1;
node2 = -1;
BestImp=0;

TSP_Size=size(TSP,2);
% calculate the improvements acheived by all combination of 2-opt and pick the best amongst them
if(TSP_Size>4)
    i=randi([1,TSP_Size-3]);
    j=randi([i+2,TSP_Size-1]);
    BestImp=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));
    
    node1=i;
    node2=j;
    return
end


