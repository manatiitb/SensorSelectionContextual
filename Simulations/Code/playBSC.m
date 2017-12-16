function output=playBSC(k,settings)     % k is the index of the arm to play

K=settings.K;                  
ycomp=zeros(K,1);
bsc=settings.berr;
p=settings.p;

% x=(rand < bsc);y=x*ones(k,1); y(rand(k,1)<=p(1:k))=~x; 
% ycomp(1:k)=xor(y(1),y(1:k));
% flip out of ith channel with probability p

x=(rand < bsc);
y=ones(k,1);
for i=1:1:k
    if (rand<p(i))                 % with probability p, x is flipped
       y(i)= ~x;
    else
       y(i)=x;
    end
end

    
for i=1:1:k
    ycomp(i)=xor(y(1),y(i));
end

output=ycomp;




