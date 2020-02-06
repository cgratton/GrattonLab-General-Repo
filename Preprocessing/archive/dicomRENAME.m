clear all

dicomRENAME_params

destination_folder = ['/Users/megan/Box/DATA/' project '/Dicom/sub-' subID '/ses-' ses];

if ~exist(destination_folder, 'dir')
    mkdir(destination_folder);
end

run_tasks = {'AAHead_Scout', 'gre', 'rest', 'mixed', 'slowreveal', 'ambiguity', ...
    'T1w', 'T2w', 'MRA', 'MRV', 'Physio_rest' 'Physio_mixed', 'Physio_slowreveal', ...
    'Physio_ambiguity', 'Phoenix'};

if ~exist([destination_folder, '/func'], 'dir')
    mkdir([destination_folder, '/func']);
end
if ~exist([destination_folder, '/anat'], 'dir')
    mkdir([destination_folder, '/anat']);
end
if ~exist([destination_folder, '/fmap'], 'dir')
    mkdir([destination_folder, '/fmap']);
end
if ~exist([destination_folder, '/AAHead_Scout'], 'dir')
    mkdir([destination_folder, '/AAHead_Scout']);
end
if ~exist([destination_folder, '/PhysioLog'], 'dir')
    mkdir([destination_folder, '/PhysioLog']);
end
if ~exist([destination_folder, '/PhoenixReport'], 'dir')
    mkdir([destination_folder, '/PhoenixReport']);
end    

for task = run_tasks
    name = cell2mat(task);
    
    if strcmp(name, 'rest') || strcmp(name, 'mixed') || strcmp(name, 'slowreveal') || strcmp(name, 'ambiguity')
        type = 'func';
    elseif strcmp(name, 'T1w') || strcmp(name, 'T2w') || strcmp(name, 'MRA') || strcmp(name, 'MRV')
        type = 'anat';
    elseif strcmp(name, 'gre')
        type = 'fmap';
    elseif strcmp(name, 'AAHead_Scout')
        type = 'AAHead_Scout';
    elseif strcmp(name, 'Physio_rest') || strcmp(name, 'Physio_mixed') || strcmp(name, 'Physio_slowreveal') || strcmp(name, 'Physio_ambiguity')
        type = 'PhysioLog';
    elseif strcmp(name, 'Phoenix')
        type = 'PhoenixReport';
    end
    
    run_counter = 1;
    for run = eval(name)
        if strcmp(type, 'func')
            run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_task-' name '_run-' num2str(run_counter) '_bold'];
        elseif strcmp(name, 'T1w') || strcmp(name, 'T2w')
            if run_counter <=2 
                run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_' 'ABCD_' name '_' num2str(run_counter)];
            else 
                run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_'  name '_' num2str(run_counter-2)];
            end
        elseif strcmp(name, 'AAHead_Scout') || strcmp(name, 'MRA') || strcmp(name, 'MRV')
            run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_'  name '_' cell2mat(slice_mat(run_counter))];
        elseif strcmp(name, 'gre')
            run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_'  name '_' num2str(run_counter)];
        elseif strcmp(type, 'PhysioLog')
            run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_'  name '_' num2str(run_counter)];
        elseif strcmp(type, 'PhoenixReport')
            run_folder = [destination_folder '/' type '/sub-' subID '_ses-' ses '_'  name];
        end
        
        if ~exist(run_folder, 'dir')
            mkdir(run_folder);
        end
        
        movefile([current_folder '/' num2str(run) '/DICOM/' '*.dcm'], run_folder);
        run_counter = run_counter+1;
    end
end



