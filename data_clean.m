function data_cleaned = data_clean(data)
% 1. The difference between the measured Gross vehicle weight
% (GVW) and the sum of axle weights should be less than 10%.
% 2. GVW should be greater than 0.8 ton and less than 100 ton.
% 3. Vehicle length should be greater than 2 m and less than 36 m.
% 4. Each vehicle type has lower and upper bounds on vehicle
% length and GVW.
% 5. The smallest proportion of axle weight to GVW must
% exceed 5 percent.
% 6. Headway should be longer than 0.3 seconds.

% t = data(:,5);
% [~,b] = sort(t);
% data = data(b,:);

%% type
c = data(:,12); % class index
C = zeros(size(c));
fprintf('Data before cleaning: %d\n',size(data,1));
tabulate(c)
C(c==12 | c==13) = 1;
C(c==11) = 2;
C(c==0 | c==110) = 3;
C(c==1 | c==111) = 4;
C(c==3) = 5;
C(c==7) = 6;
C(c==10) = 7;
data(:,12) = C;

%% axle number
N = data(:,15); 

%% weight
% axle weight
AW = data(:,26:31)/100; 
AW(isnan(AW)) = 0;
SAW = sum(AW,2); % sum of axle weight
% gross vehicle weight
GVW = data(:,19)/100; 
AW(AW==0) = nan;
% smallest proportion of axle weight to GVW
mAWr = min(AW./GVW,[],2); 

%% length
% wheelbase
AS = data(:,46:50)/100; 
AS(isnan(AS)) = 0;
SAS = sum(AS,2); % sum of axle weight
% vehicle length
VL = data(:,14)/100;

%% time
% 车头headway
H = data(:,20)/1000; 

%% clean criteria
cc = zeros(size(data,1),1);

% weight
cc0 = (SAW-GVW)~=0; cc = cc | cc0;
cc0 = mAWr<0.05; cc = cc | cc0;

% cc0 = GVW<10; cc = cc | cc0;

% length
cc0 = VL-SAS < 1; cc = cc | cc0;
cc0 = VL./SAS > 3; cc = cc | cc0;
cc0 = VL<2 | VL>36; cc = cc | cc0;

cc0 = H<0.3; cc = cc | cc0;
cc0 = N>6; cc = cc | cc0;

% % GVW of car cannoe exceed 10 ton?
% cc0 = C==1 & GVW>50; cc = cc | cc0;

data(cc,:) = [];
data_cleaned = data;
fprintf('Data after cleaning: %d\n',size(data_cleaned,1));
tabulate(data_cleaned(:,12))
end

