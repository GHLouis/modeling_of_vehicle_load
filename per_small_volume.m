function [Q,V,H,TND,LM,NLM]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,nol)
% ����˵��------------------------------------------------------------------
% input��
% 1. nol��ʾ���ǳ����ı��
% 2. data1,data2,data3,data4,data5,data6,data7 ��ʾ���ǲ�ͬ���ڵ�WIM����
% output:
% 1. Q ����nol��7�쳵�������ݣ�ͳ��ÿ�����ͨ���ĳ������õ�����mat sizeΪ
%   (2016,1)��7���ܹ���288*7=2016������
% 2. V ����nol��7�쳵�����ݣ�ͳ��ÿ�����ͨ���ĳ�����ƽ���ٶȵõ�����mat sizeΪ
%   (2016,1)��7���ܹ���288*7=2016������
% 3. H ����nol��7�쳵ͷʱ�����ݣ�ͳ��ÿ�������ǰ������ͨ����ʱ���ֵ�õ�����
%   cell sizeΪ(2016,1)��7���ܹ���288*7=2016������
% 4. TND ��truncated normal distribution�� for small headway
% 5. LM ��linear model��for relationship between traffic volume and
%   percentage of small headway
% 6. NLM ��non-linear model��for relationship between traffic volume and
%   parameters of large headway
% -------------------------------------------------------------------------

laneout=cell(7,1);

%��ϴ����
% [data1] = data_clean(data1);
% [data2] = data_clean(data2);
% [data3] = data_clean(data3);
% [data4] = data_clean(data4);
% [data5] = data_clean(data5);
% [data6] = data_clean(data6);
% [data7] = data_clean(data7);

[laneout{1}] = lane(data1,nol);     %laneout{1}��ʾ���ǳ������Ϊnol�ĵ�1�������
[laneout{2}] = lane(data2,nol);     %�������Ϊnol�ĵ�2�������
[laneout{3}] = lane(data3,nol);     %�������Ϊnol�ĵ�3�������
[laneout{4}] = lane(data4,nol);     %�������Ϊnol�ĵ�4�������
[laneout{5}] = lane(data5,nol);     %�������Ϊnol�ĵ�5�������
[laneout{6}] = lane(data6,nol);     %�������Ϊnol�ĵ�6�������
[laneout{7}] = lane(data7,nol);     %�������Ϊnol�ĵ�7�������


volume=cell(7,1);
head=cell(7,1);
speed=cell(7,1);
% switch nargin
%     case 8
%% �õ�����nol�Ľ�ͨ��Q��small headway�ı���P��ʱ����H��Q��Ӧ��ƽ������
for j=1:7 %����
    data=laneout{j};
    if ~isempty(data)
        %��ȡheadway�ķ�ʽ�е����⣬ֱ���ó���������ʱ������Ļ�����ֵ�ȽϷ�ɢ��
        %���忴�ش���volume_velocity�������õ��ǵ�һ�ִ���headway�ķ���
        [v,s,h] = volume_velocity(data);
    else
        v=[]; h=[]; s=[];
    end
    volume{j}=v;
    head{j}=h;
    speed{j}=s;
    clear v h s;
end
volume=cell2mat(volume);
speed=cell2mat(speed);

Q=volume;
H=[head{1};head{2};head{3};head{4};head{5};head{6};head{7}];
V=speed;
% �������song��ô���ӵ�ģ�ͣ������￪ʼ�޸ļ���
%% ��Ͻ�ͨ����small headway����ģ�� ����20veh/ 5 min �ֱ���ֱ�߶�������е����ݵ�
%�ر�ע�⣺�÷ֶ�����ģ������ϣ�Ч��������
Q_u=unique(Q);
% Q_u=Q_u(~isnan(Q_u));
% y=cell(length(x),1);
p_u=zeros(length(Q_u),1);
for i=1:length(Q_u)
    if Q_u(i)~=0
        z=H(Q==Q_u(i),1);
        hl=cell2mat(z);
        p_u(i)=sum(hl<=4)/length(hl);
    end
