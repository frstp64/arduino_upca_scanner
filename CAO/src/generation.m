function varargout = generation(varargin)
% GENERATION MATLAB code for generation.fig
%      GENERATION, by itself, creates a new GENERATION or raises the existing
%      singleton*.
%
%      H = GENERATION returns the handle to a new GENERATION or the handle to
%      the existing singleton*.
%
%      GENERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATION.M with the given input arguments.
%
%      GENERATION('Property','Value',...) creates a new GENERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generation

% Last Modified by GUIDE v2.5 05-Apr-2016 14:22:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generation_OpeningFcn, ...
                   'gui_OutputFcn',  @generation_OutputFcn, ...
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


% --- Executes just before generation is made visible.
function generation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generation (see VARARGIN)

% Choose default command line output for generation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes generation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = generation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function zoom_Callback(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zoom as text
%        str2double(get(hObject,'String')) returns contents of zoom as a double


% --- Executes during object creation, after setting all properties.
function zoom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xs_Callback(hObject, eventdata, handles)
% hObject    handle to xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xs as text
%        str2double(get(hObject,'String')) returns contents of xs as a double


% --- Executes during object creation, after setting all properties.
function xs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotz_Callback(hObject, eventdata, handles)
% hObject    handle to rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotz as text
%        str2double(get(hObject,'String')) returns contents of rotz as a double


% --- Executes during object creation, after setting all properties.
function rotz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roty_Callback(hObject, eventdata, handles)
% hObject    handle to roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roty as text
%        str2double(get(hObject,'String')) returns contents of roty as a double


% --- Executes during object creation, after setting all properties.
function roty_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roty (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curby_Callback(hObject, eventdata, handles)
% hObject    handle to curby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curby as text
%        str2double(get(hObject,'String')) returns contents of curby as a double


% --- Executes during object creation, after setting all properties.
function curby_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_Callback(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb as text
%        str2double(get(hObject,'String')) returns contents of nb as a double


% --- Executes during object creation, after setting all properties.
function nb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generer.
function generer_Callback(hObject, eventdata, handles)
% hObject    handle to generer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xshift=str2double(valider(get(handles.xs,'string')));
serie=str2double(valider(get(handles.serie,'string')));
zoom=str2double(valider(get(handles.zoom,'string')));
nb=(str2double(valider(get(handles.nb,'string'))));
roty=str2double(valider(get(handles.roty,'string')));
rotz=str2double(valider(get(handles.rotz,'string')));
rotx=-1 * str2double(valider(get(handles.rotx,'string')));
curvy=str2double(valider(get(handles.curby,'string')));
nomFichier = valider(get(handles.nomFichier,'string'));

assignin('base','zoom',zoom)
assignin('base','serieforstats',serie)
assignin('base','rotx',rotx)
rotyrad = roty*pi/180;
rotzrad = rotz*pi/180;
rotxrad = rotx*pi/180;
curvyrad = curvy*pi/180;
x=genFundamentalCode(serie);
[codeb,carteNormales]=genBarCodeTestData(x,zoom,xshift,rotxrad,rotyrad,rotzrad,curvyrad,ones(2),nb);
assignin('base','codeb',codeb)
assignin('base','carteNormales',carteNormales)
%on sauvegarde les données dans le repertoire data/donnees
codeBarreComplet = serie; %verifier
codeEstValide = 1;
testImage = codeb;
parametresStruct = struct('nom', 'generation Utilisateur', 'zoom', zoom, ...
                              'xShift', xshift, ...
                  'xRotation', rotxrad, ...
			      'yRotation', rotyrad, ...
			      'zRotation', rotzrad, ...
			      'yCurvature', curvyrad, ...
			      'noiseLevel', nb);
nomFichierComplet = strcat(nomFichier, '.mat');
savePath = fullfile('..', 'data', 'donnees');
[~, ~, ~] = mkdir(savePath);
savePathComplet = fullfile(savePath, nomFichierComplet);
save(savePathComplet, 'testImage', 'carteNormales', ...
         'codeBarreComplet', 'codeEstValide', 'parametresStruct');
handleFigure = figure; imshow(testImage);
TEMPSPAUSE = 5;
pause(TEMPSPAUSE);
close(handleFigure);
main



function rotx_Callback(hObject, eventdata, handles)
% hObject    handle to rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotx as text
%        str2double(get(hObject,'String')) returns contents of rotx as a double


% --- Executes during object creation, after setting all properties.
function rotx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nomFichier_Callback(hObject, eventdata, handles)
% hObject    handle to nomFichier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nomFichier as text
%        str2double(get(hObject,'String')) returns contents of nomFichier as a double


% --- Executes during object creation, after setting all properties.
function nomFichier_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nomFichier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
