function whiskCalibViewer(calib_video,data_video)
% Standalone function to plot 2 frames of whisker tracking video to look
% for shifts in camera settings

% TO DO: add Popup for video choice
% calib_video = 'calib_20160127_033750 PM.dat'%'calib_20160127_033733 PM.dat';
% data_video = '20160127_033109 PM.dat';

fidx = 2000; % Frame index to plot

calib_frame = load_dat_frame(calib_video,fidx);
data_frame = load_dat_frame(data_video,fidx);
figure  % raw
subplot 121 
image(calib_frame)
% axis image
subplot 122
image(data_frame)
% axis image
suptitle(['Data ',data_video,'Calib: ',calib_video,', Frame ',num2str(i)]);

figure
imagesc(data_frame(:,:,1) - calib_frame(:,:,1));
title([data_video, ' - ',calib_video]);



end

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

end

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


end

