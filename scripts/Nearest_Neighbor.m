function [Total_Distance,TSP]= Nearest_Neighbor(depot_index,clusters,Distance)

Nb_Nodes = size(clusters,2);

%Create an empty list referred to as 'TSP', that keeps track of the truck's path
TSP=[];

%Create a list called 'Unvisited_nodes' that keeps track of the nodes not visited by the truck (not in P).
Nb_Unvisited_Nodes = Nb_Nodes;
Unvisited_nodes = clusters;

% Initialize the path to the depot and change the index
Depot = depot_index;
TSP = Depot;

% remove the depot from the list of unvisited nodes
Unvisited_nodes(Unvisited_nodes==Depot) = [];
Nb_Unvisited_Nodes = Nb_Unvisited_Nodes-1; 

% Initialize the Total Distance to Zero
Total_Distance = 0;

%While Nb_Unvisited_Nodes_NN is not Zero; i.e there is an unvisited node(s) left, repeate the following process
while(Nb_Unvisited_Nodes~=0)
    %From the nodes not in the path  P, select the one, say j, closest to the last node in the path  
    [M,nodeindex] = min(Distance(TSP(end),Unvisited_nodes));
    
    %expand the current path by adding unvisited node j to P.
    TSP = [TSP,Unvisited_nodes(nodeindex)];
    
    % update Unvisited_nodes by removing node j
    Unvisited_nodes(nodeindex) = [];
    Nb_Unvisited_Nodes = Nb_Unvisited_Nodes - 1;
    
    % update the total Distance
    Total_Distance = Total_Distance+M;
   

  % end while
end

%Join the first and last nodes of the path P to obtain a closed TSP tour.
TSP = [TSP TSP(1)]
Total_Distance = Total_Distance + Distance(TSP(end-1),TSP(1));
Total_Distance


   