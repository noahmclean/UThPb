function varargout = UThPbII_GUI_v3(varargin)
% UTHPBII_GUI_V3 MATLAB code for UThPbII_GUI_v3.fig
%      UThPbII_GUI is a graphical user interface for plotting U-Pb isochrons, and calculating
%      An intercept with 
%
%      H = UTHPBII_GUI_V3 returns the handle to a new UTHPBII_GUI_V1 or the handle to
%      the existing singleton*.
%
%      UTHPBII_GUI_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UTHPBII_GUI_V1.M with the given input arguments.
%
%      UTHPBII_GUI_V1('Property','Value',...) creates a new UTHPBII_GUI_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UThPbII_GUI_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UThPbII_GUI_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UThPbII_GUI_v3

% Last Modified by GUIDE v2.5 06-Dec-2016 10:49:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UThPbII_GUI_v3_OpeningFcn, ...
                   'gui_OutputFcn',  @UThPbII_GUI_v3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UThPbII_GUI_v1 is made visible.
function UThPbII_GUI_v3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UThPbII_GUI_v1 (see VARARGIN)

% UIWAIT makes UThPbII_GUI_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Add axis title information
set(handles.concPlotAxes, 'defaultTextInterpreter', 'latex')
set(get(handles.concPlotAxes, 'xlabel'), 'String', '^{238}U/^{ 206}Pb',  'FontSize', 24)
set(get(handles.concPlotAxes, 'ylabel'), 'String', '^{207}Pb/^{ 206}Pb', 'FontSize', 24)
set(handles.concPlotAxes, 'FontSize', 16)

% Set up data structures
handles = initDataStructs_v2(handles);

if ispc % use software opengl line smoothing on PCs
opengl software
set(0,'DefaultLineLineSmoothing','on')
set(0,'DefaultPatchLineSmoothing','on')
end

% Choose default command line output for UThPbII_GUI_v1
handles.output = hObject; %I have no idea what this does.

%  Update handles structure
%  Note: it seems this needs to be at the end of OpeningFcn or no changes to handles are saved.
guidata(hObject, handles); 

% --- Outputs from this function are returned to the command line.
function varargout = UThPbII_GUI_v3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Input U-Th values %%%%%%%

