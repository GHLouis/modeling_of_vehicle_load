clear;close all;clc
figpath = 'figures\';
probname = 'GS GVW fit';
%% GS
close all;clc
for i = 1:6
filename = ['GS-2009-1-',num2str(i),'.mat'];
load(filename)
x = txt(2:end,13);
tabulate(x)
y = num(:,12);
tabulate(y)
end
%% 提取车重数据
clc
% clean data
num_new = data_clean(num);
c = num_new(:,12); % class index
w = num_new(:,19)/100; % total weight,unit kN
%% 拟合车重分布
close all
gm_model = cell(7,1);
for i = 1:7
    gm_model{i,1} = gmfit_best(w(c==i));
    p_name = [probname,'_'];
    c_name=['class ',num2str(i),' vehicle'];

    matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false)
    % exportgraphics(gcf,[figpath,p_name,c_name,'.png'])
    % exportgraphics(gcf,[figpath,p_name,c_name,'.pdf'])
    saveas(gcf,[figpath,p_name,c_name,'.png'])
    savefig(gcf,[figpath, p_name, c_name],'compact')
end
% 写入texfile
probname = 'GS gmmdist para';
fid = fopen([probname,'.tex'], 'w');
fprintf(fid, '\\documentclass{article}\n');
fprintf(fid, '\\usepackage{booktabs}\n');
fprintf(fid, '\\begin{document}\n');
fprintf(fid, '\\begin{table}[tbph]\n');
fprintf(fid, '\\caption{Fitting Curve Parameters of GVW Data(unit: kN)}\n');
fprintf(fid, '\\begin{centering}\n');
fprintf(fid, '\\begin{tabular}{ccccc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Vehicle class & Peak & Probability & $\\mu$ & $\\sigma$ \\tabularnewline\n');
fprintf(fid, '\\midrule\n');

for i = 1:7
    k = gm_model{i, 1}.NumComponents;
    p = gm_model{i, 1}.ComponentProportion;
    mu = gm_model{i, 1}.mu;
    sigma = sqrt(gm_model{i, 1}.Sigma(:));
    [mu, idx]= sort(mu);
    p = p(idx);
    sigma = sigma(idx);
    for j = 1:k
        fprintf(fid, 'class %d vehicle & %d & %.2f & %.2f & %.2f \\tabularnewline\n',i, j,p(j),mu(j),sigma(j));
    end
end

fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\par\\end{centering}\n');
fprintf(fid, '\\end{table}\n\n');
fprintf(fid, '\\end{document}\n');
fclose(fid);