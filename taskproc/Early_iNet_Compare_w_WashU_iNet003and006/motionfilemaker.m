base=dlmread('mot_demean.r01.1D');
baselength=size(base,1);
sessionnum=4;
sessionlength=baselength/sessionnum;
zeroscount=baselength-sessionlength;
runlength=450;
zerocoutrun=zeros(runlength,6);
%Loop to make files%
sessruns={{'01','02','03','04'},{'05','06','07','08'},{'09','10','11','12'},{'13','14','15','16'}};
for i=1:length(sessruns);
    for ii=1:4;
        target=sessruns{1,i};
        if ii==1;
            filetoget=['mot_demean.r' target{1,ii} '.1D'];
            mat=dlmread(filetoget);
            motion=mat(mat(:,1)~=0,:);
            bigmat=[motion;zerocoutrun;zerocoutrun;zerocoutrun];
            outputname=['mot_demean.r' target{1,ii} '_Ses' num2str(i) '.1D'];
            dlmwrite(outputname,bigmat,'delimiter',' ');
        elseif ii==2;
            filetoget=['mot_demean.r' target{1,ii} '.1D'];
            mat=dlmread(filetoget);
            motion=mat(mat(:,1)~=0,:);
            bigmat=[zerocoutrun;motion;zerocoutrun;zerocoutrun];
            outputname=['mot_demean.r' target{1,ii} '_Ses' num2str(i) '.1D'];
            dlmwrite(outputname,bigmat,'delimiter',' ');
        elseif ii==3;
            filetoget=['mot_demean.r' target{1,ii} '.1D'];
            mat=dlmread(filetoget);
            motion=mat(mat(:,1)~=0,:);
            bigmat=[zerocoutrun;zerocoutrun;motion;zerocoutrun];
            outputname=['mot_demean.r' target{1,ii} '_Ses' num2str(i) '.1D'];
            dlmwrite(outputname,bigmat,'delimiter',' ');
        elseif ii==4;
            filetoget=['mot_demean.r' target{1,ii} '.1D'];
            mat=dlmread(filetoget);
            motion=mat(mat(:,1)~=0,:);
            bigmat=[zerocoutrun;zerocoutrun;zerocoutrun;motion];
            outputname=['mot_demean.r' target{1,ii} '_Ses' num2str(i) '.1D'];
            dlmwrite(outputname,bigmat,'delimiter',' ');
        end
    end
end