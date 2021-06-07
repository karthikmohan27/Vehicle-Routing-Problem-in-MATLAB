%find best possible improvement
function [node1,node2,BestImp]= Two_Opt_Per_Random(TSP,Dis)

%. Dis[i,j]+Dis[i+1, j+1]-Dis[i,i+1]-Dis[j,j+1];
node1 = -1;
node2 = -1;
BestImp=inf;

TSP_Size=size(TSP,2);
ctr=0;

if(TSP_Size>4)
    
    %calculate max by taking the combination of TSP_Size and 2
    max = nchoosek(TSP_Size,2);
    % calculate the improvements acheived by all combination of 2-opt and pick the best amongst them
    mat=int16.empty(100,0)
    
    while(ctr<max)
        i=randi([1,TSP_Size-3]);
        j=randi([i+2,TSP_Size-1]);
        imp=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));
        
        if(imp>BestImp)
            
               BestImp=imp;
               node1=i;
               node2=j;
         end
         ctr=ctr+1;
         mat(ctr,1)=imp;

    end
end
end

