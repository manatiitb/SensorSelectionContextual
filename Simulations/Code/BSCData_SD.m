K=settings.K;
DataSize=settings.T;
SensorOut=zeros(DataSize,K);
pprior=settings.berr;
p=0.4*ones(K,1);
Data= (rand(DataSize,1) <= pprior); 
Data=double(Data);
for i=1:1:K
    if i==1
       SensorOut(:,i)=bsc(Data, p(i));
    else
       SensorOut(:,i)=SensorOut(:,i-1);
       ind=find(SensorOut(:,i)~=Data);
       SensorOut(ind,i)=bsc(Data(ind),p(i));
    end
end


[~,settings.gamma]=biterr(SensorOut,Data);
settings.Data=SensorOut;

ErrDiff=zeros(K, K);      % stores probability of disagreement between each pair of sensors
ErrJoint=zeros(K, K);     % for each pair, stores probability of cheap sensor is correct and constlier one incorrect

for i=2:1:K
    for j=1:1:i-1
        ErrDiff(i,j)=sum(SensorOut(:,i)~=SensorOut(:,j))/DataSize;
        index=find(Data==SensorOut(:,j));                 % find where cheap sensor is correct
        ErrJoint(i,j)=sum(SensorOut(index,j)~=SensorOut(index,i))/DataSize;
    end
end

fprintf(settings.fid, 'Statistics for BSC dataset\n\n');
fprintf(settings.fid, '1. Error rate of each classifier\n');
fprintf(settings.fid, '\n2. probability that cheap sensor is correct and costly one is incorrect (for each pair):\n');
fprintf(settings.fid, '\n3. probability that cheap and costly sensors disagree (for each pair):\n');
dlmwrite('errorstat.txt',settings.gamma,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrJoint,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrDiff, '-append', 'roffset',1, 'precision','%4.3f');



% p1=.3; p2=p1; p3=p2;
% y=Data;
% y1=bsc(y,p1);
% ind1=find(y1~=y);
% y2=y1;
% y2(ind1)=bsc(y(ind1),p2);
% ind2=find(y2~=y);y3=y2;
% y3(ind2)=bsc(y(ind2),p3);
% [~, g1]=biterr(y,y1);
% [~, g2]=biterr(y,y2);
% [~, g3]=biterr(y,y3);
% [g1 g2 g3 ; gamma']
 
 %%% For weak domainance
%  p1c = 0.1; p2c=0.1;
%  ind1c=find(y1=y);y2(ind1c) = bsc(y(ind1c),p2c);
%  ind2c=find(y2=y);y3(ind2c) = bsc(y(ind2c),p3c);