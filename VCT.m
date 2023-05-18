function C = VCT(c)
%% vehicle class transformation
% c --class index
% tabulate(c)
C = zeros(size(c));
% fprintf('Data before cleaning: %d\n',size(data,1));
% tabulate(c)
C(c==12 | c==13) = 1;
C(c==11) = 2;
C(c==0 | c==110) = 3;
C(c==1 | c==111) = 4;
C(c==3) = 5;
C(c==7) = 6;
C(c==10) = 7;

% C(C==0) = [];
end

