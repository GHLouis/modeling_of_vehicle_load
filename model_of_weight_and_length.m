%AXLE�����������������ļ�
%AXLE��һ��cell��AXLE{1}�Ƕ���С�������ݣ�
%��һ���������أ�Ȼ���Ǹ����ص�ռ�ȣ�
%�ڰ���������࣬Ȼ���Ǹ�����ռ�ȣ����ᳵ����ռ��Ϊ1�����ÿ���
%AXLE{2}�Ƕ���������Ѿ��ֺ����ˣ����ܹ���1+6+1+5=13�����ݣ������ء�����ռ�ȡ�����ࡢ���ռ�ȵ�˳��
%��Ҫ�����Ƕ������������Ϸֲ���ģ��������������������������

%�Ȼ�ȡ�������ķֲ�������������GMM����������Ե�ֲ���ģ�Ĵ���
close all
GMM_result=cell(6,1);
path='figures\';
load('AXLE.mat')
% for i=1:6
%     data=AXLE{i};    
%     x=data(:,1);%������
%     y=data(:,8);%�������
%     data(x<8|y<2,:)=[];%���С������������޵�����
%     data(x>1000|y>36,:)=[];%�����������������޵�����    
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
% 1.��gm.BIC����-2��ɵõ������BICֵ��-1/2*gm.BIC
% 1.1 BICԽ���Ǹ�ģ�;�Խ��
% 2.��gm.NegativeLogLikelihood��-1��ɵõ��������Ȼ����ֵ��-gm.NegativeLogLikelihood