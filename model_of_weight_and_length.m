%AXLE——轴重轴距的数据文件
%AXLE是一个cell，AXLE{1}是二轴小车的数据，
%第一列是总轴重，然后是各轴重的占比，
%第八列是总轴距，然后是各轴距的占比，二轴车轴距的占比为1，不用考虑
%AXLE{2}是二轴货车（已经分好类了），总共有1+6+1+5=13列数据，总轴重、轴重占比、总轴距、轴距占比的顺序
%需要做的是对轴重轴距的联合分布建模，最后能生成轴重轴距的随机数。

%先获取轴重轴距的分布，下面是我用GMM对轴重轴距边缘分布建模的代码
close all
GMM_result=cell(6,1);
path='figures\';
load('AXLE.mat')
% for i=1:6
%     data=AXLE{i};    
%     x=data(:,1);%总轴重
%     y=data(:,8);%总轴距离
%     data(x<8|y<2,:)=[];%清除小于轴重轴距下限的数据
%     data(x>1000|y>36,:)=[];%清除大于轴重轴距上限的数据    
%     if i>2
%         GMM_result{i}=cell(i+i+1,1);
%         for j=1:i+1
%             [GMM_result{i}{j}] = gmfit_best(data(:,j));
%             f_name=['type-',num2str(i),'-vehicle-weight-',num2str(j)];
%             exportgraphics(gcf,[path,f_name,'.pdf'])
%             exportgraphics(gcf,[path,f_name,'.png'],'resolution',600)
%             savefig(gcf,[path,f_name],'compact')
%         end        
%         for k=1:i
%             [GMM_result{i}{j+k}] = gmfit_best(data(:,7+k));
%             f_name=['type-',num2str(i),'-vehicle-spacing-',num2str(k)];
%             exportgraphics(gcf,[path,f_name,'.pdf'])
%             exportgraphics(gcf,[path,f_name,'.png'],'resolution',600)
%             savefig(gcf,[path,f_name],'compact')
%         end
%     else
%         GMM_result{i}=cell(4,1);        
%         for j=1:3
%             [GMM_result{i}{j}] = gmfit_best(data(:,j));
%             f_name=['type-',num2str(i),'-vehicle-weight-',num2str(j)];
%             exportgraphics(gcf,[path,f_name,'.pdf'])
%             exportgraphics(gcf,[path,f_name,'.png'],'resolution',600)
%             savefig(gcf,[path,f_name],'compact')
%         end        
%         for k=1
%             [GMM_result{i}{j+k}] = gmfit_best(data(:,7+k));
%             f_name=['type-',num2str(i),'-vehicle-spacing-',num2str(k)];
%             exportgraphics(gcf,[path,f_name,'.pdf'])
%             exportgraphics(gcf,[path,f_name,'.png'],'resolution',600)
%             savefig(gcf,[path,f_name],'compact')
%         end    
%     end    
% end
% close all
% save('GMM_result.mat','GMM_result')
% 1.将gm.BIC除以-2便可得到所需的BIC值：-1/2*gm.BIC
% 1.1 BIC越大，那个模型就越好
% 2.将gm.NegativeLogLikelihood乘-1便可得到所需的似然函数值：-gm.NegativeLogLikelihood