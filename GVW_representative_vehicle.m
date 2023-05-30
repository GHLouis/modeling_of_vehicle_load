% close all;clc
try load([probname,'GVWdata.mat'])
catch 
    fprintf('no such data, read data instead\n')
    data = [];
    for j = 1:2 % Direction
        for k = (j-1)*3 + (1:3) % Lane
            for i = 1:day % DAY
                load([probname,'_Day_',num2str(i),'_Dr_',num2str(j),'_Lane_',num2str(k),'.mat']);
                data = [data; Day_Dr_Lane];
            end
        end
    end
    save([probname,'GVWdata.mat'],'data')
end

% data clean
num_new = data_clean(data);

% extract GVW data
TYPE = {'car','bus','2-axle truck','3-axle truck','4-axle truck','5-axle truck','6-axle truck'};
c = num_new(:,12); % class index
w = num_new(:,19)/100; % total weight,unit kN
L = num_new(:,14)/100;
% for i = 1:7
%     figure;scatterhist(L(c==i),w(c==i),'Marker','.','Color',[0.65 0.65 0.65])
%     xlabel('Length (m)')
%     ylabel('Gross vehicle weight (kN)')
%     title(TYPE{i})
% end
%% fit GVW by GMM
% optimal_commom_dist_new(w(c==1))
gm_model = cell(7,1);
for m = 1:7
    % gm_model{m,1} = mixmodel(w(c==m),2);
    % gm_model{m,1}
    gm_model{m,1} = gmfit_best(w(c==m));
    xlabel(gcf().Children(2),'Gross vehicle weight (kN)')
    xlabel(gcf().Children(4),'Gross vehicle weight (kN)')

    % p_name = [probname,' '];
    % c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' GVW',' class ',num2str(m)];
    % saveas(gcf,[figpath,p_name,c_name,'.png'])
    % savefig(gcf,[figpath, p_name, c_name],'compact')
    % matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
end
p_name = [probname,'_'];
save([p_name,'GVW fitting.mat'],'gm_model');
%%
x = num_new(:,46:50)/100;
% x = sort(x);
WS = zeros(7,5);
for i = 1:7
    if i<=3
        WS(i,1) = round(mean(x(c==i,1)),1);
    else
        WS(i,1:i-2) = round(mean(x(c==i,1:i-2)),1);
    end
end

x = num_new(:,26:31)/100;
AW = zeros(7,6);
AWR = zeros(7,6);
for i = 1:7
    if i<=3
        AW(i,1:2) = round(power(mean(power(x(c==i,1:2),3)),1/3),1);
    else
        AW(i,1:i-1) = round(power(mean(power(x(c==i,1:i-1),3)),1/3),1);
    end
    AWR(i,:) = round(AW(i,:)./sum(AW(i,:)),2);
end

%% 
% 写入texfile

TYPE = {'car','bus','2-axle truck','3-axle truck','4-axle truck','5-axle truck','6-axle truck'};
filename = ['../doc\',probname,' representative vehicle.tex'];
fid = fopen(filename, 'w','n','UTF-8');
fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\caption{Proportion of axle weight of representative vehicle}\n');
fprintf(fid, '\\begin{tabular}{ccccccc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Vehicle class & axle 1 & axle 2 & axle 3 & axle 4 & axle 5 & axle 6\\tabularnewline\n');
fprintf(fid, '\\midrule\n');
for i = 1:7
    fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f\\tabularnewline\n',TYPE{i},AWR(i,1),AWR(i,2),AWR(i,3),AWR(i,4),AWR(i,5),AWR(i,6));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\end{table}\n\n');

fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\caption{Wheelbase of representative vehicle (m)}\n');
fprintf(fid, '\\begin{tabular}{cccccc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Vehicle class & axle 1-2 & axle 2-3 & axle 3-4 & axle 4-5 & axle 5-6\\tabularnewline\n');
fprintf(fid, '\\midrule\n');
for i = 1:7
    fprintf(fid, '%s & %.1f & %.1f & %.1f & %.1f & %.1f \\tabularnewline\n',TYPE{i},WS(i,1),WS(i,2),WS(i,3),WS(i,4),WS(i,5));
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\end{table}\n\n');

fclose(fid);

% 读取tex文件内容
fid = fopen(filename,'r');
content = fscanf(fid,'%c');
fclose(fid);

% 替换0.00为-
new_content = strrep(content,'0.00','-');

% 替换0.0为-
new_content = strrep(new_content,'0.0','-');

% 将新内容写回文件
fid = fopen(filename,'w');
fprintf(fid,'%s',new_content);
fclose(fid);