%Makes the schedule for Intra-Indiv Var Study%
%1=Stroop
%2=GoNoGo
%3=Flanker
%4=Prime Probe
% SG=repmat([1,2],1,5);
% GS=repmat([2,1],1,5);
% SF=repmat([1,3],1,5);
% FS=repmat([3,1],1,5);
% SP=repmat([1,4],1,5);
% PS=repmat([4,1],1,5);
% GF=repmat([2,3],1,5);
% FG=repmat([3,2],1,5);
% GP=repmat([2,4],1,5);
% PG=repmat([4,2],1,5);
% FP=repmat([3,4],1,5);
% PF=repmat([4,3],1,5);
% combovector=[[1;2],[2;1],[1;3],[3;1],[1;4],[4;1],[2;3],[3;2],[2;4],[4;2],[3;4],[4;3]];
% taskcombos=repmat([1,2,3,4,5,6,7,8,9,10,11,12],1,5);
% subschedule=cell(1,60);
% target=[120,120,120,120];%Note we want two times per week for 60 weeks, each cell is a task%
% iter=[];
% for i=1:60;
%     while ~isequal(target,iter);
%     iter=[0,0,0,0];
%     test=combovector(:,Shuffle(taskcombos));
%     stp=1;
%     ep=4;
%     for ii=1:length(test)/4; %Each week%
%         week=test(:,stp:ep);
%         Stroop=length(find(week==1));
%         GoNoGo=length(find(week==2));
%         Flanker=length(find(week==3));
%         PrimeProbe=length(find(week==4));
%         iter(1)=iter(1)+Stroop;
%         iter(2)=iter(2)+GoNoGo;
%         iter(3)=iter(3)+Flanker;
%         iter(4)=iter(4)+PrimeProbe;
%         stp=ep+1;
%         ep=stp+3;
%         if numel(unique(iter))~=1;
%                break
%         end
%     end
%     end
% end
combocell={'Stroop;GoNoGo','GoNoGo;Stroop','Stroop;Flanker','Flanker;Stroop','Stroop;PrimeProbe','PrimeProbe;Stroop','GoNoGo;Flanker','Flanker;GoNoGo','GoNoGo;PrimeProbe','PrimeProbe;GoNoGo','Flanker;PrimeProbe','PrimeProbe;Flanker'};
taskcombos=repmat([1,2,3,4,5,6,7,8,9,10,11,12],5,1);
target=ones(1,12)*5;
overallcount=zeros(1,12);
Stroop=[1,2,3,4,5,6];
GoNoGo=[1,2,7,8,9,10];
Flanker=[3,4,7,8,11,12];
PrimeProbe=[5,6,9,10,11,12];
schedule=cell(60,1);
while ~isequal(target,overallcount);
overallcount=zeros(1,12);
weeks=[];
weekcount=[0,0,0,0];
for i=1:60;
    weekcount=[0,0,0,0];
    while ~and(sum(weekcount)>0,numel(unique(weekcount)~=1));
    weekcount=[0,0,0,0];
%     for day=1:4;
%         pairs=[[1;2],[1;3],[1;4],[2;3],[2;4],[3;4]];
%     end
      rng('shuffle');  
      week=[randperm(12,1),randperm(12,1),randperm(12,1),randperm(12,1)];
    
        Stroopcount=numel(unique(find(Stroop==week(1))));
        GoNoGocount=numel(unique(find(GoNoGo==week(2))));
        Flankercount=numel(unique(find(Flanker==week(3))));
        PrimeProbecount=numel(unique(find(PrimeProbe==week(4))));
        weekcount=[Stroopcount,GoNoGocount,Flankercount,PrimeProbecount];

    end
    weeks=[weeks;week];
end
for count=1:12;
    overallcount(count)=numel(unique(find(weeks==count)));
end
end