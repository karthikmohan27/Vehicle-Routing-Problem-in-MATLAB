function [Total_Dis,NewTSP]= Nearest_Merger(depot_index,clusters,Distance,Location)

%given Location, coordinates of the nodes,(Or Dis Matrix) and Nb_Nodes, number of cities/nodes, find a tour using Insertion heuristic
Dis = Distance(clusters,clusters)
Nb_Nodes=size(clusters,2);

%%% Initialize the sub-tours to be merged
Subtours=cell( Nb_Nodes,1);

for i = 1:Nb_Nodes
    Subtours(i)={i};
end

Nb_Subtours=Nb_Nodes;

Subtours_Dist=Dis;
for S1 = 1:Nb_Subtours
    Subtours_Dist(S1,S1)=inf;
end

%%% Repeate until all subtours are merged
while Nb_Subtours~=1
    
    % Select the two closest sub-tours to merge, where two sub-tours, say S1 and S2?, qualify as the closest when the  Dis between any pair of nodes,
    % one belonging to S and the other belonging to S?, is minimal amongst all pairs of sub-tours (S, S?).
 
    % find two closest Subtours (S1,S2)
    [MIN_Diss,S] = min(Subtours_Dist);
    [MinMergingCost,S1] = min(MIN_Diss);
    S2=S(S1);
    
    %%% Merge S1 and S2
    
    s1_Size=size(Subtours{S1},2);
    s2_Size=size(Subtours{S2},2);
    %
    if(s1_Size==1 && s2_Size==1 ) % if both subtours have length of one
        NewSubtour=[Subtours{S1}(1) Subtours{S2}(1) Subtours{S1}(1)];
    else % if one subtour has length of one and the other has length of more than one
        if((s1_Size==1 && s2_Size~=1 )||(s1_Size~=1 && s2_Size==1 ))
            if(s2_Size~=1)
                S_Temp=S2;
                S2=S1; % subtour 2 is with lenght 1
                S1=S_Temp;
                
                S_Temp_Size= s1_Size;
                s1_Size=s2_Size;
                s2_Size=S_Temp_Size;
            end
            
            Cheapest_Merging_Cost=Inf;
            
            %%%
            for i=1:s1_Size-1
                % find the cheapeast insertion cost of S1 into S2 and Merge them
                Merging_Cost=Dis(Subtours{S1}(i),Subtours{S2}(1))+Dis(Subtours{S2}(1),Subtours{S1}(i+1))-Dis(Subtours{S1}(i),Subtours{S1}(i+1));
                
                if(Merging_Cost< Cheapest_Merging_Cost)
                    Cheapest_Merging_Cost=Merging_Cost;
                    Position_i=i;
                end
                
                
            end
            
            NewSubtour = [Subtours{S1}(1:Position_i) Subtours{S2}(1) Subtours{S1}(Position_i+1:end)];
            
        else % if both subtours have length of more than one
            %%% Merge S1 and S2
            
            Cheapest_Merging_Cost=Inf;
            % find cheapest merging cost of S1 and S2 by calculating all combinations of breaking an edge in each subtour and merging them
            for i=1:s1_Size-1
                for j=1:s2_Size-1
                    % calculate the breaking cost of edges 
                    % i & i+1 in S1 AND j  & j+1 in S2 should be broken
                    BreakingCost=Dis(Subtours{S1}(i),Subtours{S1}(i+1))+Dis(Subtours{S2}(j),Subtours{S2}(j+1));
                    % No Reversing
                    Merging_Cost1=Dis(Subtours{S1}(i),Subtours{S2}(j+1))+Dis(Subtours{S2}(j),Subtours{S1}(i+1))-BreakingCost;
                    
                    % Reversing
                    % i & j and i+1 & j+1 are the nodes to join
                    Merging_Cost2=Dis(Subtours{S1}(i),Subtours{S2}(j))+Dis(Subtours{S2}(j+1),Subtours{S1}(i+1))-BreakingCost;
                    
                    if(Merging_Cost1<= Merging_Cost2 && Merging_Cost1<Cheapest_Merging_Cost)
                        Reverse=false ;
                        Cheapest_Merging_Cost=Merging_Cost1;
                        Position_i=i;
                        Position_j=j;
                    else
                        if(Merging_Cost1> Merging_Cost2 && Merging_Cost2<Cheapest_Merging_Cost)
                            Reverse=true ;
                            Cheapest_Merging_Cost=Merging_Cost2;
                            Position_i=i;
                            Position_j=j;
                        end
                    end
                end
            end
            
            
            
            %%% merge two subtours given best merging option
            if(Reverse)
                NewSubtour = [Subtours{S1}(1:Position_i) fliplr( Subtours{S2}(1:Position_j)) fliplr(Subtours{S2}(Position_j+1:end-1)) Subtours{S1}(Position_i+1:end)];
                
            else
                NewSubtour = [Subtours{S1}(1:Position_i) Subtours{S2}(Position_j+1:end-1) Subtours{S2}(1:Position_j) Subtours{S1}(Position_i+1:end)];
            end
            
        end
        
        
    end
    
    %Update list of subtours
    if(S1>S2)
        % Update list of subtours by removing S1 and S2 from the list
        Subtours(S1,:) = [];
        Subtours(S2,:) = [];
        
        % Update the subtours Dis matrix
        % by deleting the row ans colomn corresponding to S1 & S2
        Subtours_Dist(S1, :) = [];
        Subtours_Dist(S2, :) = [];
        
        Subtours_Dist(:,S1) = [];
        Subtours_Dist(:,S2) = [];
        
    else
         % Update list of subtours by removing S1 and S2 from the list
        Subtours(S2,:) = [];
        Subtours(S1,:) = [];
        
         % Update the subtours Dis matrix
        % by deleting the row ans colomn corresponding to S1 & S2
        Subtours_Dist(S2, :) = [];
        Subtours_Dist(S1, :) = [];
        
        Subtours_Dist(:,S2) = [];
        Subtours_Dist(:,S1) = [];
    end
    
    
    % add the new subtour to list of subtours
    Subtours(end+1,:) = {NewSubtour};
    
    % update Nb_Subtours
    Nb_Subtours=Nb_Subtours-1;
    
     % Update the subtours Dis matrix by adding a row and column
     % corresponding to the new subtour at the end
     
    % add one row
    r=Inf(1,Nb_Subtours-1);
    Subtours_Dist=[Subtours_Dist;r];
    % add one column
    c=Inf(Nb_Subtours,1);
    Subtours_Dist=[Subtours_Dist,c];
    
    % calculate Dis between new subtour and the rest
    S1=Nb_Subtours;
    
    for S2 = 1:Nb_Subtours-1
        
        Min=min(Dis(Subtours{S1},Subtours{S2}));
        
        if(size(Min,2)>1 ||size(Min,1)>1 )
              Min=min(Min);
        end
        
        Subtours_Dist(S1,S2)=Min;
        Subtours_Dist(S2,S1)=Subtours_Dist(S1,S2);
    end
    


        


end

% Calculate the total cost of the TSP tour
TSP_Tour= Subtours{1};
Total_Dis = 0
for i=1:size(TSP_Tour,2)-1
    Total_Dis = Total_Dis + Dis(TSP_Tour(i),TSP_Tour(i+1))
end
% map


for i=1:size(TSP_Tour,2)
    TSP(i)=clusters(TSP_Tour(i))
end

for i=1:size(TSP_Tour,2)
    if(TSP(i)==depot_index)
        depot = i;
    end
end

for i=depot:size(TSP,2)
    NewTSP(i-depot+1) = TSP(i);
end

bleh = size(NewTSP,2);
for i=1:depot
    NewTSP(i+bleh-1) = TSP(i);
end
%depot_val = clusters(depot);

%TSP(1) = depot_val; 
%TSP_Tour(depot) = [];
%clusters(depot) = [];
%TSP_Tour(end) = [];
%%for i=1:size(TSP_Tour,2)
%    TSP(i+1)=clusters(TSP_Tour(i));
%end

%TSP(end) = depot_val;
%for i in (1:size(TSP_Tour,2))
%    new_TSP = TSP(i);
%end
end

