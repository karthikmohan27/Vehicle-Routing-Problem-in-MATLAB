%read a problem instance and return important variables from the file
function [Location, Demand, Capacity, OptimalValue] = read_vrp_file(filename)
        
        %open the file and associate a pointer
        filename = strcat("VRPFiles/",filename);
        fid = fopen( filename, 'r' );
        cac = textscan( fid, '%s', 'Delimiter', '\n' );
        
        %find the capacity, coordinates, optimal value and the demand
        isCapacity = ~cellfun('isempty',strfind(cac{1,1},'CAPACITY : '));
        [rowCapacity,col] = find(isCapacity);
        
        isNodeCoordHeader = ~cellfun('isempty',strfind(cac{1,1},"NODE_COORD_SECTION"));
        [rowNodeCoord,col] = find(isNodeCoordHeader);
        
        isDemandSectionHeader = ~cellfun('isempty',strfind(cac{1,1},"DEMAND_SECTION"));
        [rowDemand,col] = find(isDemandSectionHeader);
        
        isOptimalValue = ~cellfun('isempty',strfind(cac{1,1},'value: '));
        [rowOptimalValue,col] = find(isOptimalValue);
        
        %read the corresponding values
        Location = cac{1,1}(rowNodeCoord+1:rowDemand-1);
        Demand = cac{1,1}(rowDemand+1:end-4);
        Capacity = cac{1,1}(rowCapacity);
        OptimalValue = cac{1,1}(rowOptimalValue);
        
        n = size(Location,1);
        Location_mx = zeros(n,3);
        
       %ead the various values of Location and Demand into arrays
       for i = 1:n
           Location_mx(i,:) = str2num(Location{i});
       end
       
       Location = Location_mx(:,2:3);
       
       n = size(Demand,1);
       Demand_mx = zeros(n,2);
       
       for i = 1:n
           Demand_mx(i,:) = str2num(Demand{i});
       end
       
       Demand = Demand_mx(:,2);
       
       
       Capacity = strsplit(Capacity{1,1},' : ');
       Capacity = str2num(Capacity{1,2});
       
       OptimalValue = strsplit(OptimalValue{1,1},'value: ');
       OptimalValue = strsplit(OptimalValue{1,2},')');
       OptimalValue = str2num(OptimalValue{1,1});
       
       Location
       Demand
       Capacity
       OptimalValue
 end
