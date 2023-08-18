function shutdown()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Function: shutdown()
    % Goal    : Clean up the MATLAB environment when the project is closed.
    %           It removes project-specific folders from the path, clears
    %           workspace variables, and the command window.
    %
    % IN      : -
    % IN/OUT  : -
    % OUT     : -
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('Begin the termination of the project...');

    % List of project-specific folders to remove from the MATLAB path
    projectFolders = {'Data', 'Functions', 'Pictures', 'Tests'};

    try
        % Find the "SystemCode" directory
        rootDir = strsplit(pwd, '\\SystemCode');
        
        if numel(rootDir) >= 2
            systemCodeDir = fullfile(rootDir{1}, 'SystemCode');
            
            % Remove project folders from the MATLAB path
            for i = 1:numel(projectFolders)
                folderPath = fullfile(systemCodeDir, projectFolders{i});
                if isfolder(folderPath)
                    rmpath(folderPath);
                    disp(['Removed folder from path: ', folderPath]);
                else
                    disp(['Folder not found: ', folderPath]);
                end
            end
        else
            disp('Could not locate "SystemCode" directory.');
        end

        % Clear workspace variables and command window
        clearvars -except projectFolders;
        clc;

        disp('Project closed.');
    catch exception
        disp(['Error during shutdown: ', exception.message]);
    end
end
