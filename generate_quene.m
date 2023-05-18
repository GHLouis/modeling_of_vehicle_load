function [queue]=generate_quene(road,nol,nod)
% function []=generate_quene(data1,data2,data3,data4,data5,data6,data7,nol)
%road代表道路
%nol代表车道
%nod代表天数
close all;
queue=cell(nod,1);
% warning('off');
%加载交通模式的参数
% load PARA.mat Q H TND LM NLM pd_ratio QV_dist;
% load PARA_clean.mat TND LM NLM pd_ratio QV_dist;
load PARA_unclean.mat TND LM NLM pd_ratio QV_dist;
switch road
    case 'GD'
        %         Q=Q{nol,1};
        %         H=H{nol,1};
        TND=TND{nol,1};
        LM=LM{nol,1};
        NLM=NLM{nol,1};
        pd_ratio=pd_ratio{nol,1};
        QV_dist=QV_dist{nol,1};
        %         ratio=ratio{nol,1};
    case 'GS'
        %         Q=Q{nol,2};
        %         H=H{nol,2};
        TND=TND{nol,2};
        LM=LM{nol,2};
        NLM=NLM{nol,2};
        pd_ratio=pd_ratio{nol,2};
        QV_dist=QV_dist{nol,2};
        %         ratio=ratio{nol,2};
end
%%
% p_type=ratio;
%生成各车型的比例
% tic;
% h=(1:1:24)';
p_type=cell(nod,1);
for o=1:nod
    p_generate=cell(6,1);
    for j=1:6
        p_generate{j}=zeros(24,1);
        for i=1:24
            p_generate{j}(i)= abs(random(pd_ratio{j}{i},1,1));
        end
    end
    % for r=3:6
    %     p_generate{r}=zeros(size(p_generate{r}));
    % end
    %归一化
    P1=p_generate{1}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    P2=p_generate{2}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    P3=p_generate{3}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    P4=p_generate{4}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    P5=p_generate{5}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    P6=p_generate{6}./(p_generate{1}+p_generate{2}+p_generate{3}+p_generate{4}...
        +p_generate{5}+p_generate{6});
    p_type{o}=[P1 P2 P3 P4 P5 P6];
end
% % disp('生成车型比例');
% % toc;
%%
% tic;
%生成速度和交通量
% [volume,velocity]=generate_volume_volecity(Q,V,1); %生成车速和交通量,1表示自由状态
gmv1=QV_dist{1};
gmlist1=QV_dist{2};
gmv2=QV_dist{3};
gmlist2=QV_dist{4};
A=QV_dist{5};
state=1;%1表示自由状态
switch state
    case 1 %自由状态
        volume=cell(24,1);
        for j=1:24
            volume{j}=abs(round(random(gmv1{j},nod*12*1)));
        end
        volume=cell2mat(volume);
        velocity = zeros(nod*288*1,1);
        z=ceil(max(volume)/20);
        for k=1:z
            if k<=length(gmlist1)
                gm=gmlist1{k};
            else
                gm=gmlist1{end};
            end
            N=volume>20*(k-1)&volume<=20*k;
            if ~isempty(gm)&&sum(N)>0
                sd=abs(random(gm,sum(N)));
                velocity(N)=sd;
            end
        end
        velocity(volume==0)=A;
    case 0 %塞车状态
        volume=cell(24,1);
        for j=1:24
            volume{j}=abs(round(random(gmv2{j},nod*12*1)));
        end
        volume=cell2mat(volume);
        velocity = zeros(nod*288*1,1);
        z=ceil(max(volume)/20);
        for k=1:z
            if k<=length(gmlist1)
                gm=gmlist2{k};
            else
                gm=gmlist2{end};
            end
            N=volume>20*(k-1)&volume<=20*k;
            if ~isempty(gm)&&sum(N)>0
                sd=abs(random(gm,sum(N)));
                velocity(N)=sd;
            end
        end
        velocity(volume==0)=0;
end
%%
%生成时间、车头时间间隔序列（一天的数据量）
%生成车辆
for p=1:nod
    a=reshape(volume,[288*nod/24 24]);
    a=a(12*(p-1)+1:12*p,:);
    b=reshape(velocity,[288*nod/24 24]);
    b=b(12*(p-1)+1:12*p,:);
    [vehicle,speed,gap] = hwrnd(road,a,b,p_type{p},NLM,LM,TND);
    time=zeros(length(gap),1);
    for k=1:length(gap)
        time(k)=sum(gap(1:k))/3600*12;
    end
    time=time(time<=288);
    vehicle=vehicle(time<=288,:);
    speed=speed(time<=288);
    gap=gap(time<=288);
    %%
    %得到车距数据，单位是m
    nov=length(speed);
    distance=zeros(nov,1);
    for k=1:nov
        distance(k)=gap(k)*speed(k)/3.6;
    end
    %%
    %得到车队
    index=(1:length(vehicle))';
    queue{p}=[index time gap speed distance vehicle];
end
end
