function out=BSCUCB_SD(settings)

K=settings.K;
Data=settings.Data;
c=settings.c;                           %cost vector

gamma=settings.gamma';                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;

loss=gamma+c;
[opt, ~]=min(loss);               % optimal actions


cdiff=c(1)+c(K)-c;        % since agorithm works estimates the differences \gamma(1)-\gamma(i), we need the cost differences


Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,1);                      % stores cumulative dis-agreements for estimation
    
   %% Intialization

     y=Data(1, 1:K)'; ycomp=xor(y(1), y);            % play arm K and observe the predictions (disaggrements)
     RunLoss(1,1)=loss(K);                   % loss from playing arm K
     N(K)=1;                                % update count of arm played
     n(1:K)=n(1:K)+1;                       % update count of all observations
     feed=feed+ycomp;                       % update cumulative dis-agreements

     hatg=feed./n;                          % estimate of gamma;

  
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        
        UCB= hatg + sqrt(1.5*log(t)./n) + cdiff;
        
        
      
        [~, I]=max(UCB);
        
        y=Data(t,1:I)'; ycomp=zeros(K,1); ycomp(1:I,1)=xor(y(1),y); %ycomp=playBSC(I,settings);
        N(I)=N(I)+1;
        n(1:I)=n(1:I)+1;

        
        RunLoss(t,1)=loss(I);                          % running loss from playing arm I
        feed=feed+ycomp;                               % update feedback
        hatg=feed./n;                                  % estimate gamma
        
    end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
    Regs(:,i)=cumsum(regret,1);

end

out=Regs;
    