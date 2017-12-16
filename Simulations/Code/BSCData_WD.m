
K=settings.K;
bsc=settings.berr;                             % input label distribution, probability of 0
p=settings.p;

DataSize=1000000;



ErrDiff=zeros(K, K);      % stores probability of disagreement between each pair of sensors
ErrJoint=zeros(K, K);     % for each pair, stores probability of cheap sensor is correct and constlier one incorrect

Data= rand(DataSize,1)<bsc;   %generate data;

y=zeros(DataSize,K);

y(:,1)=Data; index=find(rand(DataSize,1)<p(1)); y(index,1)=~y(index,1);     % predictions of BSC channel 1

for i=2:1:K
    y(:,i)=Data; index=find(rand(DataSize,1)<p(i)); y(index,i)=~y(index,i); % predictions of ith channel
    Costly=y(:,i);
    for j=1:1:i-1
        Cheap=y(:,j);
        ErrDiff(i,j)=sum(Cheap~=Costly)/DataSize;
        index=find(Data==Cheap);                 % find where cheap sensor is correct
        ErrJoint(i,j)=sum(Cheap(index)~=Costly(index))/DataSize;
    end
end

fprintf(settings.fid, 'Statistics for BSC dataset\n\n');
fprintf(settings.fid, '1. Error rate of each classifier\n');
fprintf(settings.fid, '\n2. probability that cheap sensor is correct and costly one is incorrect (for each pair):\n');
fprintf(settings.fid, '\n3. probability that cheap and costly sensors disagree (for each pair):\n');
dlmwrite('errorstat.txt',p,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrJoint,'-append', 'roffset',1, 'precision','%4.3f');
dlmwrite('errorstat.txt',ErrDiff, '-append', 'roffset',1, 'precision','%4.3f');



    
    
    
    
    


