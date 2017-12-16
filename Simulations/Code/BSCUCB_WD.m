function out=BSCUCB_WD(settings)

K=settings.K;
c=settings.c;                           %cost vector
berr=settings.berr;
p=settings.p;                               %error vector
T=settings.T;                           % number of rounds
iterations=settings.iterations;

loss=p+c;
[opt, ~]=min(loss);               % optimal actions
cdiff=zeros(K,K);

for j=2:1:K
    for k=1:1:j-1
        cdiff(j,k)=c(j)-c(k);        % since agorithm works estimates the differences \gamma(1)-\gamma(i), we need the cost differences
    end
end

Regs=zeros(T,iterations);

for i=1:1:iterations
    RunLoss=zeros(T,1);                   % For each iteration stores the loss of action taken in each round
    N=zeros(K,1);                         % number of pulls of each arm
    n=zeros(K,1);                         % total number of observation of each arm
   % ycomp=zeros(K,1);                     % pairwise aggrements (comparison of y)
    feed=zeros(K,K);                      % stores cumulative dis-agreements for estimation
    hatg=zeros(K,K);
    UCB=zeros(K,K);  
   
    %% Intialization
     I=K;
     x=(rand < berr);y=x*ones(I,1); y(rand(I,1)<=p(1:I))=~x;  % play arm K and observe the predictions (disaggrements)                  
     N(I)=N(I)+1;                                % update count of arm played
     n(1:I)=n(1:I)+1;                       % update count of all observations
     RunLoss(1,1)=loss(I);                  % loss from playing arm K
     
     for j=2:1:I
         for k=1:1:j-1
             feed(j,k)=feed(j,k)+xor(y(j),y(k));    % update all pairwise dis-agreements
             hatg(j,k)=feed(j,k)/n(j);
     %        UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
    %% main algorithm 
    for t=2:1:T
        if  rem(t,ceil(T/10))==1,
            fprintf(1,'.'); % fprintf('%d/%d\n',t,T);
        end
        
        
    for j=2:1:K
         for k=1:1:j-1
             UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
    

    %%% implements sorting algorithm and find the best arm
    flag=1;
    for j=1:1:K-1
        if all(cdiff((j+1):K,j)>=UCB((j+1):K,j))
            I=j;
            flag=0;
            break;
        else
            continue;
        end
    end   
     
     %% if no arm is found to be unambiguouly optimal then
     if flag
         I=K;
     end
     
     x=(rand < berr);y=x*ones(I,1); y(rand(I,1)<=p(1:I))=~x;  % play arm K and observe the predictions (disaggrements)
        
     N(I)=N(I)+1;                                % update count of arm played
     n(1:I)=n(1:I)+1;                            % update count of all observations
     RunLoss(t,1)=loss(I);                       % running loss from playing arm I
     
     for j=2:1:I
         for k=1:1:j-1
             feed(j,k)=feed(j,k)+xor(y(j),y(k));    % update all pairwise dis-agreements
             hatg(j,k)=feed(j,k)/n(j);
      %       UCB(j,k)=hatg(j,k) + sqrt(1.5*log(t)/n(j));
         end
    end
     
        
   end  
 
    regret =  RunLoss- repmat(opt, size(RunLoss));
    Regs(:,i)=cumsum(regret,1);

end

out=Regs;
    