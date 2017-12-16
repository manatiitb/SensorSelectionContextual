function output=playarm(k,settings)     % k is the index of the arm to play

K=settings.K;
y=zeros(k,1);                   
ycomp=zeros(K,1);
svm=settings.svm;
data=settings.data;
dataSize=size(data,1);
x=data(randi(dataSize),:);              % Select a data point randomly from the dataset
FeaLen=settings.FeaLen;                 %Length of feature vector for each classifier.
for i=1:1:k
    y(i)=predict(svm{i},x(1:FeaLen(i)));
end


for i=1:1:k
    ycomp(i)=xor(y(1),y(i));
end
output=ycomp;
end