end
LM = piecewise_fitlm(Q_u,100.*p_u,20); % ���Կ��Ǹ�Ϊ������Ϻ�����������ζ���ʽ���
% if ~isempty(Q)&&~isempty(P)
%     LM = piecewise_fitlm(Q,100.*P,20);
% else
%     LM=[];
% end
%% ���headway�Ĳ���
% %��ϴ�headway
% �õ�����nol�Ĳ���mu�ͽ�ͨ������,ÿ����ͨ������һ��
% Q_u=Q_u(Q_u>0);
% m=zeros(length(Q_u),1);
% for i=1:length(Q_u)
%     z=H(Q==Q_u(i),1);
%     h2=cell2mat(z);
%     if ~isempty(h2)
%         h2=h2(h2>4);
%         m(i)=headwayfit(h2);
%     end
% end
%�õ�����nol�Ĳ���mu�ͽ�ͨ������,��traffic volume group��
Q_u=Q_u(Q_u>0);
m=zeros(length(Q_u),1);
for i=1:length(Q_u)
    z=H(Q==Q_u(i));
    h2=cell2mat(z);
    if ~isempty(h2)
        h2=h2(h2>4);
        m(i)=headwayfit(h2);
    end
end
% %�ýضϷֲ����Сʱ����
n=ceil(max(Q)/20);
TND=cell(n,1);
for j=1:n
    headway=H(Q>=20*(j-1)&Q<20*j);
    hw=cell2mat(headway);
    t=hw(hw<=4);
    [TND{j},~] = headwayfit(t);
end
%%
% NLM=m;
%��Ͻ�ͨ��������mu�ķ�����ģ��
% NLM=[];
% nlm1=[]; nlm2=[];
if ~isempty(Q_u)&&~isempty(m)
    x=log(Q_u);%��ȡ�������Ա�������
    y=log(m);%��ȡ���������������
    
    md1= fitlm(x,y,'RobustOpts','on');
    Res=md1.Residuals;
    Res_Stu=Res.Studentized;
    id=find(abs(Res_Stu>2));
    nlm2=fitlm(x,y,'RobustOpts','on','Exclude',id);
    xi=linspace(min(x),max(x),1e3);
    figure; %���������
    hold on;
    plot(exp(x),exp(y),'o');
    plot(exp(xi'),exp(nlm2.predict(xi')),'r','linewidth',2);
    xlabel('Traffic volume (veh/5min)');
    ylabel('Parametor \lambda');
    legend('Raw data','Fit curve');
    hold off
else
    nlm2=[];
end
NLM=nlm2;
end
% %���Ʋ�ͬ�����Ľ��
% close all
% [Q1,V1,P1,~,~,LM1,NLM1]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,4);
% [Q2,V2,P2,~,~,LM2,NLM2]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,5);
% [Q3,V3,P3,~,~,LM3,NLM3]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,6);
%
%
%
% y=(0.01:0.1:120)';%�ֶ�����ģ��
% [~,prediction1] = piecewise_fitlm(Q1,100.*P1,20,y,100);
% [~,prediction2] = piecewise_fitlm(Q2,100.*P2,20,y,100);
% [~,prediction3] = piecewise_fitlm(Q3,100.*P3,20,y,100);
% close all
% figure
% hold on
% plot(y,prediction1(:,2),'k--','linewidth',1);
% plot(y,prediction2(:,2),'r','linewidth',1);
% plot(y,prediction3(:,2),'b-.','linewidth',1);
% xlabel('Traffic volume (veh/5 min)');
% ylabel('Percentage of small headway(%)');
% legend('Lane 1','Lane 2','Lane 3');
% hold off
%
% x=(10:0.01:100)';% ������ģ��
% figure
% hold on
% plot(x,NLM1.predict(x),'k--','linewidth',1);
% plot(x,NLM2.predict(x),'r','linewidth',1);
% plot(x,NLM3.predict(x),'b-.','linewidth',1);
% xlabel('Traffic volume (veh/5 min)');
% ylabel('Parametor ��');
% legend('Lane 1','Lane 2','Lane 3');
% hold off