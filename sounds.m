amp=1;
fs=80000; % sampling frequency
duration=10;
freq = 20000;
freq2 = 21000;
values=0:1/fs:duration;

wave = amp*sin(2*pi*freq*values);
wave2 =amp*sin(2*pi*freq2*values);

Out = [zeros(size(values)); wave]';
Out2 = [wave2; zeros(size(values))]';

audiowrite('20KHz-pilot.wav',wave,fs);
audiowrite('21KHz-pilot.wav',wave2,fs);

sound(Out, fs);
sound(Out2, fs);

NFFT=1024;
L=length(wave2);         
X=fftshift(fft(wave2,NFFT));         
Px=X.*conj(X)/(NFFT*L); %Power of each freq components       
fVals=fs*(-NFFT/2:NFFT/2-1)/NFFT;        
plot(fVals,Px,'b');      
title('Power Spectral Density');         
xlabel('Frequency (Hz)')         
ylabel('Power');
