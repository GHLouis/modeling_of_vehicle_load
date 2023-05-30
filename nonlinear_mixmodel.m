clc; clear
% 生成对数正态-正态混合分布样本数据
% rng(0); % 设置随机数种子
mu(1) = 0;
sigma(1) = 0.5;
mu(2) = 3;
sigma(2) = 1;
p = 0.4;
theta_true = zeros(3,2);
theta_true(1,:) = [0.4 0.6];

Name = {'lognormal';'normal'};
for i = 1:2
    pd = ERADist(Name{i,1},'PAR',[mu(i),sigma(i)]);
    theta_true(2,i) = mean(pd);
    theta_true(3,i) = std(pd);
end
disp(theta_true)

N = 5000; % 样本数量
x = [lognrnd(mu(1), sigma(1), round(p*N), 1); normrnd(mu(2), sigma(2), round((1-p)*N), 1)];
x = sort(x);
%%
close all

% 计算经验CDF
empirical_cdf = transpose((1:N)/(N+1));

Name = {'lognormal';'normal'};

% 定义误差函数，即估计CDF与经验CDF的误差的平方和
error_func = @(theta) norm(cdf_mixture(x, Name,theta) - empirical_cdf);

% 初始参数值
theta0 = make_initial_guess(x,Name);

% % 使用无约束法求解
% options = optimset('TolX',1e-6,'TolFun',1e-6);
% theta_hat = fminsearch(error_func, theta0, options);

% 使用有约束法求解
A = [0,1,0,0,-1,0];
b = 0;
Aeq = [];
beq = [];
lb = zeros(1,6);
ub = [1,inf,inf,1,inf,inf];
tic
theta_hat = fmincon(error_func,theta0,A,b,Aeq,beq,lb,ub);
toc

% 输出估计结果
mixmodel = struct;
k = length(Name);
% for i = 1:k
%     pd = ERADist(Name{i,1},'MOM',[theta_hat(3*i-1),theta_hat(3*i)]);
% end
% theta_hat = reshape(theta_hat,[3 k])
% 
% Param.NumComponents = k;
% Param.ComponentProportion = theta_hat(1,:);
% Param.mu = theta_hat(2,:);
% Param.Sigma = theta_hat(3,:);
% Param.NumOb = size(x,1);
% Param.Dim = size(x,2);
% Param.Distname = Name;



figure;
subplot(2,1,1);
histogram(x,'Normalization','pdf'); hold on;
ax = gca;
pts = linspace(ax.XLim(1),ax.XLim(2));
pts = pts(:);
ypdf = pdf_mixture(pts,Name,theta_hat);
ycdf = cdf_mixture(pts,Name,theta_hat);

plot(pts,ypdf, 'r', 'LineWidth', 2);
legend('True PDF', 'Estimated PDF');
xlabel('x'); ylabel('PDF');
title('Comparison of True and Estimated PDFs');

subplot(2,1,2);
plot(x, empirical_cdf, 'b--', 'LineWidth', 2); hold on;
plot(pts, ycdf, 'r', 'LineWidth', 2);
legend('True CDF', 'Estimated CDF');
xlabel('x'); ylabel('CDF');
title('Comparison of True and Estimated CDFs');

ycdf = cdf_mixture(x,Name,theta_hat);
kstest(x,"CDF",[x ycdf])
theta_hat = reshape(theta_hat,[3 k])
%%
function ycdf = cdf_mixture(x,Name,theta)
k = length(Name);
ycdf = zeros(size(x));
for i = 1:k
    pd = ERADist(Name{i,1},'MOM',[theta(3*i-1),theta(3*i)]);
    ycdf = ycdf + theta(3*i-2)*cdf(pd,x);
end
end

function ypdf = pdf_mixture(x,Name,theta)
k = length(Name);
ypdf = zeros(size(x));
for i = 1:k
    pd = ERADist(Name{i,1},'MOM',[theta(3*i-1),theta(3*i)]);
    ypdf = ypdf + theta(3*i-2)*pdf(pd,x);
end
end

function theta = make_initial_guess(x,Name)
% 混合分布的数量为K
k = length(Name);
theta = zeros(1,3*k);

idx = kmeans(x,k);
t = tabulate(idx);

for i = 1:k
    theta(3*i-2) = transpose(t(i,3)/100); % 初始化权重
    theta(3*i-1) = mean(x(idx==i)); % 初始化均值
    theta(3*i) = std(x(idx==i)); % 初始化标准差
end

end