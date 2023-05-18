function [TL] = Aritificial(road,n,L)
%计算概率模型的总荷载
% n为生成数据的组数
TL=zeros(604800/1,n);
parfor j=1:n
    queue=cell(3,1);
    [queue{1}]=generate_quene(road,1,7);
    [queue{2}]=generate_quene(road,2,7);
    [queue{3}]=generate_quene(road,3,7);
    total=cell(3,1);
    TOTAL=cell(7,1);
    for i=1:7
        for N=1:3
            total{N} = Total_load(queue{N}{i},L);
        end
        TOTAL{i}=total{1}+total{2}+total{3};%总荷载
    end
    TOTAL=cell2mat(TOTAL);
    TL(:,j)=TOTAL;
end
end


% function [TL] = Aritificial(road,n)
% %计算概率模型的总荷载
% % n为生成数据的组数
% TL=zeros(604800,n);
% parfor j=1:n
%     TOTAL=cell(7,1);
%     for i=1:7
%         queue=cell(3,1);
%         [queue{1}]=generate_quene(road,1);
%         [queue{2}]=generate_quene(road,2);
%         [queue{3}]=generate_quene(road,3);
%         total=cell(3,1);
%         for N=1:3
%             total{N} = Total_load(queue{N},800);
%         end
%         TOTAL{i}=total{1}+total{2}+total{3};%总荷载
%     end
%     TOTAL=cell2mat(TOTAL);
%     TL(:,j)=TOTAL;
% end
% end


