%function SAP (p,p1,p2,c)
clc;
clear all;
settings=[];
settings.K=3;
settings.berr=.7;                           % probability of input symbol (1)
settings.c=zeros(settings.K,1);                      % Error rate of each channel
settings.T=100000;                           % number of rounds
settings.iterations=10;
settings.fid=fopen('errorstat.txt','w+');

%settings.p=[.25 .1]';
%settings.c=[0 .03 .05 .12 .4]';
settings.p=[.4 .1 .05]';
settings.c=[0 .1  .4]';

BSCData_SD;

%settings.c=[0 .1]';

stylem = {'-^','-d','-s','-x','-.','-v','.','--x','--o','--v','--^','--'};
colorm = [0 0 0;0 0 1;0 1 0;1 0 0;0.1*[1 1 1];0.6*[1 1 1];0 0 0;0 0 0;0 0 0;0 0 0;0.1 0.9 0.1;0.8 .9 0.8];

ind=1:0.05*settings.T:settings.T;
figure;
hold on;
m=0;
C=0.2:0.02:0.28;
R=(settings.c(3)-C)./0.15;
Reward=zeros(size(C,2),1);
leg = {};
for c=C
    m=m+1;
    settings.c(2)=c;
    Regs=BSCUCB_SD(settings);
    RegPerRound=Regs(settings.T,:)/settings.T;
    Reward(m,1)=mean(RegPerRound,2);
    Reg=mean(Regs,2);
    ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
    errorbar(ind, Reg(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
    leg{m} = sprintf('c_2=%4.3f',c);
    fprintf('.......\nFor BSC %d/%d completed\n', m, size(C,2));
end

legend(leg,'fontsize',12,'Location','NorthWest');
legend('boxoff')
 xlabel('Time T','fontsize',12);
ylabel('Cummulative regret','fontsize',12);
title('BSC','fontsize',12);



% for c=C
%     m=m+1;
%     settings.c(2)=c;
%     Regs=BSCUCB_WD(settings);
%     RegPerRound=Regs(settings.T,:)/settings.T;
%     Reward(m,1)=mean(RegPerRound,2);
%     Reg=mean(Regs,2);
%     ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
%     errorbar(ind, Regs(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
%     leg{m} = sprintf('c=%4.3f', c);
%     fprintf('.......\nFor BSC %d/%d completed\n', m, size(C,2));
% end

%legend(leg,'fontsize',12,'Location','NorthWest');
%legend('boxoff')
% xlabel('R','fontsize',12);
% ylabel('Regret per round','fontsize',12);
% title('BSC','fontsize',12);




% figure;
% plot(R, Reward, '-*r', 'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6);
% 
% 
% m=0;
% Reward=zeros(size(C,2),1);
% leg = {};
% 
% for c=C
%     m=m+1;
%     settings.c(2)=c;
%     Regs=AlgoBSC(settings);
%     RegPerRound=Regs(settings.T,:)/settings.T;
%     Reward(m,1)=mean(RegPerRound,2);
%     %Reg=mean(Regs,2);
%     %ConfBound=1.96*std(Regs,1,2)/sqrt(settings.iterations);
%     %errorbar(ind, Reg(ind), ConfBound(ind), stylem{m},'Color',colorm(m,:),'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6)
%     %leg{m} = sprintf('c=%4.3f', c);
%     fprintf('.......\nFor BSC %d/%d completed\n', m, size(C,2));
% end
% 
% plot(R, Reward, '-^b', 'LineWidth',2,'MarkerFaceColor','auto','MarkerSize',6);
% 
% xlabel('R','fontsize',12);
% ylabel('Regret per round','fontsize',12);
% title('BSC','fontsize',12);



    
    
    
    
    


