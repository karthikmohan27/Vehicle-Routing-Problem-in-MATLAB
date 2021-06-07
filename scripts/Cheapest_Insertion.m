function [Total_Distance,TSP]= Cheapest_Insertion(depot_index,clusters,Distance)

TSPType='Closed'

Nb_Nodes = size(clusters,2);

%Create an empty list referred to as 'TSP', that keeps track of the truck's path
TSP = [];

%Create a list called 'Unvisited_nodes' that keeps track of the nodes not visited by the truck (not in P).
Nb_Unvisited_Nodes = Nb_Nodes;
Unvisited_nodes = clusters;

% Initialize the path to the depot and change the index
Depot = depot_index;
TSP = Depot;

% remove the depot from the list of unvisited nodes
Unvisited_nodes(Unvisited_nodes == Depot) = [];
Nb_Unvisited_Nodes = Nb_Unvisited_Nodes - 1;

% Initialize the Total Distance to Zero
Total_Distance = 0;

% find the  closest nodes to the Depot
[M,nodeindex] = min(Distance(TSP, Unvisited_nodes));
node = Unvisited_nodes(nodeindex);

%create AN OPEN tour, called 'TSP'
 TSP = [Depot node];
 Tour_size = 2;
 Total_Distance = Total_Distance + M;

%create AN OPEN tour, called 'TSP'
%TSP = [Depot node];
%Tour_size = 2;
%Total_Distance = Total_Distance + Distance(TSP(end-1),node);   

% if the TSPType is closed TSP
%Join the first and last nodes of the TSP TO obtain a closed TSP tour.
if(isequal(TSPType,'Closed'))
    Total_Distance = Total_Distance + Distance(TSP(end),TSP(1));
    TSP=[TSP TSP(1)];
    Tour_size=3; 
end

% update the Unvisited_nodes & Nb_Unvisited_Nodes
Unvisited_nodes(nodeindex)=[];

Nb_Unvisited_Nodes = Nb_Unvisited_Nodes-1;

while(Nb_Unvisited_Nodes>0)
    
    % select the next node to insert
    MinInsertionCost=inf;
    for i=1:Nb_Unvisited_Nodes
        CurrentNode=Unvisited_nodes(i);
        
        %calculate inserting node in TSP tour
        for j=1:size(TSP,2)-1
            insertionCost=Distance(TSP(j),CurrentNode)+Distance(TSP(j+1),CurrentNode)-Distance(TSP(j),TSP(j+1));

            if(MinInsertionCost>insertionCost)
                nodeindex=i;
                node=CurrentNode;
                inspos=j+1;
                MinInsertionCost=insertionCost;
            end
        end
    end

    
    % insert the node in the tour
%     if(isequal(TSPType,'open'))
%         if(MinInsertionCost>Distance(TSP(Tour_size),node))
%             TSP=[TSP node];
%         else
%             TSP=InsertColumnInArray(TSP,inspos,node);
%         end
%     else
        TSP=InsertColumnInArray(TSP,inspos,node);
        Total_Distance=Total_Distance+MinInsertionCost;
%     end
    
    Unvisited_nodes(nodeindex)=[];
    Nb_Unvisited_Nodes=Nb_Unvisited_Nodes-1;
    
    Tour_size=Tour_size+1;     
end
