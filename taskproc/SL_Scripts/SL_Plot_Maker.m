%Task%
task=0 %1=Mixed 0=Am%
%load files%
tentnum=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27];
spec='%f';
    fileid=fopen('dacc_corr1_3_betas.txt');
    dacc_corr1_3_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_corr4_betas.txt');
    dacc_corr4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_corr5_betas.txt');
    dacc_corr5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_corr6_betas.txt');
    dacc_corr6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_corr7_betas.txt');
    dacc_corr7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_error_omission_betas.txt');
    dacc_error_omission_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_error4_betas.txt');
    dacc_error4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_error5_betas.txt');
    dacc_error5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_error6_betas.txt');
    dacc_error6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('dacc_error7_betas.txt');
    dacc_error7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_corr1_3_betas.txt');
    MidCing_corr1_3_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_corr4_betas.txt');
    MidCing_corr4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_corr5_betas.txt');
    MidCing_corr5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_corr6_betas.txt');
    MidCing_corr6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_corr7_betas.txt');
    MidCing_corr7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_error_omission_betas.txt');
    MidCing_error_omission_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_error4_betas.txt');
    MidCing_error4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_error5_betas.txt');
    MidCing_error5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_error6_betas.txt');
    MidCing_error6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('MidCing_error7_betas.txt');
    MidCing_error7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_corr1_3_betas.txt');
    Lai_corr1_3_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_corr4_betas.txt');
    Lai_corr4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_corr5_betas.txt');
    Lai_corr5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_corr6_betas.txt');
    Lai_corr6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_corr7_betas.txt');
    Lai_corr7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_error_omission_betas.txt');
    Lai_error_omission_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_error4_betas.txt');
    Lai_error4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_error5_betas.txt');
    Lai_error5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_error6_betas.txt');
    Lai_error6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Lai_error7_betas.txt');
    Lai_error7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_corr1_3_betas.txt');
    Rai_corr1_3_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_corr4_betas.txt');
    Rai_corr4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_corr5_betas.txt');
    Rai_corr5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_corr6_betas.txt');
    Rai_corr6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_corr7_betas.txt');
    Rai_corr7_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_error_omission_betas.txt');
    Rai_error_omission_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_error4_betas.txt');
    Rai_error4_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_error5_betas.txt');
    Rai_error5_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_error6_betas.txt');
    Rai_error6_betas=fscanf(fileid,spec);
    fclose(fileid);
    fileid=fopen('Rai_error7_betas.txt');
    Rai_error7_betas=fscanf(fileid,spec);
    fclose(fileid);
    
taskname='_';
figure(1)
plot(tentnum,dacc_corr1_3_betas,tentnum,dacc_corr4_betas,tentnum,dacc_corr5_betas,tentnum,dacc_corr6_betas,tentnum,dacc_corr7_betas)
title(['Betas for dACC ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Corr1-3','Corr4','Corr5','Corr6','Corr7');
figure(2)
plot(tentnum,MidCing_corr1_3_betas,tentnum,MidCing_corr4_betas,tentnum,MidCing_corr5_betas,tentnum,MidCing_corr6_betas,tentnum,MidCing_corr7_betas)
title(['Betas for MidCing ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Corr1-3','Corr4','Corr5','Corr6','Corr7');
figure(3)
plot(tentnum,Lai_corr1_3_betas,tentnum,Lai_corr4_betas,tentnum,Lai_corr5_betas,tentnum,Lai_corr6_betas,tentnum,Lai_corr7_betas)
title(['Betas for Lai ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Corr1-3','Corr4','Corr5','Corr6','Corr7');
figure(4)
plot(tentnum,Rai_corr1_3_betas,tentnum,Rai_corr4_betas,tentnum,Rai_corr5_betas,tentnum,Rai_corr6_betas,tentnum,Rai_corr7_betas)
title(['Betas for Rai ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Corr1-3','Corr4','Corr5','Corr6','Corr7');
figure(5)
plot(tentnum,dacc_error_omission_betas,tentnum,dacc_error4_betas,tentnum,dacc_error5_betas,tentnum,dacc_error6_betas,tentnum,dacc_error7_betas)
title(['Betas for dACC ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Error_Omission','Error4','Error5','Error6','Error7');
figure(6)
plot(tentnum,MidCing_error_omission_betas,tentnum,MidCing_error4_betas,tentnum,MidCing_error5_betas,tentnum,MidCing_error6_betas,tentnum,MidCing_error7_betas)
title(['Betas for MidCing ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Error_Omission','Error4','Error5','Error6','Error7');
figure(7)
plot(tentnum,Lai_error_omission_betas,tentnum,Lai_error4_betas,tentnum,Lai_error5_betas,tentnum,Lai_error6_betas,tentnum,Lai_error7_betas)
title(['Betas for Lai ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Error_Omission','Error4','Error5','Error6','Error7');
figure(8)
plot(tentnum,Rai_error_omission_betas,tentnum,Rai_error4_betas,tentnum,Rai_error5_betas,tentnum,Rai_error6_betas,tentnum,Rai_error7_betas)
title(['Betas for Rai ' taskname ' SL']);
xlabel('Tent'); 
ylabel('Average Beta for ROI');
legend('Error_Omission','Error4','Error5','Error6','Error7');
saveas(1,'dacc_corr_betas.jpg')
saveas(2,'MidCing_corr_betas.jpg')
saveas(3,'Lai_corr_betas.jpg')
saveas(4,'Rai_corr_betas.jpg')
saveas(5,'dacc_error_betas.jpg')
saveas(6,'MidCing_error_betas.jpg')
saveas(7,'Lai_error_betas.jpg')
saveas(8,'Rai_error_betas.jpg')
