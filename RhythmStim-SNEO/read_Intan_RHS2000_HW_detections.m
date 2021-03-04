function read_Intan_RHS2000_HW_detections

[file, path, ~] = uigetfile('*.rhs', 'Select an RHS2000 HW detection File', 'MultiSelect', 'off');

if (file == 0)
    return;
end

filename = [path,file];
fid = fopen(filename, 'r');

s = dir(filename);
filesize = s.bytes;

fprintf(1, 'Reading Intan Technologies RHS2000 HW detections File\n');

all = fread(fid, filesize, 'uint8')';

rmsMults = single(all(3:8:filesize))/2;
channels = all(4:8:filesize);

valueLSB = uint16(all(1:8:filesize));
valueMSB = uint16(all(2:8:filesize));
amplitudes = typecast(valueMSB*2^8 + valueLSB, 'int16');

dtLLSB = uint32(all(7:8:filesize));
dtMLSB = uint32(all(8:8:filesize));
dtLMSB = uint32(all(5:8:filesize));
dtMMSB = uint32(all(6:8:filesize));
dts = dtMMSB*2^24 + dtLMSB*2^16 + dtMLSB*2^8 + dtLLSB;

chs = unique(channels);
spikes = cell(1,length(chs));
if find(chs(chs <= 0))
    disp("Incorrect channels found, events can be incorrect")    
end

%channelsOrder = [21,27,13,31,7,1,25,19,20,26,2,8,32,14,28,22,18,30,12,24,16,6,4,10,9,3,5,15,23,11,29,17];

for i=chs(chs>0)
    spikes{i+1}.Amplitude = amplitudes(channels==i);
    spikes{i+1}.DT = dts(channels==i);
    spikes{i+1}.RMSmultplier = rmsMults(channels==i);
end

fclose(fid);

assignin('base', 'spikes', spikes);

fprintf(1, 'End\n');

return;

