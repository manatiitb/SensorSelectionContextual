function out=BSCUCB_Std(settings)

K=settings.K;
berr=settings.berr;
c=settings.c;                           %cost vector

p=settings.p;                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;


loss=p+c;
[opt, ~]=min(loss);               % optimal actions


Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,1);                      % stores cumulative dis-agreements for estimation
    hatg=zeros(K,1);
    UCB=zeros(K,1);  
   
    %% Intialization
     I=K;
     x=(rand < berr);y=x*ones(I,1); y(rand(I,1)<=p(1:I))=~x;  % play arm K and observe the predictions (disaggrements)                  
     N(I)=N(I)+1;                                % update count of arm played
     n(1:I)=n(1:I)+1;                       % update count of all observations
     RunLoss(1,1)=loss(I);                  % loss from playing arm K
     for j=1:1:I
         feed(j)=feed(j)+xor(x,y(j));
         hatg(j)=feed(j)/n(j);
     end
  
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        
        for j=1:1:K
            UCB(j)= hatg(j) - sqrt(1.5*log(t)/n(j)) + c(j);
        end
        
        [~, I]=min(UCB);
        
         x=(rand < berr);y=x*ones(I,1); y(rand(I,1)<=p(1:I))=~x;  % play arm K and observe the predictions (disaggrements)                  
         N(I)=N(I)+1;                                % update count of arm played
         n(1:I)=n(1:I)+1;                       % update count of all observations
         RunLoss(t,1)=loss(I);                  % loss from playing arm K
        for j=1:1:I
            feed(j)=feed(j)+xor(x,y(j));
            hatg(j)=feed(j)/n(j);
        end      
    end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
    Regs(:,i)=cumsum(regret,1);

end

out=Regs;
    