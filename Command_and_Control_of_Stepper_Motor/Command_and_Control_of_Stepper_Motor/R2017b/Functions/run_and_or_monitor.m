function [error_msg] = run_and_or_monitor(app_obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: run_and_or_monitor()
% Goal    : Run a sequence of commands that is sent to the motor and or
%           read a set of measured data coming from the motor and plot it.
%
% IN      : - app_obj  : system object containing the GUI App
% IN/OUT  : -
% OUT     : - error_msg: text describing the error that occurred
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#ok<*NASGU>
%#ok<*GFLD>

  % Constants
  NB_MEASUREMENT = 3;
  CMD_FIELD   = 1; MODULE_FIELD   =   2; TYPE_FIELD     = 3;
  MOTOR_FIELD = 4; VALUE_FIELD    =   5; T_WAIT_FIELD   = 6;
  NB_FIELDS   = 6; DELIMITER      = '|';
  FIELDS_DATA = '%s %d %d %d %d %f';
  INVALID_CMD = int8(2);
  INVALID_VAL = int8(8);
  ME_CMD      = MException('MATLAB:CMD','Command not available');
  NO_ERROR    = 'All the commands have been executed successfully.';

  % Initialization
  loop_index = 0;
  new_data   = nan(app_obj.refresh_time,2*NB_MEASUREMENT);
  error_id   = 0;
  error_txt  = '';
  error_msg  = '';
  t_ref      = tic; % Reference time for the time axes of all captured data
  % Initialize some variables when a new set of data is captured
  if (app_obj.trigger == 1)
    if (app_obj.save_to_file == 1)
      % Create the capture MAT file
      filename = ['.\Data\capture_' datestr(now,'yyyy-mm-dd_HH-MM-SS') '.mat'];
      app_obj.MAT_file      = matfile(filename);
      app_obj.MAT_file.data = new_data;
    end
    % Reset time data
    app_obj.position_plot.XData     = nan(1,app_obj.window_time);
    app_obj.velocity_plot.XData     = nan(1,app_obj.window_time);
    app_obj.acceleration_plot.XData = nan(1,app_obj.window_time);
    % Reset measured data
    app_obj.position_plot.YData     = nan(1,app_obj.window_time);
    app_obj.velocity_plot.YData     = nan(1,app_obj.window_time);
    app_obj.acceleration_plot.YData = nan(1,app_obj.window_time);
    % Rest time axes range
    app_obj.PositionAxis.XLim       = [0 1];
    app_obj.VelocityAxis.XLim       = [0 1];
    app_obj.AccelerationAxis.XLim   = [0 1];
  end

  % Send instructions to the motor or get measured data from it
  while(app_obj.run_file == 1 || app_obj.trigger == 1)
    if (app_obj.run_file == 1)
      % Get the file's extension to check if this is a correct text file
      file_type = app_obj.file_path(regexp(app_obj.file_path,'[^\.]+$'):end);
      if strcmp(file_type,'txt')
        f_id = fopen(app_obj.file_path);
        % Get the content of every line
        hdr_lines = textscan(f_id,'%s',NB_FIELDS,'delimiter',DELIMITER);
        cmd_lines = textscan(f_id,FIELDS_DATA);
      else
        error_msg = 'The file extension is not correct. It should be: ''.txt''';
        break;
      end
      
      for i=1:length(cmd_lines{1})
        % Extract the needed chunks
        cell_command  = cmd_lines{CMD_FIELD}(i);
        cell_module   = cmd_lines{MODULE_FIELD}(i);
        command_i     = getfield(app_obj.MNEMONICS(1),char(cell_command));
        cell_type_val = cmd_lines{TYPE_FIELD}(i);
        cell_motor    = cmd_lines{MOTOR_FIELD}(i);
        cell_data_val = cmd_lines{VALUE_FIELD}(i);
        wait_time     = cmd_lines{T_WAIT_FIELD}(i);
        % Execute the requested instruction in a safe way
        try
          % Map the mnemonic name to the command name
          all_commands = fieldnames(app_obj.COMMANDS);
          current_command = all_commands(command_i);
          % Extract the right subset of type for the selected command
          type_family = getfield(app_obj.COMMANDS(4),char(current_command));
          possible_types = get_type_fields(type_family);
          possible_fields = fieldnames(possible_types);
          % Extract the selected type
          current_type = char(possible_fields(...
                           struct2array(possible_types(1)) == cell_type_val));
          if strcmp(current_type,'DO_NOT_CARE')
            % Extract the allowed boundary values for the selected command
            min_command = getfield(app_obj.COMMANDS(2),char(current_command));
            max_command = getfield(app_obj.COMMANDS(3),char(current_command));
            % Check if the value field is between the allowed boundaries
            if ~(cell_data_val >= min_command && cell_data_val <= max_command)
              % The given value is not within the allowed value range
              error_id  = INVALID_VAL;
              error_txt = ['For the command #' num2str(i) ', its value must be between '...
                            num2str(min_command) ' and ' num2str(max_command) '.'];
            end
          else
            min_type = getfield(possible_types(2),current_type);
            max_type = getfield(possible_types(3),current_type);
            if ~(cell_data_val >= min_type && cell_data_val <= max_type)
              % The given value is not within the allowed value range
              error_id  = INVALID_VAL;
              error_txt = ['For the command #' num2str(i) ', its value must be between '...
                            num2str(min_type) ' and ' num2str(max_type) '.'];
            end
          end
          if (error_id == 0)
            % Current line number of the instruction to execute
            app_obj.InstructionIDText.Value = num2str(i);
            % Run the current command
            [error_id,error_txt,decoded_data] = send_serial_command(app_obj.COM_obj,...
              cell_module,command_i,cell_type_val,cell_motor,cell_data_val,0);
            % Decimal value brought back from the motor and displayed in the GUI
            app_obj.MeasurementText.Value = num2str(decoded_data);
          end
        catch ME_CMD
          error_id = INVALID_CMD;
        end

        if (error_id ~= 0)
          % Stop the motor for safety reason
          [~,~,~] = send_serial_command(app_obj.COM_obj,cell_module,...
            app_obj.COMMANDS(1).MOTOR_STOP,cell_type_val,cell_motor,0,0);
          % Output the error result and stop the process
          error_msg = ['The following error code was reported: ' ...
                        num2str(error_id) newline ...
                        'The issue occurred at the following command line: ' ...
                        num2str(i) newline ...
                        'As a result, the file execution has been stopped. ' ...
                        newline error_txt];
          break;
        end
        % Stop the file execution in case of an emergency stop
        if (app_obj.run_file == 0)
          break;
        end

        % Monitor measured data during the waiting time
        tic; % Start the counter
        while (toc < wait_time)
          if (app_obj.trigger == 1)
            [error_msg,loop_index,new_data] = monitoring(app_obj,...
                                                         loop_index,...
                                                         t_ref,...
                                                         new_data,...
                                                         NB_MEASUREMENT);
            if ~strcmp(error_msg,NO_ERROR)
              % An error occurred and the process is stopped
              app_obj.run_file = 0;
              app_obj.trigger  = 0;
              app_obj.CaptureData.Text     = 'Start capture';
              app_obj.RadioButtons.Visible = 'on';
              app_obj.CaptureData.Enable   = 'on';
              return;
            end
            % Save new data to the MAT file
            if (app_obj.save_to_file == 1)
              app_obj.MAT_file.data(loop_index+(1:app_obj.refresh_time),:) = new_data;
            end
          end
        end
      end

      % Instructions file has been processed and data capture is stopped
      app_obj.run_file = 0;
      app_obj.trigger  = 0;
      app_obj.CaptureData.Text     = 'Start capture';
      app_obj.RadioButtons.Visible = 'on';
      app_obj.CaptureData.Enable   = 'on';
      % Close the text file
      fclose(f_id);
    end

    % Monitor measured data
    if (app_obj.trigger == 1)
      [error_msg,loop_index,new_data] = monitoring(app_obj,...
                                                   loop_index,...
                                                   t_ref,...
                                                   new_data,...
                                                   NB_MEASUREMENT);
      if ~strcmp(error_msg,NO_ERROR)
        % An error occurred and the process is stopped
        return;
      end
      % Save new data to the MAT file
      if (app_obj.save_to_file == 1)
        app_obj.MAT_file.data(loop_index-1+(1:app_obj.refresh_time),:) = new_data;
      end
    end
  end
  if (app_obj.save_to_file == 1)
    % Remove the empty values that are useless at the beginning
    app_obj.MAT_file.data = app_obj.MAT_file.data(app_obj.refresh_time+1:end,:);
    % Reset the status of the capture radio button
    app_obj.save_to_file = 0;
    app_obj.ButtonYes.Value = app_obj.save_to_file;
  end
end

function [error_msg,index,new_data] = monitoring(app_obj,index,t_ref,...
                                                 data,nb_measurement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: monitoring()
% Goal    : Read a set of measured data from the motor and plot them.
%
% IN      : - app_obj       : system object containing the GUI App
%           - data          : saved data to plot
%           - nb_measurement: number of measured data to plot
% IN/OUT  : - index         : data frame index
% OUT     : - error_msg     : text describing the error that occurred
%           - new_data      : updated data to plot
%
% Copyright 2018 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Initialization
  error_msg = 'All the commands have been executed successfully.';
  % Setup of the refreshed plots
  decoded_data = nan(1,2*nb_measurement);
  index = index+1;
  % Get the current position of the motor
  [error_id,error_txt,decoded_data(2)] = send_serial_command(...
                                         app_obj.COM_obj,...
                                         app_obj.ADDRESS,...
                                         app_obj.COMMANDS(1).GET_AXIS_PARAMETER,...
                                         app_obj.PARAMETERS(1).ACTUAL_POSITION,...
                                         app_obj.MOTOR_ID,0);
  if (error_id ~= 0)
    % Output the error result and stop the process
    error_msg = ['The following error code was reported: ' ...
                  num2str(error_id) newline error_txt];
    new_data = decoded_data;
    return;
  end
  decoded_data(1) = toc(t_ref);
  % Get the current speed of the motor
  [error_id,error_txt,decoded_data(4)] = send_serial_command(...
                                         app_obj.COM_obj,...
                                         app_obj.ADDRESS,...
                                         app_obj.COMMANDS(1).GET_AXIS_PARAMETER,...
                                         app_obj.PARAMETERS(1).ACTUAL_SPEED,...
                                         app_obj.MOTOR_ID,0);
  if (error_id ~= 0)
    % Output the error result and stop the process
    error_msg = ['The following error code was reported: ' ...
                  num2str(error_id) newline error_txt];
    new_data = decoded_data;
    return;
  end
  decoded_data(3) = toc(t_ref);
  % Get the current acceleration of the motor
  [error_id,error_txt,decoded_data(6)] = send_serial_command(...
                                         app_obj.COM_obj,...
                                         app_obj.ADDRESS,...
                                         app_obj.COMMANDS(1).GET_AXIS_PARAMETER,...
                                         app_obj.PARAMETERS(1).ACTUAL_ACCELERATION,...
                                         app_obj.MOTOR_ID,0);
  if (error_id ~= 0)
    % Output the error result and stop the process
    error_msg = ['The following error code was reported: ' ...
                  num2str(error_id) newline error_txt];
    new_data = decoded_data;
    return;
  end
  decoded_data(5) = toc(t_ref);

  new_data = [data(2:end,:);decoded_data];
  % Plot the new data only when a refresh occurs
  if ~mod(index,app_obj.refresh_time)
    refresh_index = index/app_obj.refresh_time;
    % Get current x and y data from the axes
    time_series = [app_obj.position_plot.XData',...
                   app_obj.position_plot.YData',...
                   app_obj.velocity_plot.XData',...
                   app_obj.velocity_plot.YData',...
                   app_obj.acceleration_plot.XData',...
                   app_obj.acceleration_plot.YData'];
    % Get new measured data
    [time_series] = oscilloscope(refresh_index,...
                                 app_obj.window_time,...
                                 app_obj.refresh_time,...
                                 new_data,time_series);
    % Retrieve independent time data
    app_obj.position_plot.XData     = time_series(:,1)';
    app_obj.velocity_plot.XData     = time_series(:,3)';
    app_obj.acceleration_plot.XData = time_series(:,5)';
    % Retrieve independent measured data
    app_obj.position_plot.YData     = time_series(:,2)';
    app_obj.velocity_plot.YData     = time_series(:,4)';
    app_obj.acceleration_plot.YData = time_series(:,6)';
    % Update of the time axes range
    if any(isnan(time_series(end,:)))
      app_obj.PositionAxis.XLim     = [time_series(1,1) max(time_series(:,1))];
      app_obj.VelocityAxis.XLim     = [time_series(1,3) max(time_series(:,3))];
      app_obj.AccelerationAxis.XLim = [time_series(1,5) max(time_series(:,5))];
    else
      app_obj.PositionAxis.XLim     = time_series([1 end],1);
      app_obj.VelocityAxis.XLim     = time_series([1 end],3);
      app_obj.AccelerationAxis.XLim = time_series([1 end],5);
    end
    % Draw new data in plots
    drawnow;
  end
end
