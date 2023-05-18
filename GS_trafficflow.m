% 先把GS的做好再说其他的
clear;close all;clc
figpath = 'figures\';
probname = 'GS';
%% GS
T_all = zeros(6,7);
for j = 1:2 % Direction
    for k = (j-1)*3 + (1:3) % Lane
        close all
        vd = [];
        data = [];
        % hour by hour
        T = zeros(24,7,7);
        for i = 1:6 % DAY
            load([probname,'_Day_',num2str(i),'_Dr_',num2str(j),'_Lane_',num2str(k),'.mat']);

            % traffic ratio and vehicle ratio
            t = Day_Dr_Lane(:,5)*24; % time
            c = VCT(Day_Dr_Lane(:,12)); % vehicle class
            tbl = tabulate(c);

            t = ceil(t);
            tabulate(t)

            for n = 1:24
                T(n,:,i) = sum(c(t==n)==1:7);
                tabulate(c(t==n))
            end

            % extract vehicle gap distance
            vd = [vd; Day_Dr_Lane(:,21)/100]; % vehicle distance

            % extract class and GVW
            data = [data;Day_Dr_Lane];
        end

        T = sum(T,3);
        q = sum(T,2)./sum(T(:));
        cls = T./sum(T,2);
        AADT = round(sum(T(:))/6);

        T_all(k,:) = sum(T);



        figure;plot(100*q,'o-','linewidth',1)
        xlabel('Time (hour)');
        ylabel('Percent of traffic volume (\%)','Interpreter','latex');
        xticks(0:2:24)

        p_name = [probname,' '];
        c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' traffic ratio'];
        matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
        saveas(gcf,[figpath,p_name,c_name,'.png'])
        savefig(gcf,[figpath, p_name, c_name],'compact')

        figure;plot(100*cls,'linewidth',1)
        legend({'car','bus','2-axle truck','3-axle truck','4-axle truck','5-axle truck','6-axle truck'},'location','best','NumColumns',2)
        %         legend({'小客车','大客车','2轴货车','3轴货车','4轴货车','5轴货车','6轴货车'},'location','best','NumColumns',2)
        xlabel('Time (hour)');
        ylabel('Percent of vehicles (\%)','Interpreter','latex');
        xticks(0:2:24)

        p_name = [probname,' '];
        c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' vehicle ratio'];
        matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
        saveas(gcf,[figpath,p_name,c_name,'.png'])
        savefig(gcf,[figpath, p_name, c_name],'compact')

        % fit vehicle gap distance by truncated gaussian
        vd(vd>=100) = [];
        pdd = fittrunc(vd,'Normal',0,100);

        p_name = [probname,' '];
        c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' vehicle gap'];
        matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
        saveas(gcf,[figpath,p_name,c_name,'.png'])
        savefig(gcf,[figpath, p_name, c_name],'compact')

        % v = Day_Dr_Lane(:,10)/3.6; % speed
        % h = Day_Dr_Lane(:,20)/1000; % headway(车头)
        % h0 = diff(Day_Dr_Lane(:,5))*24*3600;
        % vL = Day_Dr_Lane(:,14)/100; % vehicle length
        % % x = v.*h - vL;
        % vd = Day_Dr_Lane(:,21)/100; % vehicle distance
        % % x(vd==100) = [];
        % vd(vd>=100) = [];
        % % vd(x>=100) = [];
        % % x(x>=100) = [];
        % % fit vds by truncated gaussian
        % pdd = fittrunc(vd,'Normal',0,100);
        % fit GVW by GMM
        % Data clean
        num_new = data_clean(data);
        % extract GVW data
        c = num_new(:,12); % class index
        w = num_new(:,19)/100; % total weight,unit kN

        % 拟合车重分布
        %         close all
        gm_model = cell(7,1);
        for m = 1:7
            gm_model{m,1} = gmfit_best(w(c==m));
            p_name = [probname,' '];
            c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' GVW',' class ',num2str(m)];

            matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
            saveas(gcf,[figpath,p_name,c_name,'.png'])
            savefig(gcf,[figpath, p_name, c_name],'compact')
        end

        p_name = [probname,'_'];
        save([p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k),'.mat'],'AADT','q','cls','pdd','gm_model');
    end
end

