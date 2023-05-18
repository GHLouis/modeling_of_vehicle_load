function vehicle=generate_vehicle(road,n,p_type)
%n是生成的车辆数
% load GMM_result_clean.mat GMM_result;
load GMM_result_unclean.mat GMM_result;

switch road
    case 'GD'
        GMM_result=GMM_result{1};
    case 'GS'
        GMM_result=GMM_result{2};
end

% switch road
%     case 'GD'
%     case 'GS'
% end

%各种型号车的比例
% p=zeros(6,1);
p(1)=p_type(1);
p(2)=p_type(2);
p(3)=p_type(3);
p(4)=p_type(4);
p(5)=p_type(5);
p(6)=p_type(6);

j=find(p>0);
p=p(p>0);
% %
% p(1)=1/6;
% p(2)=1/6;
% p(3)=1/6;
% p(4)=1/6;
% p(5)=1/6;
% p(6)=1/6;

%生成各种型号车的序列
type=randsrc(n,1,[j;p]);
% type=randsample([1 2 3 4 5 6],n,true,[p1 p2 p3 p4 p5 p6]);
vehicle=zeros(n,13);



for i=1:6
    N=sum(type==i);
    x=zeros(N,13);
    if N>0
        switch i
            %二轴小车
            case 1
                %二轴小车
                pd=GMM_result{1}{1};
                x(:,1) = abs(random(pd,N));
                pd=GMM_result{1}{2};
                v1= abs(random(pd,N));
                pd=GMM_result{1}{3};
                v2= abs(random(pd,N));
                
                y1=v1./(v1+v2);
                y2=v2./(v1+v2);
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                
                pd=GMM_result{1}{4};
                x(:,8) = abs(random(pd,N));
                
                x(:,9) = x(:,8);
                
            case 2
                %二轴货车
                pd=GMM_result{2}{1};
                x(:,1) = abs(random(pd,N));
                
                pd=GMM_result{2}{2};
                v1= abs(random(pd,N));
                pd=GMM_result{2}{3};
                v2= abs(random(pd,N));
                
                y1=v1./(v1+v2);
                y2=v2./(v1+v2);
                
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                
                pd=GMM_result{2}{4};
                x(:,8) = abs(random(pd,N));
                
                x(:,9) = x(:,8);
                
                %三轴货车
            case 3
                %三轴货车
                pd=GMM_result{3}{1};
                x(:,1) = abs(random(pd,N));
                
                pd=GMM_result{3}{2};
                v1=abs(random(pd,N));
                
                pd=GMM_result{3}{3};
                v2=abs(random(pd,N));
                
                pd=GMM_result{3}{4};
                v3=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3);
                y2=v2./(v1+v2+v3);
                y3=v3./(v1+v2+v3);
                
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                x(:,4) = x(:,1).*y3;
                
                pd=GMM_result{3}{5};
                x(:,8) = abs(random(pd,N));
                
                pd=GMM_result{3}{6};
                v1=abs(random(pd,N));
                
                pd=GMM_result{3}{7};
                v2=abs(random(pd,N));
                
                y1=v1./(v1+v2);
                y2=v2./(v1+v2);
                
                x(:,9) = x(:,8).*y1;
                x(:,10) = x(:,8).*y2;
                
                
                %四轴货车
            case 4
                %四轴货车
                pd=GMM_result{4}{1};
                x(:,1) = abs(random(pd,N));
                
                
                pd=GMM_result{4}{2};
                
                v1=abs(random(pd,N));
                
                
                pd=GMM_result{4}{3};
                
                v2=abs(random(pd,N));
                
                
                pd=GMM_result{4}{4};
                
                v3=abs(random(pd,N));
                
                
                pd=GMM_result{4}{5};
                v4=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3+v4);
                y2=v2./(v1+v2+v3+v4);
                y3=v3./(v1+v2+v3+v4);
                y4=v4./(v1+v2+v3+v4);
                
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                x(:,4) = x(:,1).*y3;
                x(:,5) = x(:,1).*y4;
                
                
                pd=GMM_result{4}{6};
                x(:,8) = abs(random(pd,N));
                
                
                pd=GMM_result{4}{7};
                v1=abs(random(pd,N));
                
                pd=GMM_result{4}{8};
                v2=abs(random(pd,N));
                
                
                pd=GMM_result{4}{9};
                v3=abs(random(pd,N));
                
                
                y1=v1./(v1+v2+v3);
                y2=v2./(v1+v2+v3);
                y3=v3./(v1+v2+v3);
                
                x(:,9) = x(:,8).*y1;
                x(:,10) = x(:,8).*y2;
                x(:,11) = x(:,8).*y3;
                
                
                %五轴货车
            case 5
                %五轴货车
                pd=GMM_result{5}{1};
                x(:,1) = abs(random(pd,N));
                
                pd=GMM_result{5}{2};
                v1=abs(random(pd,N));
                pd=GMM_result{5}{3};
                v2=abs(random(pd,N));
                
                
                pd=GMM_result{5}{4};
                v3=abs(random(pd,N));
                
                pd=GMM_result{5}{5};
                v4=abs(random(pd,N));
                
                
                pd=GMM_result{5}{6};
                v5=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3+v4+v5);
                y2=v2./(v1+v2+v3+v4+v5);
                y3=v3./(v1+v2+v3+v4+v5);
                y4=v4./(v1+v2+v3+v4+v5);
                y5=v5./(v1+v2+v3+v4+v5);
                
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                x(:,4) = x(:,1).*y3;
                x(:,5) = x(:,1).*y4;
                x(:,6) = x(:,1).*y5;
                
                pd=GMM_result{5}{7};
                x(:,8) = abs(random(pd,N));
                
                pd=GMM_result{5}{8};
                v1=abs(random(pd,N));
                pd=GMM_result{5}{9};
                v2=abs(random(pd,N));
                
                pd=GMM_result{5}{10};
                v3=abs(random(pd,N));
                
                pd=GMM_result{5}{11};
                v4=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3+v4);
                y2=v2./(v1+v2+v3+v4);
                y3=v3./(v1+v2+v3+v4);
                y4=v4./(v1+v2+v3+v4);
                
                x(:,9) = x(:,8).*y1;
                x(:,10) = x(:,8).*y2;
                x(:,11) = x(:,8).*y3;
                x(:,12) = x(:,8).*y4;
                
                %六轴货车
            case 6
                %六轴货车
                pd=GMM_result{6}{1};
                x(:,1) = abs(random(pd,N));
                pd=GMM_result{6}{2};
                v1=abs(random(pd,N));
                pd=GMM_result{6}{3};
                v2=abs(random(pd,N));
                pd=GMM_result{6}{4};
                v3=abs(random(pd,N));
                
                pd=GMM_result{6}{5};
                v4=abs(random(pd,N));
                pd=GMM_result{6}{6};
                v5=abs(random(pd,N));
                pd=GMM_result{6}{7};
                v6=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3+v4+v5+v6);
                y2=v2./(v1+v2+v3+v4+v5+v6);
                y3=v3./(v1+v2+v3+v4+v5+v6);
                y4=v4./(v1+v2+v3+v4+v5+v6);
                y5=v5./(v1+v2+v3+v4+v5+v6);
                y6=v6./(v1+v2+v3+v4+v5+v6);
                
                x(:,2) = x(:,1).*y1;
                x(:,3) = x(:,1).*y2;
                x(:,4) = x(:,1).*y3;
                x(:,5) = x(:,1).*y4;
                x(:,6) = x(:,1).*y5;
                x(:,7) = x(:,1).*y6;
                pd=GMM_result{6}{8};
                x(:,8) = abs(random(pd,N));
                
                pd=GMM_result{6}{9};
                v1=abs(random(pd,N));
                
                pd=GMM_result{6}{10};
                v2=abs(random(pd,N));
                
                pd=GMM_result{6}{11};
                v3=abs(random(pd,N));
                
                pd=GMM_result{6}{12};
                v4=abs(random(pd,N));
                
                pd=GMM_result{6}{13};
                v5=abs(random(pd,N));
                
                y1=v1./(v1+v2+v3+v4+v5);
                y2=v2./(v1+v2+v3+v4+v5);
                y3=v3./(v1+v2+v3+v4+v5);
                y4=v4./(v1+v2+v3+v4+v5);
                y5=v5./(v1+v2+v3+v4+v5);
                
                x(:,9) = x(:,8).*y1;
                x(:,10) = x(:,8).*y2;
                x(:,11) = x(:,8).*y3;
                x(:,12) = x(:,8).*y4;
                x(:,13) = x(:,8).*y5;
                
        end
        vehicle(type==i,:)=x;
    end
end
vehicle=[type vehicle];
end
