
in_folder = pwd();

project = 'iNetworks';
subID = 'INET003'; 
ses = '2'; %Number only

current_folder = [in_folder '/' subID '_' ses '/SCANS']; %Folder format INET999_1

%Starting scans 
AAHead_Scout = [1 2 3 4]; %List in order: AAHead_Scout, sag, cor, tra
gre = [5 6]; %List in order: gre_1, gre_2

%Funcitonal scans
rest = [7 11 15 19 23 27 31];
mixed = [9 17 25 33];
slowreveal = [13 21 29 35];
ambiguity = [];

%Anatomical scans 
T1w = []; %List in order: ABCD_1, ABCD_2, T1w, T1w_RMS
T2w = [37 38 39 40]; %List in order: ABCD_1, ABCD_2, T2w_1, T2w_2
MRA = []; %List in order: multi-slab, SAG, COR, TRA
MRV = []; %List in order: obl, SAG, COR, TRA

%Physio logs
Physio_rest = [8 12 16 20 24 28 32];
Physio_mixed = [10 18 26 34];
Physio_slowreveal = [14 22 30 36];
Physio_ambiguity = [];

%Other
Phoenix = 99; %Default 99


slice_mat = {'all', 'sag', 'cor', 'tra'};