function read_Intan_RHS2000_events

[file, path, ~] = uigetfile('*.rhs', 'Select an RHS2000 Data File', 'MultiSelect', 'off');

if (file == 0)
    return;
end

filename = [path,file];
fid = fopen(filename, 'r');

s = dir(filename);
filesize = s.bytes;

fprintf(1, 'Reading Intan Technologies RHS2000 Events File\n');

all = uint32(fread(fid, filesize, 'uint8'))';

spikes.amplitude = typecast(...
                   uint16(all(2:8:filesize)*2^8 +...
                   all(1:8:filesize)),...
                   'int16');
spikes.channel = uint8(all(4:8:filesize));
spikes.threshold_mult = uint16(all(3:8:filesize)/2);
spikes.sample = all(6:8:filesize)*2^24 +...
                all(5:8:filesize)*2^16 +...
                all(8:8:filesize)*2^8 +...
                all(7:8:filesize);

fclose(fid);

assignin('base', 'spikes', spikes);

fprintf(1, 'End\n');

return;

