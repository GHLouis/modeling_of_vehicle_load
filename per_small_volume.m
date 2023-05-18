function [Q,V,H,TND,LM,NLM]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,nol)
% 函数说明------------------------------------------------------------------
% input：
% 1. nol表示的是车道的编号
% 2. data1,data2,data3,data4,data5,data6,data7 表示的是不同日期的WIM数据
% output:
% 1. Q 车道nol的7天车流量数据（统计每五分钟通过的车辆数得到），mat size为
%   (2016,1)，7天总共有288*7=2016组数据
% 2. V 车道nol的7天车速数据（统计每五分钟通过的车辆的平均速度得到），mat size为
%   (2016,1)，7天总共有288*7=2016组数据
% 3. H 车道nol的7天车头时距数据（统计每五分钟内前后相邻通过的时间差值得到），
%   cell size为(2016,1)，7天总共有288*7=2016组数据
% 4. TND （truncated normal distribution） for small headway
% 5. LM （linear model）for relationship between traffic volume and
%   percentage of small headway
% 6. NLM （non-linear model）for relationship between traffic volume and
%   parameters of large headway
% -------------------------------------------------------------------------

laneout=cell(7,1);

%清洗数据
% [data1] = data_clean(data1);
% [data2] = data_clean(data2);
% [data3] = data_clean(data3);
% [data4] = data_clean(data4);
% [data5] = data_clean(data5);
% [data6] = data_clean(data6);
% [data7] = data_clean(data7);

[laneout{1}] = lane(data1,nol);     %laneout{1}表示的是车道编号为nol的第1天的数据
[laneout{2}] = lane(data2,nol);     %车道编号为nol的第2天的数据
[laneout{3}] = lane(data3,nol);     %车道编号为nol的第3天的数据
[laneout{4}] = lane(data4,nol);     %车道编号为nol的第4天的数据
[laneout{5}] = lane(data5,nol);     %车道编号为nol的第5天的数据
[laneout{6}] = lane(data6,nol);     %车道编号为nol的第6天的数据
[laneout{7}] = lane(data7,nol);     %车道编号为nol的第7天的数据


volume=cell(7,1);
head=cell(7,1);
speed=cell(7,1);
% switch nargin
%     case 8
%% 得到车道nol的交通量Q、small headway的比例P，时间间距H，Q对应的平均车速
for j=1:7 %日期
    data=laneout{j};
    if ~isempty(data)
        %获取headway的方式有点问题，直接用车辆经过的时间相减的话，数值比较分散。
        %具体看回代码volume_velocity，这里用的是第一种处理headway的方法
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
% 如果不用song那么复杂的模型，从这里开始修改即可
%% 拟合交通量—small headway线性模型 按照20veh/ 5 min 分别用直线段拟合所有的数据点
%特别注意：用分段线性模型来拟合，效果并不好
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
LM = piecewise_fitlm(Q_u,100.*p_u,20); % 可以考虑改为其他拟合函数，例如二次多项式拟合
% if ~isempty(Q)&&~isempty(P)
%     LM = piecewise_fitlm(Q,100.*P,20);
% else
%     LM=[];
% end
%% 拟合headway的参数
% %拟合大headway
% 得到车道nol的参数mu和交通量数据,每个交通量计算一次
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
%得到车道nol的参数mu和交通量数据,按traffic volume group算
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
% %用截断分布拟合小时间间距
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
%拟合交通量—参数mu的非线性模型
% NLM=[];
% nlm1=[]; nlm2=[];
if ~isempty(Q_u)&&~isempty(m)
    x=log(Q_u);%提取列数据自变量数据
    y=log(m);%提取列数据因变量数据
    
    md1= fitlm(x,y,'RobustOpts','on');
    Res=md1.Residuals;
    Res_Stu=Res.Studentized;
    id=find(abs(Res_Stu>2));
    nlm2=fitlm(x,y,'RobustOpts','on','Exclude',id);
    xi=linspace(min(x),max(x),1e3);
    figure; %这个可以有
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
% %绘制不同车道的结果
% close all
% [Q1,V1,P1,~,~,LM1,NLM1]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,4);
% [Q2,V2,P2,~,~,LM2,NLM2]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,5);
% [Q3,V3,P3,~,~,LM3,NLM3]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,6);
%
%
%
% y=(0.01:0.1:120)';%分段线性模型
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
% x=(10:0.01:100)';% 非线性模型
% figure
% hold on
% plot(x,NLM1.predict(x),'k--','linewidth',1);
% plot(x,NLM2.predict(x),'r','linewidth',1);
% plot(x,NLM3.predict(x),'b-.','linewidth',1);
% xlabel('Traffic volume (veh/5 min)');
% ylabel('Parametor λ');
% legend('Lane 1','Lane 2','Lane 3');
% hold off