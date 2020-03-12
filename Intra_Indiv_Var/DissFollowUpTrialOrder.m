%Script Makes Trial Order for the ST-SI Blocks%
%1=II
%2=IC
%3=CC
%4=CI
%My cells%
ListIncAB=10;
ListIncYZ=20;
ListConAB=30;
ListConYZ=40;
NumBlock=8;
BrokenVector=cell(49,NumBlock);
for i=1:NumBlock;
    BaseVector=listgen1(4,3);
    for ii=1:length(BaseVector);
        if BaseVector(ii)==1;
            BrokenVector{ii,i}=[ListIncAB;ListIncYZ];
        elseif BaseVector(ii)==2;
            BrokenVector{ii,i}=[ListIncAB;ListConYZ];
        elseif BaseVector(ii)==3;
            BrokenVector{ii,i}=[ListConAB;ListConYZ];
        elseif BaseVector(ii)==4;
            BrokenVector{ii,i}=[ListConAB;ListIncYZ];
        else
            disp('problem')
        end 
    end
end
NumMat=[];
for w=1:size(BrokenVector,2);
    Colholder=[];
    for ww=1:size(BrokenVector,1);
        Unit=BrokenVector{ww,w};
        Colholder=[Colholder;Unit];
    end
    NumMat(:,w)=Colholder;
end
TrimNumMat=NumMat(3:size(NumMat,1),:);
CheckConA=sum(TrimNumMat(:,1) == 30);
CheckConB=sum(TrimNumMat(:,1) == 40);
CheckIncA=sum(TrimNumMat(:,1) == 10);
CheckIncB=sum(TrimNumMat(:,1) == 20);
%Test II IC CC CI Balance: CC=1, CI=2, II=3, IC=4%
BalanceCheck=[];
for q=2:length(TrimNumMat(:,1));
    if TrimNumMat(q,1)==30 & (TrimNumMat(q-1,1)==30|TrimNumMat(q-1,1)==40);
        BalanceCheck(q)=1;
    elseif TrimNumMat(q,1)==40 & (TrimNumMat(q-1,1)==30|TrimNumMat(q-1,1)==40); %don't the or statement can remove the on that correpsonds to B or vice versa in the case of an a trial%
        BalanceCheck(q)=1;
    elseif TrimNumMat(q,1)==10 & (TrimNumMat(q-1,1)==30|TrimNumMat(q-1,1)==40);
        BalanceCheck(q)=2;
    elseif TrimNumMat(q,1)==20 & (TrimNumMat(q-1,1)==30|TrimNumMat(q-1,1)==40);
        BalanceCheck(q)=2;
    elseif TrimNumMat(q,1)==10 & (TrimNumMat(q-1,1)==10|TrimNumMat(q-1,1)==20);
        BalanceCheck(q)=3;
    elseif TrimNumMat(q,1)==20 & (TrimNumMat(q-1,1)==10|TrimNumMat(q-1,1)==20);
        BalanceCheck(q)=3;
    elseif TrimNumMat(q,1)==30 & (TrimNumMat(q-1,1)==10|TrimNumMat(q-1,1)==20);
        BalanceCheck(q)=4;
    elseif TrimNumMat(q,1)==40 & (TrimNumMat(q-1,1)==10|TrimNumMat(q-1,1)==20);
        BalanceCheck(q)=4;
    else
        disp('problem')
    end
end
CheckCC=sum(BalanceCheck(:) == 1);
CheckCI=sum(BalanceCheck(:) == 2);
CheckII=sum(BalanceCheck(:) == 3);
CheckIC=sum(BalanceCheck(:) == 4);
Eprimestack=[];
for t=1:size(TrimNumMat,2);
    grab=TrimNumMat(:,t);
    Eprimestack=[Eprimestack;grab];
end
global EprimeCell;
EprimeCell=cell(length(Eprimestack),1);
for qu=1:length(Eprimestack);
    if Eprimestack(qu)==10;
        EprimeCell{qu,1}='ListIncAB';
    elseif Eprimestack(qu)==20;
        EprimeCell{qu,1}='ListIncYZ';
    elseif Eprimestack(qu)==30;
        EprimeCell{qu,1}='ListConAB';
    elseif Eprimestack(qu)==40;
        EprimeCell{qu,1}='ListConYZ';
    else
        disp('problem')
    end
end
%BreakUp into Two Segs%
STandSIOne=cell(384,1);
STandSITwo=cell(384,1);
LengthofSeg=(length(EprimeCell)/2);
for BOne=1:LengthofSeg
STandSIOne{BOne,1}=EprimeCell{BOne,1};
end
for BTwo=1:LengthofSeg
STandSITwo{BTwo,1}=EprimeCell{(BTwo+384),1};
end