for j = 1:2
    X = categorical({['Lane ',num2str((j-1)*3 + 1)],...
        ['Lane ',num2str((j-1)*3 + 2)],...
        ['Lane ',num2str((j-1)*3 + 3)]});
    X = reordercats(X,{['Lane ',num2str((j-1)*3 + 1)],...
        ['Lane ',num2str((j-1)*3 + 2)],...
        ['Lane ',num2str((j-1)*3 + 3)]});
    figure;bar(X,transpose(T_all((j-1)*3 + (1:3),:)),'DisplayName','T')
    ylabel('Proportion of vehicle types (\%)','Interpreter','latex')
    legend({'car','bus','2-axle truck','3-axle truck','4-axle truck','5-axle truck','6-axle truck'})
    figure_size = []; adjfig

    p_name = [probname,' '];
    c_name = ['Dr ',num2str(j),' Proportion of vehicle types'];
    % matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
    saveas(gcf,[figpath,p_name,c_name,'.png'])
    savefig(gcf,[figpath, p_name, c_name],'compact')
end
%% write into texfile
% overview of the data: traffic volume

% p_name = [probname,'_'];
% fid = fopen(['../doc\',matname,'.tex'], 'w','n','UTF-8');
% for j = 1:2 % Direction
%     for k = (j-1)*3 + (1:3) % Lane
%         T = zeros(7,1);
%         for i = 1:6 % DAY
%             load([p_name,'Day_',num2str(i),'_Dr_',num2str(j),'_Lane_',num2str(k),'.mat']);
%             T(i) = size(Day_Dr_Lane,1);
%         end
%     end
% end
fid = fopen(['../doc\',probname,' overvive.tex'], 'w','n','UTF-8');
fprintf(fid, '\\begin{table}[tbph]\n');
fprintf(fid, '\\caption{AADT of each lane of each direction}\n');
fprintf(fid, '\\begin{centering}\n');
fprintf(fid, '\\begin{tabular}{ccc}\n');
fprintf(fid, '\\toprule\n');
fprintf(fid, 'Direction & Lane & AADT \\tabularnewline\n');
fprintf(fid, '\\midrule\n');
for j = 1:2 % Direction
    for k = (j-1)*3 + (1:3) % Lane
        p_name = [probname,'_'];
        matname = [p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k)];
        load([matname,'.mat'])
        fprintf(fid, '%d & %d & %d \\tabularnewline\n', j, k,AADT);
    end
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\par\\end{centering}\n');
fprintf(fid, '\\end{table}\n\n');

for j = 1:2
    fprintf(fid, '\\begin{figure}[tbph]\n');
    fprintf(fid, '\\begin{centering}\n');
    fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Proportion of vehicle types.png}\n',probname,j);
    fprintf(fid, '\\par\\end{centering}\n');
    fprintf(fid, '\\caption{Proportion of vehicle types (%s Dr %d)}\n',probname,j);
    fprintf(fid, '\\end{figure}\n\n');
end


% vehicle distance gap
fprintf(fid, '\\begin{table}[tbph]\n');
fprintf(fid, '\\caption{Fitting curve parameters of data per lane}\n');
fprintf(fid, '\\begin{centering}\n');
fprintf(fid, '\\begin{tabular}{ccccc}\n');
fprintf(fid, '\\toprule\n');

fprintf(fid, '\\multirow{2}{*}{Direction} & \\multirow{2}{*}{Lane} & \\multirow{2}{*}{Distribution type} & \\multicolumn{2}{c}{parameters}\\tabularnewline\n');
fprintf(fid, '\\cmidrule{4-5} \\cmidrule{5-5}');
fprintf(fid, ' &  & & $\\mu$ & $\\sigma$\\tabularnewline\n');

fprintf(fid, '\\midrule\n');
for j = 1:2 % Direction
    for k = (j-1)*3 + (1:3) % Lane
        p_name = [probname,'_'];
        matname = [p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k)];
        load([matname,'.mat'])
        fprintf(fid, '%d & %d & truncated normal & %.2f & %.2f \\tabularnewline\n', j, k, pdd.mu, pdd.sigma);
    end
end
fprintf(fid, '\\bottomrule\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\par\\end{centering}\n');
fprintf(fid, '\\end{table}\n\n');

fclose(fid);
%
% result of each lane
for j = 1:2 % Direction
    for k = (j-1)*3 + (1:3) % Lane
        p_name = [probname,'_'];
        matname = [p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k)];
        load([matname,'.mat'])
        fid = fopen(['../doc\',matname,'.tex'], 'w','n','UTF-8');
        % fprintf(fid, '\\documentclass{article}\n');
        % fprintf(fid, '\\usepackage{booktabs}\n');
        % fprintf(fid, '\\begin{document}\n');

        % traffic ratio
        fprintf(fid, '\\begin{figure}[tbph]\n');
        fprintf(fid, '\\begin{centering}\n');
        fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d traffic ratio.pdf}\n',probname,j,k);
        fprintf(fid, '\\par\\end{centering}\n');
        fprintf(fid, '\\caption{Variation of hourly traffic}\n');
        fprintf(fid, '\\end{figure}\n\n');

        % vehicle ratio
        fprintf(fid, '\\begin{figure}[tbph]\n');
        fprintf(fid, '\\begin{centering}\n');
        fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d vehicle ratio.pdf}\n',probname,j,k);
        fprintf(fid, '\\par\\end{centering}\n');
        fprintf(fid, '\\caption{Variation of vehicle ratio}\n');
        fprintf(fid, '\\end{figure}\n\n');

        % VGD fitting
        fprintf(fid, '\\begin{figure}[tbph]\n');
        fprintf(fid, '\\begin{centering}\n');
        fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d vehicle gap.pdf}\n',probname,j,k);
        fprintf(fid, '\\par\\end{centering}\n');
        fprintf(fid, '\\caption{Gaus fit to vehicle gap distance}\n');
        fprintf(fid, '\\end{figure}\n\n');

        % GVW fitting
        for m = 1:7
            fprintf(fid, '\\begin{figure}[tbph]\n');
            fprintf(fid, '\\begin{centering}\n');
            fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d GVW class %d.pdf}\n',probname,j,k,m);
            fprintf(fid, '\\par\\end{centering}\n');
            switch m
                case 1
                    fprintf(fid, '\\caption{GMM fit to GVW of car}\n');
                case 2
                    fprintf(fid, '\\caption{GMM fit to GVW of bus}\n');
                otherwise
                    fprintf(fid, '\\caption{GMM fit to GVW of %d-axle truck}\n',m-1);
                    % fprintf(fid, '\\caption{基于高斯混合分布拟合%d轴货车总重}\n',m-1);
            end

            fprintf(fid, '\\end{figure}\n\n');
        end


        % GVW parametros
        fprintf(fid, '\\begin{table}[tbph]\n');
        fprintf(fid, '\\caption{Fitting Curve Parameters of GVW (unit: kN)}\n');
        fprintf(fid, '\\begin{centering}\n');
        fprintf(fid, '\\begin{tabular}{ccccc}\n');
        fprintf(fid, '\\toprule\n');
        fprintf(fid, 'Vehicle class & Peak & Probability & $\\mu$ & $\\sigma$ \\tabularnewline\n');
        fprintf(fid, '\\midrule\n');

        for m = 1:7
            NumComp = gm_model{m, 1}.NumComponents;
            p = gm_model{m, 1}.ComponentProportion;
            mu = gm_model{m, 1}.mu;
            sigma = sqrt(gm_model{m, 1}.Sigma(:));
            [mu, idx]= sort(mu);
            p = p(idx);
            sigma = sigma(idx);
            for Comp = 1:NumComp

                switch m
                    case 1
                        %         fprintf(fid, '\\caption{GMM fitting to GVW of car}\n');
                        if Comp == 1
                            fprintf(fid, 'car & %d & %.2f & %.2f & %.2f \\tabularnewline\n', Comp,p(Comp),mu(Comp),sigma(Comp));
                        else
                            fprintf(fid, ' & %d & %.2f & %.2f & %.2f \\tabularnewline\n',Comp,p(Comp),mu(Comp),sigma(Comp));
                        end
                    case 2
                        if Comp == 1
                            %         fprintf(fid, '\\caption{GMM fitting to GVW of bus}\n');
                            fprintf(fid, 'bus & %d & %.2f & %.2f & %.2f \\tabularnewline\n',Comp,p(Comp),mu(Comp),sigma(Comp));
                        else
                            fprintf(fid, ' & %d & %.2f & %.2f & %.2f \\tabularnewline\n',Comp,p(Comp),mu(Comp),sigma(Comp));
                        end
                    otherwise
                        if Comp == 1
                            fprintf(fid, '%d-axle truck & %d & %.2f & %.2f & %.2f \\tabularnewline\n',m-1, Comp,p(Comp),mu(Comp),sigma(Comp));
                        else
                            fprintf(fid, ' & %d & %.2f & %.2f & %.2f \\tabularnewline\n',Comp,p(Comp),mu(Comp),sigma(Comp));
                        end
                end
            end
        end

        fprintf(fid, '\\bottomrule\n');
        fprintf(fid, '\\end{tabular}\n');
        fprintf(fid, '\\par\\end{centering}\n');
        fprintf(fid, '\\end{table}\n\n');

        % fprintf(fid, '\\end{document}\n');
        fclose(fid);
    end
end