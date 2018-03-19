Fs = 44100;

microphone = dsp.AudioRecorder('SamplesPerFrame', samplesPerFrame, 'NumChannels', 1);

spectrum = dsp.SpectrumAnalyzer('SampleRate', Fs);

window = 1764;            % stft sample in hamming window
noverlap = 882;           % the overlap of the stft samples
nfft = 44100;             % number of fft samples

HiLo=[18000 22000];       % frequency bounds
nHiLo=round(HiLo);

tic;
while toc < 50
    % get a sample from the microphone
    audioIn = step(microphone);
    
    % do stft with the window number overlapped nfft and the sampling freq
    [s, F, T, P] = spectrogram(audioIn, window, noverlap, nfft, Fs);
    
    % get the number of samples
    Nsamps = length(audioIn);
    
    % calculate the frequencies
    freq = Fs*(0:Nsamps/2-1)/Nsamps;
    
    % only want the real portions of the stft
    sAbs =  abs(s);
    
    % find the max power frequency in the window 18000 - 22000
    [maxValue, indexMax] = max(sAbs(nHiLo(1):nHiLo(2)));
    
    % index is max index + the window start
    indexMax = indexMax + nHiLo(1);

    % display the strongest frequency
    disp(freq(indexMax));

    % paint the spectorgram for debugging
    spectrogram(audioIn,[], [], [], Fs, 'yaxis')
    
    % paint the spectrum analyzer
    step(spectrum, audioIn);
end

% clean up
release(microphone)
release(spectrum)