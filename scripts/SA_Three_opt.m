function [BestCost, TSP] = SA_Three_opt(Location,Nb_Nodes,TSP,TSPCost,Dis,PlotTour,TSPType)
if(Nb_Nodes > 6)
    % Note that the initial feasible solution is TSP and the corresponding objective function
    % value is TSPCost
    % try
        % the neighborhood structure to use is
        % whole neighborhood of TSP, for its best neighbor using Two_Opt move
        TSP_Size=Nb_Nodes+1;
    %     if (PlotTour==1)
    %         I1=  figure (2) ;
    %         set(I1,'Name',[TSPType '- 3 opt SA' ])
    %         I2=  figure (5) ;
    %         set(I1,'Name',[TSPType '- Cost SA' ])
    %         sz = linspace(1,10,1);
    %     end

        Imp=-1;

        %Initialize iteration counter iter
        Temp=100;
        Alpha=0.97;
        MinTemp=0.00001;
        Max_R=400;
        iter=1;

        %Initialize  node1 & node2 to -1
        node1=-1;
        node2=-1;
        %Initialize BestCost to TSPCost
        BestCost=TSPCost;
        Cost=TSPCost;
    %     if (PlotTour)
    %         clf
    %         hold on
    %         set(I2,'Name',[TSPType '- Cost SA' ])
    %         title(['Temp ' int2str( Temp )]);
    %           scatter(iter,Cost,sz,'b');
    %         hold off
    %     end
    %     %REPEAT until stopping condition = true // e.g., (TSP is a local optimum [BestImp<0] )

        while(Temp>MinTemp)

            for r=1:Max_R
                % Generate a random neighbor of the current neighbor
                i=randi([1 TSP_Size-6]);
                j=i+2;
                k=j+2;
    %             try
    %                 %             if((rand()<0.5 && i>3)|| j+1>TSP_Size-3)
    %                 %
    %                 %               k=randi([1 i-1]);
    %                 %             else
    %                 %                k=randi([j+1 TSP_Size-1]);
    %                 %             end
    %                 
    %                 while((k+1>i)&& (j+1>k))
    %                     k=randi([1 TSP_Size-1]);
    %                 end
    %             catch ME
    %                 display(ME)
    %                 display(ME.stack(1))
    %                 display(ME.stack(1).line)
    %             end

                %Change in the objective function Delta =Z(x0)-Z(x)= (Improvement_in_Cost)
                % 2opt
                %         Improvement_in_Cost=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));




                DelCost=Dis(TSP(i),TSP(i+1))+Dis(TSP(j),TSP(j+1))+Dis(TSP(k),TSP(k+1));

                temp_Imp_in_Cost1 = Dis(TSP(i),TSP(k))+Dis(TSP(j+1), TSP(i+1))+Dis(TSP(j),TSP(k+1))-DelCost;
                temp_Imp_in_Cost2 = Dis(TSP(i),TSP(j+1))+Dis(TSP(k), TSP(i+1))+Dis(TSP(j), TSP(k+1))-DelCost;

                if (temp_Imp_in_Cost2<=temp_Imp_in_Cost1)
                    Improvement_in_Cost=temp_Imp_in_Cost2;
                    Three_Opt_Type=2;
                else
                    Improvement_in_Cost=temp_Imp_in_Cost1;
                    Three_Opt_Type=1;
                end

                Imp=round(Improvement_in_Cost,3);
                % if the BestImp is less than zero (i.e. a better neighbor is found
                % that improves the tour by Improvement_in_Cost, update the BestCost
                % and current neighbor TSP
                %if   Delta<0 OR RAND<  Acceptance Probability THEN // Update
                %current seed solution x0
                RND=rand();
                APF=exp(-Imp/Temp);
                if(Imp<=0 || RND< APF)

                    [NewCost, NewTSP]=  Perform_3OptMove(TSP,TSP_Size,Dis, i,j,k,Three_Opt_Type);
                    TSP=NewTSP;
                    Cost=Cost+Imp;
                    if(NewCost~=Cost)
                        Imp
                    end
                    if(BestCost > Cost)


                        BestCost = Cost;
                        BestTSP=NewTSP;


                        TSP=BestTSP;

                        %             else
                        %  [num2str(  APF ) "  "  num2str(Imp)]
                    end
                end

            end
            Temp=Temp*Alpha;
             if (PlotTour)
                        iter=iter+1;
                        hold on
                        set(I2,'Name',[TSPType '-  SA Temp' ])
                        title(['Temp ' int2str( Temp ) '   Best Cost ' int2str( BestCost )]);
                        hold off
                        pause(0.0001)
                    end
        end
    % catch ME
    %     display(ME)
    %     display(ME.stack(1))
    %     display(ME.stack(1).line)
    % end
else
    BestCost = TSPCost;
end
