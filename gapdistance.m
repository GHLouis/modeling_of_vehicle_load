% load([probname,'_Day_',num2str(1),'_Dr_',num2str(1),'_Lane_',num2str(2),'.mat']);
% traffic ratio and vehicle ratio
t = Day_Dr_Lane(:,5)*24; % time
dt = diff(t)*3600;
c = VCT(Day_Dr_Lane(:,12)); % vehicle class
tbl = tabulate(c);

T = ceil(t);
tabulate(T)

% extract vehicle gap distance
vd = Day_Dr_Lane(2:end,21)/100; % vehicle distance

v = Day_Dr_Lane(2:end,10)/3.6; % vehicle speed
h1 = Day_Dr_Lane(2:end,20)/1000; % headway
h2 = Day_Dr_Lane(2:end,22)/1000; % gap
L = Day_Dr_Lane(1:end-1,14)/100; % vehicle length
%%
close all;clc
t = Day_Dr_Lane(:,5)*24; % time
h = Day_Dr_Lane(:,20)/1000; % headway
q = zeros(24,1);
mu = zeros(24,1);
sigma = zeros(24,1);
% q = zeros(24,1);
% k = zeros(24,1);
% v_hat = zeros(24,1);
k = zeros(24,1);
for i = 1:24
    t0 = t(T==i);
    dt = h(T==i);
%     dt0 = diff(t0)*3600;
    v = Day_Dr_Lane(T==i,10)/3.6; % vehicle speed
    %     q(i) = size(t0,1);
    %     v_hat(i) = mean(v)*3.6;
    %     k(i) = q(i) / v(i);
    %     dx_hat = 1000/k;
    L = Day_Dr_Lane(T==i,14)/100; % vehicle length
    dx = dt(2:end) .* v(1:end-1) - L(1:end-1);
    dx(dt(2:end)>=600) = [];
    dx(dx<0) = [];
    mu(i) = mean(dx);
    sigma(i) = std(dx);
    q(i) = size(t0,1);
    
%     figure
%     hold on
%     histogram(dx,'Normalization','pdf');
%     ksdensity(dx)
    

    DistName = {'weibull';'lognormal'};
    % ,'display',false
    % dist = optimal_commom_dist_new(dx,DistName);
    [dist, tb] = optimal_commom_dist_new(dx); 

    xlabel(gcf().Children(2),'Vehicle gap distance (m)')
    xlabel(gcf().Children(4),'Vehicle gap distance (m)')
    mean(dist.opdist)    

%     fprintf('%d, traffic volume is %d\n',i,q(i))
%     fprintf('optimal dist is %s\n',dist.opdist.DistributionName)
%     if strcmp(dist.opdist.DistributionName, 'Lognormal')
%         k(i) = 1;
%     end
end
% disp(sum(k)/24 *100)

% figure
% subplot(1,3,1)
% hold on
% plot(q,v_hat,'o')
% 
% subplot(1,3,2)
% hold on
% plot(q,k,'o')
% 
% subplot(1,3,3)
% hold on
% plot(k,v_hat ,'o')
%%
% figure
% plot(q,mu,'.')
% hold on
% plot(q,sigma,'.')
% c = sigma./mu;
% figure
% plot(q,c)
%%
% figure
% hold on
% plot(q,mu,'o')
% Eqn = 'a/x';
% st = mean(q)*mean(mu);
% [f,gof] = fit(q,mu,Eqn,'Start', st);
% plot(f)
% xlabel('Traffic volume (veh /h)','Interpreter','latex')
% ylabel('Mean of vehicle gap distance (m)','Interpreter','latex')
% box('on')
% 
% 
% figure
% hold on
% plot(1./q,mu,'o')
% Eqn = 'a*x';
% st = mean(q)*mean(mu);
% [f,gof] = fit(1./q,mu,Eqn,'Start', st);
% plot(f)
% xlabel('Inverse of traffic volume (h /veh)','Interpreter','latex')
% ylabel('Mean of vehicle gap distance (m)','Interpreter','latex')
% box('on')
% figure_size = [];
% adjfig