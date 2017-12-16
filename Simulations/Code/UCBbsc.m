function out=UCBbsc(settings)

p=settings.p;                             % input label distribution, probability of 0
p1=settings.p1;                            % error prob of sensor 1
p2=settings.p2;                            % error prob of sensor 2
c=settings.c;
T=settings.T;                           % number of rounds
iterations=settings.iterations;

Regs=zeros(T,iterations);

for i=1:1:iterations
    
    opt=max(p1-p2,c);               % optimal actions
    loss=zeros(T,1);
    N2=0;                           % counts of arm-2 pulls
    ltot=0;
    
    for t=1:1:T
        if t==1
           x=(rand < p);                 %generate input labels 0 with prob p
    
           y1=BSC(x,p1);               % output of sensor 1
           y2=BSC(x,p2);               % output of sensor 2
           l=xor(y1,y2);
           N2=N2+1;
           ltot=ltot+l;    
           loss(t,1)=p1-p2;     % loss from action 2;
        else
           x=(rand < p);
           y1=BSC(x,p1);                   % always read sensor 1
    
           UCB= ltot/N2 + sqrt(2*log(t)/N2);
    
           if UCB > c
              y2=BSC(x,p2);               % output of sensor 2
              l=xor(y1,y2);
              N2=N2+1;
              ltot=ltot+l;
              loss(t,1)=p1-p2;
           else
              loss(t,1)=c;
           end
        end
    end
    regret =  repmat(opt, size(loss))-loss;
    Regs(:,i) = cumsum(regret,1);
end        
out= Regs;
    