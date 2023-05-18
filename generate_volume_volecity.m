function QV_dist=generate_volume_volecity(varargin)
%这个函数对交通量进行GMM建模，然后对对应的车速数据进行高斯拟合，
%然后生成车速和交通量的序列，生成的序列，其有效性仍待商榷
%Q、V分别是某个车道的数据
%state 是交通状态，1代表自由流动状态，0代表堵塞状态
Q=varargin{1};
V=varargin{2};
% state=varargin{3};
QV_dist=cell(4,1);
[congested,free,~,A]=Greenmodel(Q,V);

%用GMM对交通量建模
speed1=free(:,2);
vo1=free(:,1);
vo=reshape(vo1,[288 7]);
X=cell(24,1);
gm_model=cell(24,1);
for i=1:24
    x=vo((12*(i-1)+1):12*i,:);
    x=reshape(x,[12*7,1]);
    X{i}=x;
    x(isnan(x)|x<0)=[];
    gm_model{i}=gmfit_best(x);
    clear x;
end
[gmv1] = gm_model;%自由状态

speed2=congested(:,2);
vo2=congested(:,1);
vo=reshape(vo2,[288 7]);
X=cell(24,1);
gm_model=cell(24,1);
for i=1:24
    x=vo((12*(i-1)+1):12*i,:);
    x=reshape(x,[12*7,1]);
    X{i}=x;
    x(isnan(x)|x<0)=[];
    gm_model{i}=gmfit_best(x);
    clear x;
end
[gmv2] = gm_model;%塞车状态


speed1(isnan(speed1)|speed1<0)=[];
vo1(isnan(vo1)|vo1<0)=[];

ma=ceil(max(vo1)/20);
gmlist1=cell(ma,1);
for i=1:ma   %最新版本
    if i==1
        data=speed1(vo1<=20);
    else
        data=speed1(vo1<=(i*20)&vo1>((i-1)*20));
    end
    [gmlist1{i}] = gmfit_best(data);
end
clear data;

speed2(isnan(speed2)|speed2<0)=[];
vo2(isnan(vo2)|vo2<0)=[];
% speed2(isnan(speed2))=[];
% vo2(isnan(vo2))=[];

ma=ceil(max(vo2)/20);
gmlist2=cell(ma,1);
for i=1:ma
    if i==1
        data=speed2(vo2<=20);
    else
        data=speed2(vo2<=(i*20)&vo2>((i-1)*20));
    end
    [gmlist2{i}] = gmfit_best(data);
end
QV_dist{1}=gmv1;
QV_dist{2}=gmlist1;
QV_dist{3}=gmv2;
QV_dist{4}=gmlist2;
QV_dist{5}=A;
end

