function [vehicle,speed,gap] = hwrnd(road,volume,velocity,p_type,NLM,LM,TND)
vehicle=cell(24,1);
speed=cell(288,1);
gap=cell(288,1);
j=ceil(volume/20);
T=1;
while (T<288)
    t=0;
    k=1;
    g=zeros(288,1);
    n=volume(T);%该五分钟区间内的车辆数
    if n>0
        %         j=ceil(n/20);
        miu=exp(NLM.predict(log(n)));%指数分布的参数
        lm=LM{min(length(LM),j(T))};%判断交通量对应哪一组的小时距
        %         if isempty(lm)
        %             lm=LM{end-1};%判断交通量对应哪一组的小时距
        %         end
        tnd=TND{min(length(LM),j(T))};%判断交通量对应哪一组的小时距
        pd = makedist('Normal',tnd(1),tnd(2));
        PD = truncate(pd,0.3,4);

        per=lm.predict(n);%小时距的比例,百分比
        if per<=0
            per=0;
        elseif per>=100
            per=100;
        end

        while t<300
            r=100*rand(1);
            if r<per
                [g(k)]= random(PD,1);%生成小时距
            else
                g(k)=exprnd(miu)+4;%生成小大时距
            end
            t=sum(g);
            k=k+1;
        end
        g(g==0)=[];
        sudu=zeros(length(g),1)+velocity(T);
        speed{T}=sudu;
        gap{T}=g;
        %         T=T+round(t/300);
        T=T+1;
    else
        while t<300
            g(k)=gamrnd(30.5786,15.0420);%针对交通量为0的时候
            t=sum(g);
            k=k+1;
        end
        g(g==0)=[];
        sudu=[];
        speed{T}=sudu;
        gap{T}=sum(g);
        T=T+1;
        %         T=T+round(t/300);
    end
end

for i=1:24
    N=size(cell2mat(gap(12*(i-1)+1:12*i)),1);
    type=p_type(i,:);
    vehicle{i}=generate_vehicle(road,N,type);%车队的轴数、轴重和轴距
end
vehicle=cell2mat(vehicle);
speed=cell2mat(speed);
gap=cell2mat(gap);
end

