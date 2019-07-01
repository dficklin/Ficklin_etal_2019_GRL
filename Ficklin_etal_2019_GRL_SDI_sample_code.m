%%%SAMPLE CODE FOR:
%%%%%A new perspective on terrestrial hydrologic intensity that incorporates atmospheric water demand 
%%%%Darren L. Ficklin, John T. Abatzoglou, Kimberly A. Novick

%%% For this example, the precipitation and reference evapotranspiration data is a 4-dimensional matrix where the first dimension is latitude, 
%%% the second dimension is longitude, the third dimension is the daily data, and the fourth dimension is years.
 
%variable names are precip_data and eto_data
 
for i = 1:39 %year
   for j = 1:65 %latitude
        for k = 1:192 %longitude

     pcp_pet = squeeze(precip_data(j,k,:,i)) - squeeze(eto_data(j,k,:,i)); %precipitation - eto for every grid node,day, and year
     pet_pcp = squeeze(eto_data(j,k,:,i))- squeeze(NN1_pcp(j,k,:,i)); %eto- precipitation for every grid node,day, and year

     SurINT_step1 =  pcp_pet; %define the first step to calculate SurINT
     SurINT_step1 (SurINT_step1 < 0) = NaN;  %remove all negative (or deficit values)
     SurINT(j,k,i) = nanmean(SurINT_step1); %calculate SurINT for each year
    
     DT_step1 = pet_pcp; %define the first step to calculate DT
     DT_step1(DT_step1> 0) = 0; % set the deficit values to zero
     f = find(diff([1,transpose(squeeze(DT_step1)),1]==0));%first the starting point and end point of each deficit time period within an indvidual year
     p = f(1:2:end-1);  % first the starting point each deficit time period within an individual year
     DT(j,k,i)= nanmean(f(2:2:end)-p); %takes the mean of the deficit time duration for each event for an individual year
        end
    end
end

SurINT_z= zscore(SurINT,[],3); %calculates z-score of SurINT for the entire time period
DT_z = zscore(DT,[],3);  %calculates z-score of DT for the entire time period

SDI_step1 = (DT_z+ SurINT_z); %top of Equation 1 
SDI = SDI_step1./std((DT_z+ SurINT_z),[],3);  %calculates SDI for the entire time period