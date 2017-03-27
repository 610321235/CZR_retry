function varargout = testingGUI05(varargin)
% TESTINGGUI05 MATLAB code for testingGUI05.fig
%      TESTINGGUI05, by itself, creates a new TESTINGGUI05 or raises the existing
%      singleton*.
%
%      H = TESTINGGUI05 returns the handle to a new TESTINGGUI05 or the handle to
%      the existing singleton*.
%
%      TESTINGGUI05('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTINGGUI05.M with the given input arguments.
%
%      TESTINGGUI05('Property','Value',...) creates a new TESTINGGUI05 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testingGUI05_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testingGUI05_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testingGUI05

% Last Modified by GUIDE v2.5 23-Nov-2016 14:27:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testingGUI05_OpeningFcn, ...
                   'gui_OutputFcn',  @testingGUI05_OutputFcn, ...
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


% --- Executes just before testingGUI05 is made visible.
function testingGUI05_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testingGUI05 (see VARARGIN)
%setup;
handles.net = load('C:\Users\SHA\Desktop\practical-cnn-2015a\data\chars-experiment\netcnn_imdb\netcnn.mat') ;
handles.imdb = load('C:\Users\SHA\Desktop\practical-cnn-2015a\data\chars-experiment\netcnn_imdb\imdb.mat') ;
% Choose default command line output for testingGUI05
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testingGUI05 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testingGUI05_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseButton.
function BrowseButton_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mp4','開啟檔案');
if isequal(filename,0)
    msgbox('沒有選取任何檔案','File Open Error','error');
    return;
end
str = [pathname filename];
set(handles.edit1,'string',str);
filetype = filename(end-2:end);
if filetype == 'mp4'
    msgbox('格式正確，可繼續操作','Message','help');
else
    msgbox('格式錯誤，請重新選擇檔案','Error message','error');
end
handles.filename = filename;
handles.pathname = pathname;
guidata(hObject, handles);


% --- Executes on button press in PreButton.
function PreButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_plus = [];
% image_all = [];
norm = 20;
inputpath = handles.pathname;
input_dir = dir([inputpath handles.filename]);
obj = VideoReader([inputpath input_dir.name]);
objn = obj.NumberOfFrames;
objw = obj.Width;
objh = obj.Height;
diff = objn - norm;
nget = objn/norm;
count = 1;
for fra=1:nget:objn %每nget張 取1張 共取20張
    frax = fix(fra);
    output = rgb2gray(imresize(read(obj,frax),[32 32]));%resize為32x32並轉灰階
    image_plus = [image_plus output];
    image_all(:,:,count) = output;
    count = count +1;
end
axes(handles.axes1);
imshow(image_plus);

handles.image_all = image_all;
set(handles.WaitText, 'String', '前處理已完成 可執行下一步');
guidata(hObject, handles);


% --- Executes on button press in IdentiButton.
function IdentiButton_Callback(hObject, eventdata, handles)
% hObject    handle to IdentiButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if ~exist('handles.image_all')
%     msgbox('尚未進行前處理','Error','error');
%     return;
% end
set(handles.WaitText, 'String', '　');
image_all = handles.image_all;
im = im2single(image_all);
im = 256 * (im - handles.net.imageMean) ;

res = vl_simplenn(handles.net, im) ;
imageMean = handles.net.imageMean;
handles.imdb.images.data = handles.imdb.images.data - imageMean ;
for i=1:size(res(end).x,2)
  [score, pred] = sort(squeeze(res(end).x(1,i,:)),'descend') ;
end
% fprintf('%s: 辨識結果為: %s\n', mfilename, handles.imdb.meta.classes(pred)) ;
% for i=1:size(res(end).x,2)
%     [score,pred] = sort(squeeze(res(end).x(1,i,:)),'descend');
% end
% fprintf('%s: decode chars: %s\n', mfilename, imdb.meta.classes(pred(1:3))) ;
value = handles.imdb.meta.classes(pred(1));
set(handles.text3,'String',['動作：' num2str(pred(1)) ' 分數：' num2str(score(1))]);
set(handles.text6,'String',['動作：' num2str(pred(2)) ' 分數：' num2str(score(2))]);
set(handles.text7,'String',['動作：' num2str(pred(3)) ' 分數：' num2str(score(3))]);


% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text3,'String',' ');
set(handles.text6,'String',' ');
set(handles.text7,'String',' ');


% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputpath = handles.pathname;
input_dir = dir([inputpath handles.filename]);
obj = VideoReader([inputpath input_dir.name]);
objn = obj.NumberOfFrames;
objw = obj.Width;
objh = obj.Height;

mov(1:objn) = struct('cdata', zeros(objh, objw, 3, 'uint8'),'colormap', []);
% 讀Frames
for k = 1 : objn
    mov(k).cdata = read(obj, k);
end
hf = figure;
set(hf, 'position', [320 240 objw objh])
% 播放影片
movie(hf, mov, obj.FrameRate);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
