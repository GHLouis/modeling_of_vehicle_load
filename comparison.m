% 此脚本用来比较生成的样本与实测的样本
% 历时 491.665538 秒。


tic
[TLA1] = Aritificial('GD',10,800);
[TLT1] = True('GD',800);
[TLA2] = Aritificial('GD',10,40);
[TLT2] = True('GD',40);

[TLA3] = Aritificial('GS',10,800);
[TLT3] = True('GS',800);
[TLA4] = Aritificial('GS',10,40);
[TLT4] = True('GS',40);
toc


TLA=TLA1;TLT=TLT1;

% TLA=TLA2;TLT=TLT2;

% TLA=TLA3;TLT=TLT3;
% 
% TLA=TLA4;TLT=TLT4;


%10组数据
figure
hold on;
c=2;
% for i=1:10
for i=1:(size(TLA,2))
TL=TLA(:,i);
A=reshape(TL,[length(TL)/168/c,c*168]);
ma=max(A);
[f1,x1]=ecdf(ma);
f1=-log(-log(f1));
h1=plot(x1,f1,'b.','linewidth',1.5);
end


T=reshape(TLT,[length(TLT)/168/c,c*168]);
mt=max(T);
[f2,x2]=ecdf(mt);
f2=-log(-log(f2));
h2=plot(x2,f2,'r','linewidth',2);
xlabel('Total load(kN)')
ylabel('CDF:-ln(-ln(F(x)))')
legend([h1 h2],'MCS','Actual','Location','Northwest')
