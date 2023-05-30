close all
clear
clc
k=1;
T = xlsread('D:\texlive\lyxworks\MSSP\文献参数\杨晓艳轴重参数1.xlsx');
[row,col]=size(T);
N=row/3; %查看车型数目
% pd{i,j}表示车道i的车型j的轴重参数
pd=cell(3,N);
for i=1:3
    for j=1:N
        A=T(N*(i-1)+j,:);
        B=A(~isnan(A));
        pd{i,j}=reshape(B,[3 length(B)/3]);
    end
end
%%
n=1e4;
i = 1;
for j=2
    para=pd{i,j};
    p=para(1,:);
    mu=para(2,:);
    sigma=para(3,:);
    X=mlnrnd(p,mu,sigma,n);
    histogram(X,'Normalization','pdf')
    xlabel('Vehicle weight/ t')
    ylabel('PDF')
end
%%
% 采用期望最大算法估计对数正态-正态混合分布的参数

% 原始数据
data = X;

% 混合分布的数量，至少包含一个对数正态分布
num_mix = 2;
num_lognorm = 1;
num_norm = num_mix - num_lognorm;

% 初始化参数
mu = randn(1, num_mix);
sigma = abs(randn(1, num_mix));
p = ones(1, num_mix) / num_mix;

% 迭代次数和精度
max_iter = 100;
tol = 1e-6;

for iter = 1:max_iter
    % E 步骤
    logpdf_lognorm = log(lognpdf(data, mu(1), sigma(1))); % 对数正态分布
    logpdf_norm = log(normpdf(data, mu(2:end), sigma(2:end))); % 正态分布
    log_likelihood = logpdf_lognorm + sum(logpdf_norm, 2); % 对数似然函数
    p_cond = bsxfun(@times, exp(logpdf_norm), p(2:end)); % 条件概率
    p_cond = bsxfun(@rdivide, p_cond, sum(p_cond, 2)); % 归一化
    
    % M 步骤
    p = [mean(exp(logpdf_lognorm)), sum(p_cond, 1)] / length(data); % 混合比例
    mu(1) = log(mean(exp(log(data)))) - 0.5 * mean(sigma.^2 + mu.^2); % 对数正态分布均值
    mu(2:end) = sum(bsxfun(@times, p_cond, data), 1) ./ sum(p_cond, 1); % 正态分布均值
    sigma(1) = sqrt(mean((log(data) - mu(1)).^2)); % 对数正态分布标准差
    sigma(2:end) = sqrt(sum(bsxfun(@times, p_cond, (data - mu(2:end)).^2), 1) ./ sum(p_cond, 1)); % 正态分布标准差
    
    % 判断收敛
    log_likelihood_new = log_likelihood' * p';
    if abs(log_likelihood_new - log_likelihood_old) < tol
        break;
    end
    log_likelihood_old = log_likelihood_new;
end

% 绘制 PDF 对比图和 CDF 对比图
x = linspace(min(data), max(data), 100);
pdf_mix = p(1) * lognpdf(x, mu(1), sigma(1));
for i = 1:num_norm
    pdf_mix = pdf_mix + p(i+1) * normpdf(x, mu(i+1), sigma(i+1));
end
cdf_mix = cumsum(pdf_mix) / sum(pdf_mix);

figure;
histogram(data, 'Normalization', 'pdf');
hold on;
plot(x, pdf_mix, 'LineWidth', 2);
xlabel('Data');
ylabel('PDF');
legend('Histogram', 'Mixture Distribution');

figure;
plot(sort(data), linspace(0, 1, length(data)), 'LineWidth', 2);
hold on;
plot(x, cdf_mix, 'LineWidth', 2);
xlabel('Data');
ylabel('CDF');
legend('Empirical CDF', 'Mixture CDF');