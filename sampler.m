[y,fs] = audioread('recording.aifc');
ydft = fft(y);
% y has even length
ydft = ydft(1:length(y)/2+1);

% create a frequency vector
freq = 0:fs/length(y):fs/2;

% plot magnitude
subplot(211);
plot(freq,abs(ydft));

% plot phase
subplot(212);
plot(freq,unwrap(angle(ydft))); 
xlabel('Hz');