function ar234238Value_Callback(hObject, eventdata, handles)
% hObject    handle to ar234238Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  
    handles.controlParams.plotsNeed(2) = 0;
    set(handles.buttonToPlot,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    handles.UThin.ar234238.value = inval;
    handles.controlParams.plotsNeed(2) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ar234238Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar234238Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ar230238Value_Callback(hObject, eventdata, handles)
% hObject    handle to ar230238Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ar230238Value as text
%        str2double(get(hObject,'String')) returns contents of ar230238Value as a double

inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  
    % isdouble returns NaN for non-numbers and f1 cannot be complex
    % Disable the Plot button and change its string to say why
    % set(handles.buttonToPlot,'String','X')
    set(handles.buttonToPlot,'Enable','off')
    handles.controlParams.plotsNeed(4) = 0;
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    handles.UThin.ar230238.value = inval;
    handles.controlParams.plotsNeed(4) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ar230238Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar230238Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r238235sValue_Callback(hObject, eventdata, handles)
% hObject    handle to r238235sValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r238235sValue as text
%        str2double(get(hObject,'String')) returns contents of r238235sValue as a double

inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  % if input is not plottable, disable Plot button
    set(handles.buttonToPlot,'Enable','off')
    handles.controlParams.plotsNeed(6) = 0;
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    handles.UThin.r238235s.value = inval;
    handles.controlParams.plotsNeed(6) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r238235sValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r238235sValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Input U-Th Uncertainties %%%%%%%

function ar234238OneSigmaAbs_Callback(hObject, eventdata, handles)
% hObject    handle to ar234238OneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ar234238OneSigmaAbs as text
%        str2double(get(hObject,'String')) returns contents of ar234238OneSigmaAbs as a double

inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  % if input is not plottable, disable Plot button
    handles.controlParams.plotsNeed(3) = 0;
    set(handles.buttonToPlot,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    handles.UThin.ar234238.oneSigmaAbs = inval;
    % Enable the Plot button with its original name
    handles.controlParams.plotsNeed(3) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ar234238OneSigmaAbs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar234238OneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ar230238OneSigmaAbs_Callback(hObject, eventdata, handles)
% hObject    handle to ar230238OneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ar230238OneSigmaAbs as text
%        str2double(get(hObject,'String')) returns contents of ar230238OneSigmaAbs as a double
inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  % if input is not plottable, disable Plot button
    handles.controlParams.plotsNeed(5) = 0;
    set(handles.buttonToPlot,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else
    handles.UThin.ar230238.oneSigmaAbs = inval;
    % Enable the Plot button with its original name
    handles.controlParams.plotsNeed(5) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ar230238OneSigmaAbs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar230238OneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r238235sOneSigmaAbs_Callback(hObject, eventdata, handles)
% hObject    handle to r238235sOneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r238235sOneSigmaAbs as text
%        str2double(get(hObject,'String')) returns contents of r238235sOneSigmaAbs as a double
inval = str2double(get(hObject,'String'));
if isnan(inval) || ~isreal(inval)  % if input is not plottable, disable Plot button
    handles.controlParams.plotsNeed(7) = 0;
    set(handles.buttonToPlot,'Enable','off')
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    handles.UThin.r238235s.oneSigmaAbs = inval;
    % Enable the Plot button with its original name
    handles.controlParams.plotsNeed(7) = 1;
    if all(handles.controlParams.plotsNeed)
        set(handles.buttonToPlot,'String','Plot')
        set(handles.buttonToPlot,'Enable','on')
    end
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function r238235sOneSigmaAbs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r238235sOneSigmaAbs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Slider Controls and Outputs %%%%%%%%

% --- Executes on slider movement.
function ar234238Slider_Callback(hObject, eventdata, handles)
% hObject    handle to ar234238Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ar234238Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar234238Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ar234238SliderValue_Callback(hObject, eventdata, handles)
% hObject    handle to ar234238SliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ar234238SliderValue as text
%        str2double(get(hObject,'String')) returns contents of ar234238SliderValue as a double


% --- Executes during object creation, after setting all properties.
function ar234238SliderValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar234238SliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on slider movement.
function r238235sSlider_Callback(hObject, eventdata, handles)
% hObject    handle to r238235sSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function r238235sSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r238235sSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function r238235Slider_Callback(hObject, eventdata, handles)
% hObject    handle to r238235Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r238235Slider as text
%        str2double(get(hObject,'String')) returns contents of r238235Slider as a double


% --- Executes during object creation, after setting all properties.
function r238235Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r238235Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function ar230238Slider_Callback(hObject, eventdata, handles)
% hObject    handle to ar230238Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ar230238Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar230238Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ar230238SliderValue_Callback(hObject, eventdata, handles)
% hObject    handle to ar230238SliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ar230238SliderValue as text
%        str2double(get(hObject,'String')) returns contents of ar230238SliderValue as a double


% --- Executes during object creation, after setting all properties.
function ar230238SliderValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ar230238SliderValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Action Buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in buttonToPlot.
function buttonToPlot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.concPlotAxes)

% First, plot the U-Pb data and straight line fit
handles = linearRegression_v2(handles);
handles = plotLine_v2(handles);
set(handles.outMSWD, 'String', [num2str(handles.soln.MSWD, '%4.2f') ' '])
set(handles.outn, 'String',    [num2str(handles.soln.n,    '%5.0f') ' '])
handles.soln.a2s = 2*sqrt(handles.soln.Sav(1,1));
sigfigs = abs(floor(log10(handles.soln.a2s))-1);
formatstring = ['%1.' num2str(sigfigs) 'f'];
set(handles.yInterceptValue, 'String', [num2str(handles.soln.a(2), formatstring) ' '])
set(handles.yInterceptTwoSigma, 'String', [num2str(handles.soln.a2s, formatstring) ' '])

% Second, plot concordia line on same axes
handles = plotConc_v2(handles);
guidata(hObject, handles);
ticksout = calcTicks_v2(handles); 
plotConcTicks_v2(handles, ticksout);
plotEllipses_v2(handles);
guidata(hObject, handles);




% --- Executes on button press in buttonToCalcInt.
function buttonToCalcInt_Callback(hObject, eventdata, handles)
% hObject    handle to buttonToCalcInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = calcIntcptOnce_v2(handles);


guidata(hObject, handles);


% --- Executes on button press in buttonToCalcUnct.
function buttonToCalcUnct_Callback(hObject, eventdata, handles)
% hObject    handle to buttonToCalcUnct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = calcIntcptMC_v2(handles, 1e4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% U-Pb Data Table Controls %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on key press with focus on UPbTable and none of its controls.
function UPbTable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to UPbTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
%if length(eventdata.Modifier) == 1 && strcmp(eventdata.Modifier{:},'control') && ...
%eventdata.Key == 'v'
%if ~isempty(eventdata.Modifier) && strcmp(eventdata.Modifier{:},'control') && strcmp(eventdata.Key, 'v')
if ~isempty(eventdata.Modifier) && strcmp(eventdata.Key, 'v')
    %importxl = importdata('-pastespecial', '\t');
    importxl = str2num(clipboard('paste'));
    n = size(importxl,1);
    % data treatment and checking
    if size(importxl,2) == 4, importxl(:,5) = zeros(n,1); end % assume zero corr coef if not input
    newTable = num2cell(importxl);
    for i = 1:n
        newTable{i,6} = true; % activate check-box for each measured datum 
    end
    set(handles.UPbTable,'Data',newTable);
    handles.UPbin.dataunct = cell2mat(newTable(:,1:end-1));
    handles.UPbin.skipv    = cell2mat(newTable(:,end));
    guidata(hObject, handles);
    
end

% --- Executes when entered data or checkbox click in editable cell(s) in UPbTable.
function UPbTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to UPbTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles.UPbin, 'dataunct') && ~isempty(handles.UPbin.dataunct) %if there is data here
    tablecontents = get(handles.UPbTable, 'Data');
    handles.UPbin.dataunct = cell2mat(tablecontents(:,1:5));
    handles.UPbin.skipv    = cell2mat(tablecontents(:,6));
    guidata(hObject, handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Radio Button Group Controls %%%%%%

% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% For Switching U-Pb Data input uncertainties from pct to abs
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'UPbUnctRadioButton_Abs'
        handles.UPbin.abspct = 1;
    case 'UPbUnctRadioButton_Pct'
        handles.UPbin.abspct = 2;
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% For switching input ar234238t values from measured to assumed transient equilibrium
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'ar234238RadioButton_Meas'
        handles.UThin.ar234238.measassm = 1;
        handles.UThin.measassm(1:4) = 'meas';
        set(handles.text8, 'String', '[234U/238U]i')
    case 'ar234238RadioButton_AsIn' % If the user chose transient equilibrium
        handles.UThin.ar234238.measassm = 2;
        handles.UThin.measassm(1:4) = 'assm';
        ar234238treq = handles.lambda.U234/(handles.lambda.U234-handles.lambda.U238);
        handles.UThin.ar234238.value = ar234238treq;
        set(handles.ar234238Value, 'String', num2str(ar234238treq, '%1.8f'))
        set(handles.text8, 'String', '[234U/238U]t')
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);

% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel6 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% For switching input ar230238 values from measured to assumed initial value
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'ar230238RadioButton_Meas'
        handles.UThin.ar230238.measassm = 1;
        handles.UThin.measassm(7:10) = 'meas';
        set(handles.text12, 'String', '[230Th/238U]i')
    case 'ar230238RadioButton_AsIn'
        handles.UThin.ar230238.measassm = 2;
        handles.UThin.measassm(7:10) = 'assm';
        handles.UThin.ar230238.value = 0;
        set(handles.ar230238Value, 'String', '0');
        handles.UThin.ar230238.oneSigmaAbs = 0;
        set(handles.ar230238OneSigmaAbs, 'String', '0')
        set(handles.text12, 'String', '[230Th/238U]t')
    otherwise
        % Code for when there is no match.
end
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Menu Items %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuDecayConstants_Callback(hObject, eventdata, handles)
% hObject    handle to MenuDecayConstants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MenuPartitioning_Callback(hObject, eventdata, handles)
% hObject    handle to MenuPartitioning (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Don't know why these are here, but crashes without %%%%%%%

% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% No idea why this is needed, but MATLAB gives an error on closing if deleted.
% --- Executes during object deletion, before destroying properties.
function uipanel4_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Resize Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes when uipanel1 (U-Pb Data Table) is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when uipanel2 is resized.
function uipanel2_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function buttonToPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to buttonToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function buttonToPlot_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to buttonToPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
