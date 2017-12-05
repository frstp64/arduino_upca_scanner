function varargout = Results(varargin)
% RESULTS MATLAB code for Results.fig
%      RESULTS, by itself, creates a new RESULTS or raises the existing
%      singleton*.
%
%      H = RESULTS returns the handle to a new RESULTS or the handle to
%      the existing singleton*.
%
%      RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTS.M with the given input arguments.
%
%      RESULTS('Property','Value',...) creates a new RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Results

% Last Modified by GUIDE v2.5 01-Apr-2016 14:35:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Results_OpeningFcn, ...
                   'gui_OutputFcn',  @Results_OutputFcn, ...
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


% --- Executes just before Results is made visible.
function Results_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Results (see VARARGIN)

% Choose default command line output for Results
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

TeteDeLecture = evalin('base','TeteDeLecture');
axes(handles.position)
plot(TeteDeLecture(:,2))

%load('tabstats.mat')

% UIWAIT makes Results wait for user response (see UIRESUME)
% uiwait(handles.Results);
%global my_data;
%set(handles.wo, 'String', my_data.main.Rph);


% --- Outputs from this function are returned to the command line.
function varargout = Results_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in figures.
function figures_Callback(hObject, eventdata, handles)
% hObject    handle to figures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%open('figures.fig')

% --- Executes on button press in facture.
function facture_Callback(hObject, eventdata, handles)
% hObject    handle to facture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function q_Callback(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q as text
%        str2double(get(hObject,'String')) returns contents of q as a double


% --- Executes during object creation, after setting all properties.
function q_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wo_Callback(hObject, eventdata, handles)
% hObject    handle to wo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wo as text
%        str2double(get(hObject,'String')) returns contents of wo as a double


% --- Executes during object creation, after setting all properties.
function wo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wb_Callback(hObject, eventdata, handles)
% hObject    handle to wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wb as text
%        str2double(get(hObject,'String')) returns contents of wb as a double


% --- Executes during object creation, after setting all properties.
function wb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k_Callback(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k as text
%        str2double(get(hObject,'String')) returns contents of k as a double


% --- Executes during object creation, after setting all properties.
function k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amp_Callback(hObject, eventdata, handles)
% hObject    handle to amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amp as text
%        str2double(get(hObject,'String')) returns contents of amp as a double


% --- Executes during object creation, after setting all properties.
function amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decoder.
function decoder_Callback(hObject, eventdata, handles)
% hObject    handle to decoder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
position = evalin('base','position');
tableau = evalin('base','tableau');
[serie, valide] = (decode(position,tableau));
serie = serie'; %vecteur ligne
noserie=(num2str(serie));
set(handles.serie, 'String', noserie);

tableau = evalin('base','unbalayage');
axes(handles.tableau)
plot(tableau)
global a
if a==1
    stats = evalin('base','tabstats');
    i = stats(1,3);
    seriestats = evalin('base','serieforstats');
    stats(i,1) = seriestats ;
    stats(i,2) = valide ;
    i=i+1;
    stats(1,3) = i ;
    assignin('base','tabstats',stats)
    assignin('base','istats',i)
    save('tabstats','stats')
end


function serie_Callback(hObject, eventdata, handles)
% hObject    handle to serie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of serie as text
%        str2double(get(hObject,'String')) returns contents of serie as a double


% --- Executes during object creation, after setting all properties.
function serie_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
global a
a=get(hObject,'Value');
if a==1
    load('tabstats.mat')
end

