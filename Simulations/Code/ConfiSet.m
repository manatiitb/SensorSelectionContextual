function out=ConfiSet(N, n, ne, const, Ecost)


Condn=zeros(3,1);
K=size(N,1);              
Del=zeros(K,1);          %stores sub-optimality gap


% Consistency check
for i=1:1:K
    if n(i)~= sum(N(i:K))
        fprintf('something wrong, N not equal to n in Confiset')
        quit;
    end
end

[opt, optind]=max(Ecost);  % find best action with respect to the current estimates (we have differences hence max)
for i=1:1:K
    Del(i,1)=opt-Ecost(i);   %find sub-optimality gap
end

Del1=Del;


% Check if there are multiple optimal actions. If yes, force explorations.
if sum(Del==0)==1                     % if optimal arm is unique, continue  
    Del1(optind,1)=min(Del(Del>0));
else                              % otherwise force exploration and return
    [~, Condn(2)]=min(n);
    out=Condn;
    return;
end

Del1(optind,1)=min(Del(Del>0)); % replace zero gap of optimal arm by smallest positive sub-optimality gap;

D=0.5./(Del1.^2);

if sum((n/const)>=D)==K       % check if the current number of pulls falls in the confidence bound
    Condn(1)=optind;          % if yes, find the best arm with respect to the current estimate
    out=Condn;
    return;
end

if min(n) < ne/(2*K)          %
    [~, Condn(2)]=min(n);
    out=Condn;
    return;
end

options = optimoptions(@linprog,'Display','off');

[ustar, ~]=linprog(Del, -triu(ones(K)), -D, [], [], zeros(K,1), inf*ones(K,1),n,options);

ustar(optind)=1/(Del1(optind))^2;

%i=K;

% while N(i) >= ustar(i)*const
%     if i==0
%         fprintf('Error in algo');
%     end
%     i=i-1;
% end
% if all(size(ustar)==[K 1])
%     fprintf('something wrong');
% end

if size(N)~=size(ustar)
    fprintf('Linear program was not successful, forcing exploration');
    [~, Condn(2)]=min(n);
    out=Condn;
    return;
end
A=N/const < ustar;
if any(A)
    Condn(3)=find(A, 1, 'last');
else
    fprintf('Error in confidence bound inclusion: ConfiSet.m');
    exit;
end

out=Condn;

end


    
