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
    n=volume(T);%������������ڵĳ�����
    if n>0
        %         j=ceil(n/20);
        miu=exp(NLM.predict(log(n)));%ָ���ֲ��Ĳ���
        lm=LM{min(length(LM),j(T))};%�жϽ�ͨ����Ӧ��һ���Сʱ��
        %         if isempty(lm)
        %             lm=LM{end-1};%�жϽ�ͨ����Ӧ��һ���Сʱ��
        %         end
        tnd=TND{min(length(LM),j(T))};%�жϽ�ͨ����Ӧ��һ���Сʱ��
        pd = makedist('Normal',tnd(1),tnd(2));
        PD = truncate(pd,0.3,4);

        per=lm.predict(n);%Сʱ��ı���,�ٷֱ�
        if per<=0
            per=0;
        elseif per>=100
            per=100;
        end

        while t<300
            r=100*rand(1);
            if r<per
                [g(k)]= random(PD,1);%����Сʱ��
            else
                g(k)=exprnd(miu)+4;%����С��ʱ��
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
            g(k)=gamrnd(30.5786,15.0420);%��Խ�ͨ��Ϊ0��ʱ��
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
    vehicle{i}=generate_vehicle(road,N,type);%���ӵ����������غ����
end
vehicle=cell2mat(vehicle);
speed=cell2mat(speed);
gap=cell2mat(gap);
end

