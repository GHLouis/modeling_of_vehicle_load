close all
%获得交通模式的参数，结果储存在矩阵PARA中
%第1列代表107的数据，第2列代表广深的数据
Q=cell(3,2);
V=cell(3,2);
H=cell(3,2);
TND=cell(3,2);
LM=cell(3,2);
NLM=cell(3,2);
pd_ratio=cell(3,2);
QV_dist=cell(3,2);
%先加载107的数据，再加载广深的数据
load('GS.mat')

[data1] = data_clean(data1);
[data2] = data_clean(data2);
[data3] = data_clean(data3);
[data4] = data_clean(data4);
[data5] = data_clean(data5);
[data6] = data_clean(data6);
[data7] = data_clean(data7);
for j=1:2 %1代表107，2代表广深
    for nol=1:3
        % 提取数据
        [Q{nol,j},V{nol,j},H{nol,j},TND{nol,j},LM{nol,j},NLM{nol,j}]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,nol);%这里面的图没有显示(之前写的) 20220517这一行代码已经检查，发现large headway拟合并不好！！！ 
        % 建立统计模型
        % 车流量车速模型
        QV_dist{nol,j}=generate_volume_volecity(Q{nol,j},V{nol,j}); % 20220520 这一行代码已经检查
        % 车辆类型比例模型
        pd_ratio{nol,j}=generate_heavy_vehicle_ratio(data1,data2,data3,data4,data5,data6,data7,nol); % 20220517这一行代码已经检查，用正态分布拟合车型比例，效果并不好，原因是数据太少，每个时段只有7个数据！！！
    end
end
close all
%然后最后储存结果，删除除上述变量以外的变量
% save PARA;
% 
% close all
% [Q,V,H,TND,LM,NLM]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,1);
% [Q,V,H,TND,LM,NLM]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,2);
% [Q,V,H,TND,LM,NLM]=per_small_volume(data1,data2,data3,data4,data5,data6,data7,3);

% for j=1:2 %1代表107，2代表广深
%     for nol=1:3
%         pd_ratio{nol,j}=generate_heavy_vehicle_ratio(data1,data2,data3,data4,data5,data6,data7,nol);
%     end
% end