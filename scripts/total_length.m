%this function returns the total length of the TSP
function [cost] = total_length(TSP,len,Dis)
for i = 1:len-1
    cost = Dis(TSP(i),TSP(i+1));
end
end