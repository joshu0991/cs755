amp=1;
fs=80000; % sampling frequency
duration=50;

freq = 19000;
freq1_1 = 19200;
freq1_2 = 19400;
freq1_3 = 19600;
freq1_4 = 19800;

freq2 = 20000;
freq2_1 = 20200;
freq2_2 = 20400;
freq2_3 = 20600;
freq2_4 = 20800;

values=0:1/fs:duration;

wave = amp*sin(2*pi*freq*values);
wave1_1 = amp*sin(2*pi*freq1_1*values);
wave1_2 = amp*sin(2*pi*freq1_2*values);
wave1_3 = amp*sin(2*pi*freq1_3*values);
wave1_4 = amp*sin(2*pi*freq1_4*values);

wave2 =amp*sin(2*pi*freq2*values);
wave2_1 = amp*sin(2*pi*freq2_1*values);
wave2_2 = amp*sin(2*pi*freq2_2*values);
wave2_3 = amp*sin(2*pi*freq2_3*values);
wave2_4 = amp*sin(2*pi*freq2_4*values);

wave1_sum = wave + wave1_1 + wave1_2 + wave1_3 + wave1_4;
wave2_sum = wave2 + wave2_1 + wave2_2 + wave2_3 + wave2_4;

wave1_sum = wave1_sum/max(abs(wave1_sum));
wave2_sum = wave2_sum/max(abs(wave2_sum));

Out = [zeros(size(values)); wave1_sum]';
Out2 = [wave2_sum; zeros(size(values))]';

combined = [wave1_sum(:), wave2_sum(:)];
%audiowrite('20KHz5tone.wav',Out2,fs);
%audiowrite('19KHz5tone.wav',wave1_sum,fs);
audiowrite('19k_20k_10tone.wav', combined, fs);

%sound(combined, fs);
sound(wave1_sum, fs);
%sound(Out2, fs);

NFFT=1024;
L=length(wave1_sum);         
X=fftshift(fft(wave1_sum,NFFT));         
Px=X.*conj(X)/(NFFT*L); %Power of each freq components       
fVals=fs*(-NFFT/2:NFFT/2-1)/NFFT;        
plot(fVals,Px,'b');      
title('Power Spectral Density');         
xlabel('Frequency (Hz)')         
ylabel('Power');
