clear;close all;clc
figpath = 'figures\';
probname = 'G107';
%% G107
data = [];
T_all = zeros(6,7);
for j = 1:2 % Direction
    for k = (j-1)*3 + (1:3) % Lane
        % for k = 1:1 % Lane
        close all
        % vd = [];
        vd = cell(7,24);
        pdvgd = cell(24,1);

        % hour by hour
        T = zeros(24,7,7);
        for i = 1:7 % DAY
            load([probname,'_Day_',num2str(i),'_Dr_',num2str(j),'_Lane_',num2str(k),'.mat']);

            % traffic ratio and vehicle ratio
            t = Day_Dr_Lane(:,5)*24; % time
            h = Day_Dr_Lane(:,20)/1000; % headway
            c = VCT(Day_Dr_Lane(:,12)); % vehicle class
            tbl = tabulate(c);

            ct = ceil(t);
            tabulate(ct)

            for n = 1:24
                T(n,:,i) = sum(c(ct==n)==1:7);
                tabulate(c(ct==n))

                t0 = t(ct==n);
                dt = h(ct==n);
                v = Day_Dr_Lane(ct==n,10)/3.6; % vehicle speed
                L = Day_Dr_Lane(ct==n,14)/100; % vehicle length
                dx = dt(2:end) .* v(1:end-1) - L(1:end-1);
                dx(dt(2:end)>=600) = [];
                dx(dx<=0) = [];

                vd{i,n} = dx; % vehicle distance
            end

            % extract vehicle gap distance
            % vd = [vd; Day_Dr_Lane(:,21)/100]; % vehicle distance

            % extract class and GVW
            data = [data;Day_Dr_Lane];
        end

        T = sum(T,3);
        q = sum(T,2)./sum(T(:));
        cls = T./sum(T,2);
        AADT = round(sum(T(:))/7);

        T_all(k,:) = sum(T);


        % Percent of traffic volume
        figure;plot(100*q,'o-','linewidth',1)
        xlabel('Time (hour)','Interpreter','latex');
        ylabel('Percent of traffic volume (\%)','Interpreter','latex');
        xticks(0:2:24)

        p_name = [probname,' '];
        c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' traffic ratio'];

        saveas(gcf,[figpath,p_name,c_name,'.png'])
        savefig(gcf,[figpath, p_name, c_name],'compact')
        % matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)

        % Percent of vehicles
        figure;plot(100*cls,'linewidth',1)
        legend({'car','bus','2-axle truck','3-axle truck','4-axle truck','5-axle truck','6-axle truck'},'location','best','NumColumns',2)
        %         legend({'小客车','大客车','2轴货车','3轴货车','4轴货车','5轴货车','6轴货车'},'location','best','NumColumns',2)
        xlabel('Time (hour)','Interpreter','latex');
        ylabel('Percent of vehicles (\%)','Interpreter','latex');
        xticks(0:2:24)

        p_name = [probname,' '];
        c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' vehicle ratio'];

        saveas(gcf,[figpath,p_name,c_name,'.png'])
        savefig(gcf,[figpath, p_name, c_name],'compact')
        % matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)


        % fit vd
        % pdd = fittrunc(vd,'Normal',0,100);
        p_name = [probname,' '];
        for n = 1:24
            [dist, tb] = optimal_commom_dist_new(cell2mat(vd(:,n)));

            pdvgd{n,1} = dist.opdist;
            xlabel(gcf().Children(2),'Vehicle gap distance (m)')
            xlabel(gcf().Children(4),'Vehicle gap distance (m)')

            c_name = ['Dr ',num2str(j),' Lane ',num2str(k),' vehicle gap hour ',num2str(n)];
            table2tex(tb,['../doc\',p_name,c_name,'.tex'])
            % matlab2tikz([figpath,p_name,c_name,'.tex'],'showInfo', false,'checkForUpdates',false,'standalone',true)
            saveas(gcf,[figpath,p_name,c_name,'.png'])
            savefig(gcf,[figpath, p_name, c_name],'compact')
            close
        end

        p_name = [probname,'_'];
        save([p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k),'.mat'],'AADT','q','cls','pdvgd');
    end
end
%%
T_all = T_all./sum(T_all,2)*100;
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

%% fit GVW by GMM
day = 7;
GVW_representative_vehicle
%% write into texfile
% overview of the data: traffic volume

% p_name = [probname,'_'];
% fid = fopen(['../doc\',matname,'.tex'], 'w','n','UTF-8');
% for j = 1:2 % Direction
%     for k = (j-1)*3 + (1:3) % Lane
%         T = zeros(7,1);
%         for i = 1:7 % DAY
%             load([p_name,'Day_',num2str(i),'_Dr_',num2str(j),'_Lane_',num2str(k),'.mat']);
%             T(i) = size(Day_Dr_Lane,1);
%         end
%     end
% end
fid = fopen(['../doc\',probname,' overvive.tex'], 'w','n','UTF-8');
fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\caption{AADT of each lane of each direction}\n');

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

fprintf(fid, '\\end{table}\n\n');

for j = 1:2
    fprintf(fid, '\\begin{figure}\n');

    fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Proportion of vehicle types.png}\n',probname,j);

    fprintf(fid, '\\caption{Proportion of vehicle types (%s Dr %d)}\n',probname,j);
    fprintf(fid, '\\end{figure}\n\n');
end


% %% vehicle distance gap
% fprintf(fid, '\\begin{table}\n');
% fprintf(fid, '\\caption{Fitting curve parameters of data per lane}\n');
%
% fprintf(fid, '\\begin{tabular}{ccccc}\n');
% fprintf(fid, '\\toprule\n');
%
% fprintf(fid, '\\multirow{2}{*}{Direction} & \\multirow{2}{*}{Lane} & \\multirow{2}{*}{Distribution type} & \\multicolumn{2}{c}{parameters}\\tabularnewline\n');
% fprintf(fid, '\\cmidrule{4-5} \\cmidrule{5-5}');
% fprintf(fid, ' &  & & $\\mu$ & $\\sigma$\\tabularnewline\n');
%
% fprintf(fid, '\\midrule\n');
% for j = 1:2 % Direction
%     for k = (j-1)*3 + (1:3) % Lane
%         p_name = [probname,'_'];
%         matname = [p_name,'trafficflow_','Dr_',num2str(j),'_Lane_',num2str(k)];
%         load([matname,'.mat'])
%         fprintf(fid, '%d & %d & truncated normal & %.2f & %.2f \\tabularnewline\n', j, k, pdd.mu, pdd.sigma);
%     end
% end
% fprintf(fid, '\\bottomrule\n');
% fprintf(fid, '\\end{tabular}\n');
%
% fprintf(fid, '\\end{table}\n\n');

% fid = fopen(['../doc\',probname,' vgd fitting figure.tex'], 'w','n','UTF-8');
% VGD fitting

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

        % GVW fitting
        for m = 1:7
            fprintf(fid, '\\begin{figure}\n');
            %
            fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d GVW class %d.png}\n',probname,j,k,m);

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
        fprintf(fid, '\\begin{table}\n');
        fprintf(fid, '\\caption{Fitting Curve Parameters of GVW (unit: kN)}\n');

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
        fprintf(fid, '\\end{table}\n\n');


        % traffic ratio
        fprintf(fid, '\\begin{figure}\n');
        fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d traffic ratio.png}\n',probname,j,k);
        fprintf(fid, '\\caption{Variation of hourly traffic}\n');
        fprintf(fid, '\\end{figure}\n\n');

        % vehicle ratio
        fprintf(fid, '\\begin{figure}\n');
        fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d vehicle ratio.png}\n',probname,j,k);
        fprintf(fid, '\\caption{Variation of vehicle ratio}\n');
        fprintf(fid, '\\end{figure}\n\n');

        fprintf(fid, '\\newpage\n');
        % vehicle gap
        for n = 1:24
            fprintf(fid, '\\begin{figure}\n');
            fprintf(fid, '\\includegraphics{../code/figures/%s Dr %d Lane %d vehicle gap hour %d.png}\n',probname,j,k,n);
            fprintf(fid, '\\caption{Fitting to vehicle gap distance hour %d}\n',n);
            fprintf(fid, '\\end{figure}\n\n');
            fprintf(fid, '\\input{%s Dr %d Lane %d vehicle gap hour %d.tex}\n\n',probname,j,k,n);
            fprintf(fid, '\\newpage\n');
        end

        % fprintf(fid, '\\end{document}\n');
        fclose(fid);
    end
end