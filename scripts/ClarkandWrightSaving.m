function [Total_Distance,Tour] = ClarkandWrightSaving(Location,Dis,n,Depot,clusters)
% Initialize the sub-tours to be merged
% A list can be empty:
Subtours={};

% Create an back and forth subtour to the depot

for i = clusters
    if(i~=Depot)
        Subtour=[Depot i Depot];
        Subtours(end+1,:) =  {Subtour};
    end
end

% Access Data in Cell Array
% https://uk.mathworks.com/help/matlab/matlab_prog/access-data-in-a-cell-array.html
Nb_Subtours=size(Subtours,1);


% calculate the savings obtained from merging two subtours
Savings_matrix=zeros(Nb_Subtours,Nb_Subtours);
for S1 = 1:Nb_Subtours
    for S2 = 1:Nb_Subtours
        if(S1~=S2)
            % i & i+1 in S1 AND j  & j+1 in S2 should be broken
            Savings_matrix(S1,S2)=Dis(Subtours{S1}(2),Subtours{S1}(3))+Dis(Subtours{S2}(1),Subtours{S2}(2))-Dis(Subtours{S1}(2),Subtours{S2}(2));
        end
    end
    
end


while Nb_Subtours(1)~=1
    % Select the two sub-tours with maximum savings, where two sub-tours, say S and S�, qualify as the closest when the  distance between any pair of nodes,
    % one belonging to S and the other belonging to S�, is minimal amongst all pairs of sub-tours (S, S�).
    
    % find two Subtours with Maximum saving (S1,S2)
    maxSaving=0;
    for s1 = 1:Nb_Subtours
        
        [MAX,s2] = max(Savings_matrix(s1,:));
        if(maxSaving<MAX)
            
            S1=s1;
            S2=s2;
            maxSaving=MAX;
        end
    end
    
    % Merge S and S'
    NewSubtour=[Subtours{S1}(1:end-1) Subtours{S2}(2:end)];
    % Update list of subtours and savings
    if(S1>S2)
        % Update list of subtours
        Subtours(S1,:) = [];
        Subtours(S2,:) = [];
        
        % Update list of  savings
        Savings_matrix(S1, :) = [];
        Savings_matrix(S2, :) = [];
        
        Savings_matrix(:,S1) = [];
        Savings_matrix(:,S2) = [];
        
    else if(S1<S2)
            % Update list of subtours
            Subtours(S2,:) = [];
            Subtours(S1,:) = [];
        
            % Update list of  savings
            Savings_matrix(S2, :) = [];
            Savings_matrix(S1, :) = [];
        
            Savings_matrix(:,S2) = [];
            Savings_matrix(:,S1) = [];
        else
            %Update list of subtours
            Subtours(S1,:) = [];
            Subtours(S1-1,:)=[];
            
            % Update list of  savings
            Savings_matrix(S2, :) = [];
            Savings_matrix(S2-1, :) = [];
        
            Savings_matrix(:,S2) = [];
            Savings_matrix(:,S2-1) = [];
        end
    end
    
    Subtours(end+1,:) = {NewSubtour};
    Nb_Subtours=Nb_Subtours-1;
    r=zeros(1,Nb_Subtours-1);
    Savings_matrix=[Savings_matrix;r];% add one row
    
    c=zeros(Nb_Subtours,1);
    Savings_matrix=[Savings_matrix,c];% add one column
    
    % calculate savings for new subtour and the rest
    
    S1=Nb_Subtours;
    for S2 = 1:Nb_Subtours
        if(S1~=S2)
            % i & i+1 in S1 AND j  & j+1 in S2 should be broken
            Savings_matrix(S1,S2)=Dis(Subtours{S1}(end-1),Subtours{S1}(end))+Dis(Subtours{S2}(1),Subtours{S2}(2))-Dis(Subtours{S1}(end-1),Subtours{S2}(2));
            Savings_matrix(S2,S1)=Dis(Subtours{S2}(end-1),Subtours{S2}(end))+Dis(Subtours{S1}(1),Subtours{S1}(2))-Dis(Subtours{S2}(end-1),Subtours{S1}(2));
        end
        
    end
    
    

  %  start(t2);
  %  wait(t2);
    
    
end

% Output : calculate the tour cost 
x=Location( Subtours{1},1);
y=Location( Subtours{1},2);

L = sqrt(diff(x).^2 + diff(y).^2);
Total_Distance = sum(L);

Tour=Subtours{1};
end
%end

