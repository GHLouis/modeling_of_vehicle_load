function [pd_ratio,ratio]=generate_heavy_vehicle_ratio(data1,data2,data3,data4,data5,data6,data7,nol)
%������������������ͳ���������ʱ��ı仯��ϵ

% [data1] = data_clean(data1);
% [data2] = data_clean(data2);
% [data3] = data_clean(data3);
% [data4] = data_clean(data4);
% [data5] = data_clean(data5);
% [data6] = data_clean(data6);
% [data7] = data_clean(data7);
ratio=cell(7,1);
laneout=cell(7,1);
pd_ratio=cell(6,1);%���ֳ��ͱ����ķֲ�

[laneout{1}] = lane(data1,nol);     %laneout{1}��ʾ���ǳ������Ϊnol�ĵ�2�������
[laneout{2}] = lane(data2,nol);     %�������Ϊnol�ĵ�2�������
[laneout{3}] = lane(data3,nol);     %�������Ϊnol�ĵ�3�������
[laneout{4}] = lane(data4,nol);     %�������Ϊnol�ĵ�4�������
[laneout{5}] = lane(data5,nol);     %�������Ϊnol�ĵ�5�������
[laneout{6}] = lane(data6,nol);     %�������Ϊnol�ĵ�6�������
[laneout{7}] = lane(data7,nol);     %�������Ϊnol�ĵ�7�������

x=zeros(7,1);%1����ǿ�
for c=1:7
    x(c)=~isempty(laneout{c});
end
switch sum(x)
    case 1
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        for k=1:6
            p=p1(:,k);
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24                
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 2
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        [p2] = heavy_vehicle_ratio(laneout {X(2)});
        for k=1:6
            p=[p1(:,k) p2(:,k)];
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 3
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        [p2] = heavy_vehicle_ratio(laneout {X(2)});
        [p3] = heavy_vehicle_ratio(laneout {X(3)});
        for k=1:6
            p=[p1(:,k) p2(:,k) p3(:,k)];
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 4
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        [p2] = heavy_vehicle_ratio(laneout {X(2)});
        [p3] = heavy_vehicle_ratio(laneout {X(3)});
        [p4] = heavy_vehicle_ratio(laneout {X(4)});
        for k=1:6
            p=[p1(:,k) p2(:,k) p3(:,k) p4(:,k)];
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 5
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        [p2] = heavy_vehicle_ratio(laneout {X(2)});
        [p3] = heavy_vehicle_ratio(laneout {X(3)});
        [p4] = heavy_vehicle_ratio(laneout {X(4)});
        [p5] = heavy_vehicle_ratio(laneout {X(5)});
        for k=1:6
            p=[p1(:,k) p2(:,k) p3(:,k) p4(:,k) p5(:,k)];
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 6
        X=find(x>0);
        [p1] = heavy_vehicle_ratio(laneout {X(1)});
        [p2] = heavy_vehicle_ratio(laneout {X(2)});
        [p3] = heavy_vehicle_ratio(laneout {X(3)});
        [p4] = heavy_vehicle_ratio(laneout {X(4)});
        [p5] = heavy_vehicle_ratio(laneout {X(5)});
        [p6] = heavy_vehicle_ratio(laneout {X(6)});
        for k=1:6
            p=[p1(:,k) p2(:,k) p3(:,k) p4(:,k) p5(:,k) p6(:,k)];
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
    case 7
        % �õ�7��24��ʱ�εĸ��ֳ��͵���ռ����
        [p1] = heavy_vehicle_ratio(laneout{1});
        [p2] = heavy_vehicle_ratio(laneout{2});
        [p3] = heavy_vehicle_ratio(laneout{3});
        [p4] = heavy_vehicle_ratio(laneout{4});
        [p5] = heavy_vehicle_ratio(laneout{5});
        [p6] = heavy_vehicle_ratio(laneout{6});
        [p7] = heavy_vehicle_ratio(laneout{7});
        
        figure
        plot(p1)
        xlim([0 24])
        xticks(0:2:24)

        [ratio{1}] = heavy_vehicle_ratio(laneout{1});
        [ratio{2}] = heavy_vehicle_ratio(laneout{2});
        [ratio{3}] = heavy_vehicle_ratio(laneout{3});
        [ratio{4}] = heavy_vehicle_ratio(laneout{4});
        [ratio{5}] = heavy_vehicle_ratio(laneout{5});
        [ratio{6}] = heavy_vehicle_ratio(laneout{6});
        [ratio{7}] = heavy_vehicle_ratio(laneout{7});
        
        for k=1:6  %����
            p=[p1(:,k) p2(:,k) p3(:,k) p4(:,k) p5(:,k) p6(:,k) p7(:,k)];%ĳ���ͺŵĳ�
            p=p';
            pd_ratio{k}=cell(24,1);
            for i=1:24
                pd_ratio{k}{i}=fitdist((p(:,i)),'normal');
            end
        end
end

% %�������ݵĹ���
% h=(1:1:24)';
% p_generate=cell(6,1);
% for j=1:6
%     p_generate{j}=zeros(24,1);
%     for i=1:24
%         p_generate{j}(i)= random(pd_ratio{j}{i},1,1);
%     end
% end
% %��һ��
% P1=p_generate{1}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% P2=p_generate{2}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% P3=p_generate{3}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% P4=p_generate{4}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% P5=p_generate{5}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% P6=p_generate{6}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
%     +p_generate{5}+p_generate{6});
% 
% p_type=[P1 P2 P3 P4 P5 P6];
% 
% figure
% for K=1:6
%     subplot(2,3,K)
%     hold on
%     plot(h,p_type(:,K),'o--','linewidth',1);
%     set(gca, 'XTick', 0:2:24);
%     xlabel('Time (h)');
%     ylabel('Ratio');
%     hold off
% end

%����ԭʼ������ʱ��ı仯��ϵ

end


