%main function

%assign the directory where the test files are stored
dinfo = dir('/../assets');
allfiles = {dinfo.name};
nb_files = size(allfiles,2);
filename = {};

%read the filenames into an array of strings
for n = 1:nb_files-3
    filename{n} = allfiles{1,n+3};
end

%initialize the counter in order to implement the algorithms
ctr = 1;
cell_location = 1;
while(ctr <= nb_files - 3)

t = zeros(1,10);
file_name = filename{ctr};

%obtain the values of the file from the read_vrp_file function
[Location, Demand, Capacity, OptimalValue] = read_vrp_file(file_name);

%calculate the initial distance matrix
Dis = pdist2(Location,Location);
tic

%perform the clustering after removing the depot, within the function
[centroids, clusters, cluster_capacity, depot_location, t_clust, Nb_nodes, k] = create_clusters(Location, Demand, Capacity);

%reinsert the depot into the different structures we have
depot_index = Nb_nodes + 1;
Location(1,:) = [];
Demand(1,:) = [];
Demand(depot_index,:) = 0;
Location(depot_index,:) = depot_location;
Distance = pdist2(Location, Location);

%run the construction heuristics
[VRP, VRP_dis_mx, CDIS, TSP, CH_time] = Construction_Heuristics(k,depot_index, Distance, Location, clusters);
toc

VRP_dis_mx = sum(VRP_dis_mx);
VRP_time = sum(CH_time);
VRP_time = round(VRP_time,2);
[Min_VRP_Cost,VRP_ID_for_MH] = max(VRP_dis_mx);

%initialize the CLS timer to implement CLS
time_CLS = 0;
tic
[VRP_CLS, VRP_dis_mx_CLS] = CLS(k,Distance,VRP,CDIS,Capacity,cluster_capacity,Demand);

%performance measures for performance of the CLS
time_CLS = toc;
VRP_dis_mx_CLS = sum(VRP_dis_mx_CLS);
Min_VRP_Cost_CLS = min(VRP_dis_mx_CLS);

%implementing the MetaHeuristics
VRP_for_MH = VRP(:,VRP_ID_for_MH);
tic

Cost_TS = 0;
Cost_VNS = 0;
Cost_SA = 0;

TSP_Cost_MH = {};
%run for all clusters

time_SA = zeros(1,k);
time_VNS = zeros(1,k);
time_TS = zeros(1,k);

for l = 1:k
    %extract the TSPs from the best VRP
    TSP_MH = VRP_for_MH{l,:};
    Dist = Distance(TSP_MH,TSP_MH);
    TSP_Cost_MH{l} = 0;
    for i = 1:size(TSP_MH,2)-1
        TSP_Cost_MH{l} = Dist(i,i+1) + TSP_Cost_MH{l};
    end
    TSP_Cost_int = TSP_Cost_MH{l} ;
    Nb_nodes = size(TSP_MH,2);
    %initialize empty TSP to hold the improved TSP
    TSP = [];

    tic
    [Best_Cost, TSP] = SA_Three_opt(Location, Nb_nodes, TSP_MH,TSP_Cost_int,Distance,0,'closed');
    time_SA(l) = toc
    
    tic
    [Best_Cost_TS, TSP_TS] = Two_opt_TS(Location,Nb_nodes,TSP_MH,TSP_Cost_int,Distance,0,'closed');
    time_TS(l) = toc
    
    tic
    [TSP_VNS,Best_Cost_VNS] = VNS_TSP_final(TSP_MH,TSP_Cost_int,Distance);
    time_VNS(l) = toc
    
    Cost_VNS = Cost_VNS+Best_Cost_VNS;
    Cost_TS = Cost_TS+Best_Cost_TS;
    Cost_SA = Cost_SA+Best_Cost;
    
    %store the results for posterity
    improved_tour_SA{l} = TSP;
    improved_tour_TS{l} = TSP_TS;
    improved_tour_VNS{l} = TSP_VNS;
    improved_cost_SA{l} = 0;
    improved_cost_TS{l}=0;
    improved_cost_VNS{l}=0;
    TSP_imp_SA = TSP;
    TSP_imp_TS = TSP_TS;
    TSP_imp_VNS = TSP_VNS;
    TSP_imp_SA(end) = [];
    TSP_imp_TS(end) = [];
    TSP_imp_VNS(end)=[];
    Dist_test = Distance(TSP_imp_SA,TSP_imp_SA);
    Dist_test_TS = Distance(TSP_imp_TS,TSP_imp_TS);
    Dist_test_VNS = Distance(TSP_imp_VNS,TSP_imp_VNS);
    
  % end
end


%calculate increase over optimum for all the various heuristics using
% improved_cost_TS_sum - OptimalValue)/OptimalValue * 100
inc_opt_SA = (Cost_SA - OptimalValue)/OptimalValue*100
inc_opt_TS = (Cost_TS - OptimalValue)/OptimalValue*100
inc_opt_VNS = (Cost_VNS - OptimalValue)/OptimalValue*100
inc_opt_CLS = (Min_VRP_Cost_CLS - OptimalValue)/OptimalValue*100

%save the file name for inputting into the excel table
problem_instance = file_name;

%writing the values into an excel file
f = 'updated_output_file_KM_5.xlsx';

cell_string_problem = sprintf('A%d',cell_location+1);
cell_string_values  = sprintf('B%d',cell_location+1);
xlswrite(f,[{problem_instance}],'Cost',cell_string_problem);

xlswrite(f,[Cost_SA],'Cost',sprintf('B%d',cell_location+1));
xlswrite(f,[inc_opt_SA],'Cost',sprintf('C%d',cell_location+1));
xlswrite(f,[time_SA],'Cost',sprintf('D%d',cell_location+1));

xlswrite(f,[Cost_TS],'Cost',sprintf('E%d',cell_location+1));
xlswrite(f,[inc_opt_TS],'Cost',sprintf('F%d',cell_location+1));
xlswrite(f,[time_TS],'Cost',sprintf('G%d',cell_location+1));

xlswrite(f,[Cost_VNS],'Cost',sprintf('H%d',cell_location+1));
xlswrite(f,[inc_opt_VNS],'Cost',sprintf('I%d',cell_location+1));
xlswrite(f,[time_VNS],'Cost',sprintf('J%d',cell_location+1));

xlswrite(f,[Min_VRP_Cost_CLS],'Cost',sprintf('K%d',cell_location+1));
xlswrite(f,[inc_opt_CLS],'Cost',sprintf('L%d',cell_location+1));
xlswrite(f,[time_CLS],'Cost',sprintf('M%d',cell_location+1));

xlswrite(f,[Min_VRP_Cost],'Cost',sprintf('N%d',cell_location+1));

xlswrite(f,[VRP_dis_mx],'Cost',sprintf('O%d',cell_location+1));
xlswrite(f,[sum(CH_time)],'Cost',sprintf('U%d',cell_location+1));

xlswrite(f,[OptimalValue],'Cost',sprintf('AA%d',cell_location+1));

cell_location = cell_location + 1;
ctr = ctr + 1;

end