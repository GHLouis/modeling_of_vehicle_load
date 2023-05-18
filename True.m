function [TL] = True(road,L)
%计算实测数据的总荷载，需要加上假设，即：五分钟内车速不变。
switch road
    case 'GD'
        load GD.mat data1 data2 data3 data4 data5 data6 data7;
    case 'GS'
        load GS.mat data1 data2 data3 data4 data5 data6 data7;
end

[data1] = data_clean(data1);
[data2] = data_clean(data2);
[data3] = data_clean(data3);
[data4] = data_clean(data4);
[data5] = data_clean(data5);
[data6] = data_clean(data6);
[data7] = data_clean(data7);

TOTAL=cell(3,1);
for nol=1:3
%     [laneout{1}] = (lane(data1,nol));%laneout{1}表示的是车道编号为nol的第1天的数据
%     [laneout{2}] = (lane(data2,nol));%车道编号为nol的第2天的数据
%     [laneout{3}] = (lane(data3,nol));%车道编号为nol的第3天的数据
%     [laneout{4}] = (lane(data4,nol));%车道编号为nol的第4天的数据
%     [laneout{5}] = (lane(data5,nol));%车道编号为nol的第5天的数据
%     [laneout{6}] = (lane(data6,nol));%车道编号为nol的第6天的数据
%     [laneout{7}] = (lane(data7,nol));%车道编号为nol的第7天的数据
    
    [laneout{1}] = assume(lane(data1,nol));%laneout{1}表示的是车道编号为nol的第1天的数据
    [laneout{2}] = assume(lane(data2,nol));%车道编号为nol的第2天的数据
    [laneout{3}] = assume(lane(data3,nol));%车道编号为nol的第3天的数据
    [laneout{4}] = assume(lane(data4,nol));%车道编号为nol的第4天的数据
    [laneout{5}] = assume(lane(data5,nol));%车道编号为nol的第5天的数据
    [laneout{6}] = assume(lane(data6,nol));%车道编号为nol的第6天的数据
    [laneout{7}] = assume(lane(data7,nol));%车道编号为nol的第7天的数据
    
    total=cell(7,1);
    for i=1:7
        data=laneout{i};
        queue=zeros(size(data,1),19);
        queue(:,1)=(1:length(data))';%序列
        queue(:,2)= data(:,5)*12;%时间
        queue(:,4)= data(:,10);%速度
        queue(:,7)= data(:,19)/100;%车重
        total{i} = Total_load(queue,L);
    end
    total=cell2mat(total);
    TOTAL{nol}=total;
end
TL=TOTAL{1}+TOTAL{2}+TOTAL{3};
end