function out=AlgoBSC(settings)

K=settings.K;

c=settings.c;                           %cost vector

p=settings.p;                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;

alpha=2.5;                        %alpha parameter in the algorithm

cdiff=zeros(K,1);

loss=p+c;
[opt, ~]=min(loss);               % optimal actions

for i=1:1:K
    cdiff(i)=c(1) - c(i);        % since agorithm works estimates the differences \gamma(1)-\gamma(i), we need the cost differences
end

Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
    ne=0;                                 % exploration count
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,1);                      % stores cumulative dis-agreements for estimation
    
   %% Intialization

     ycomp=playBSC(K, settings);            % play arm K and observe the predictions (disaggrements)
     RunLoss(1,1)=loss(K);                   % loss from playing arm K
     N(K)=1;                                % update count of arm played
     n(1:K)=n(1:K)+1;                       % update count of all observations
     feed=feed+ycomp;                       % update cumulative dis-agreements

     hatg=feed./n;                          % estimate of gamma;

  
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        Condn=ConfiSet(N, n, ne, 4*alpha*log(t), hatg+cdiff);      % checks for different condition of the algorithms
        if Condn(1)>0                                         % Check if number of pull of arms in inside confidence set. If yes, Condn(1) gives the index of arm to play
           I=Condn(1);                                    
           ycomp=playBSC(I,settings);                                  % observation from playing arm I
           N(I)=N(I)+1;                                       % update number of pulls of arm I
           n(1:I)=n(1:I)+1;                                   % update total observation of eac arm
        elseif Condn(2)>0                                      % check if each arm is explored sufficently. Condn(2) index of arm not explored sufficiently
           I=Condn(2);     
           ycomp=playBSC(I,settings);                                % 
           N(I)=N(I)+1;
           n(1:I)=n(1:I)+1;
           ne=ne+1;                                         % update number of explorations
        else
           I=Condn(3);                                      % select the arm thats condifence has to be improved
           ycomp=playBSC(I,settings);
           N(I)=N(I)+1;
           n(1:I)=n(1:I)+1;
           ne=ne+1;
        end
        
        RunLoss(t,1)=loss(I);                          % running loss from playing arm I
        feed=feed+ycomp;                               % update feedback
        hatg=feed./n;                                  % estimate gamma
        
    end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
Regs(:,i)=cumsum(regret,1);

end

out=Regs;
    