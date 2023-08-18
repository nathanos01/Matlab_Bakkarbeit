function setup()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: setup()
% Goal    : Set up the MATLAB path for the project. This function should be
%           called by an initialization script or shortcut.
%
% IN      : -
% OUT     : -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('Begin the initialization of the project...');

    % Get the folders to add to the MATLAB path
    rootDir = determineRootDirectory();
    addProjectFolders(rootDir);

    % Change to the working directory
    cd(rootDir);

    disp('Initialization completed.');
end


% functions

function rootDir = determineRootDirectory()
    % Determine the project root directory
    splitDir = strsplit(pwd, filesep);
    rootDir = fullfile(splitDir{1:end-1}, 'SystemCode'); % Remove the last folder (SystemCode)
end

function addProjectFolders(rootDir)
    % Define project subfolders to add to the MATLAB path
    subfolders = {'Data', 'Functions', 'Pictures', 'Tests'};

    % Add these folders to the MATLAB path
    for i = 1:numel(subfolders)
        folderPath = fullfile(rootDir, subfolders{i});
        addpath(folderPath);
    end
end
