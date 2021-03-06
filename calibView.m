function varargout = calibView(varargin)
% CALIBVIEW MATLAB code for calibView.fig
%      CALIBVIEW, by itself, creates a new CALIBVIEW or raises the existing
%      singleton*.
%
%      H = CALIBVIEW returns the handle to a new CALIBVIEW or the handle to
%      the existing singleton*.
%
%      CALIBVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBVIEW.M with the given input arguments.
%
%      CALIBVIEW('Property','Value',...) creates a new CALIBVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibView

% Last Modified by GUIDE v2.5 02-Feb-2016 12:54:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @calibView_OpeningFcn, ...
    'gui_OutputFcn',  @calibView_OutputFcn, ...
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


% --- Executes just before calibView is made visible.
function calibView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibView (see VARARGIN)

% Choose default command line output for calibView
handles.output = hObject;

% handles.directory = uigetdir;
% pause
% cd(handles.directory)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibView_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.dat', 'Pick the data file');
handles.data_video = [pathname,filename];
fidx = 2000;
handles.data_frame = load_dat_frame(handles.data_video,fidx);
subplot 121
imagesc(handles.data_frame);
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname, filterindex] = uigetfile('*.dat', 'Pick the calibration file');
handles.calib_video = [pathname,filename];
fidx = 2000;
handles.calib_frame = load_dat_frame(handles.calib_video,fidx);
subplot 122
imagesc(handles.calib_frame);
guidata(hObject, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;
handles
imagesc(handles.data_frame(:,:,1) - handles.calib_frame(:,:,1));
title([handles.data_video, ' - ',handles.calib_video]);

guidata(hObject, handles);




% Subfunctions

function [ frame ] = load_dat_frame( fname, frameidx )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(fname,'r');
header = read_mikrotron_datfile_header(fid);
nframes = header.nframes;
width = header.width;
height = header.height;
video_offset = 8192;
% set file position to start of first frame
fseek(fid,video_offset,-1);

offset = header.imagesize * (frameidx-1) + video_offset;
fseek(fid,offset,-1);
tmp = fread(fid,header.imagesize-24,'uint8=>uint8');
tmp = reshape([tmp; zeros(24,1)],width,height)';
frame = uint8(zeros(height,width,3));
frame(:,:,1) = tmp;
frame(:,:,2) = tmp;
frame(:,:,3) = tmp;


function [ data ] = read_mikrotron_datfile_header( fid )

% rsp 080713 (exactly as in dat2mat)

data.offset = fread(fid,1,'uint32');
data.header = fread(fid,1,'uint32');

data.header_sig = fread(fid,20,'char=>char');
data.record_start = fread(fid,30,'char=>char');
data.camera_name = fread(fid,100,'char=>char');

data.header_sig;
data.record_start;
data.camera_name;

data.camera_man = fread(fid,100,'char=>char');
data.camera_model = fread(fid,100,'char=>char');
data.camera_firmware = fread(fid,100,'char=>char');
data.camera_serial = fread(fid,100,'char=>char');
data.usercomment = fread(fid,1024,'char=>char');

data.hack = fread(fid,2,'char=>char');

data.camera_count = fread(fid,1,'uint32');
data.xoffset = fread(fid,1,'uint32');
data.yoffset = fread(fid,1,'uint32');
data.width = fread(fid,1,'uint32');
data.height = fread(fid,1,'uint32');
data.imagesize = fread(fid,1,'uint32');
data.framerate = fread(fid,1,'uint32') ;     % fps
data.exposuretime = fread(fid,1,'uint32');   % muS
data.dataformat = fread(fid,1,'uint32');


data.bayer = fread(fid,3,'double');
data.gamma = fread(fid,3,'double');
fseek(fid,1672,-1);
data.nframes = fread(fid,1,'uint64');
data.startframe = fread(fid,1,'uint64');
data.triggerframe = fread(fid,1,'uint64');
data.triggertick = fread(fid,1,'uint64');
data.internal = fread(fid,1,'uint64');
data.internal = fread(fid,1,'uint32');
data.imageblitz = fread(fid,4,'uint32');
data.irig = fread(fid,1,'uint32');
data.tickcountfreq = fread(fid,1,'uint64');



% --------------------------------------------------------------------
function CD_Callback(hObject, eventdata, handles)
% hObject    handle to CD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.directory = uigetdir;
cd(handles.directory);
guidata(hObject, handles);
