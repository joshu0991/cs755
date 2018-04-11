Fs = 44100;
samplesPerFrame = 44100;

microphone = dsp.AudioRecorder('SamplesPerFrame', samplesPerFrame, 'NumChannels', 1);

spectrum = dsp.SpectrumAnalyzer('SampleRate', Fs);

window = 1764;            % stft sample in hamming window
noverlap = 882;           % the overlap of the stft samples
nfft = 44100;             % number of fft samples

HiLo = [18000 22000];     % frequency bounds

% first freq bin at 19000 KHz
twentyRange = [19950 20050];
twentyTwoRange = [20150 20250];
twentyFourRange = [20350 20450];
twentySixRange = [20550 20650];
twentyEightRange = [20750 20850];

range1 = round(twentyRange);
range2 = round(twentyTwoRange);
range3 = round(twentyFourRange);
range4 = round(twentySixRange);
range5 = round(twentyEightRange);

% calculate the frequencies
freq = Fs*(0:samplesPerFrame/2-1)/samplesPerFrame;
  
tic;
xdist = 0;
counter = 0;
while toc < 50
    % get a sample from the microphone
    audioIn = step(microphone);
    
    % do stft with the window number overlapped nfft and the sampling freq
    [s, F, T, P] = spectrogram(audioIn, hamming(window), noverlap, nfft, Fs);
  
    % only want the real portions of the stft
    sAbs =  abs(s);
    
    % find the max power frequency in the window
    [maxValue1, indexMax1] = max(sAbs(range1(1):range1(2)));
    [maxValue2, indexMax2] = max(sAbs(range2(1):range2(2)));
    [maxValue3, indexMax3] = max(sAbs(range3(1):range3(2)));
    [maxValue4, indexMax4] = max(sAbs(range4(1):range4(2)));
    [maxValue5, indexMax5] = max(sAbs(range5(1):range5(2)));
    
    % index is max index + the window start
    indexMax1 = indexMax1 + range1(1);
    indexMax2 = indexMax2 + range2(1);
    indexMax3 = indexMax3 + range3(1);
    indexMax4 = indexMax4 + range4(1);
    indexMax5 = indexMax5 + range5(1);

    % display the strongest frequency
    fprintf('freq1: %i\n', freq(indexMax1));
    fprintf('freq2: %i\n', freq(indexMax2));
    fprintf('freq3: %i\n', freq(indexMax3));
    fprintf('freq4: %i\n', freq(indexMax4));
    fprintf('freq5: %i\n', freq(indexMax5));
    
    % find the doppler shift hard coded for now
    dopplerShift1 = freq(indexMax1) / 20000;%20000 - freq(indexMax1);
    dopplerShift2 = freq(indexMax2) / 20200;%20200 - freq(indexMax2);
    dopplerShift3 = freq(indexMax3) / 20400;%20400 - freq(indexMax3);
    dopplerShift4 = freq(indexMax4) / 20600;%20600 - freq(indexMax4);
    dopplerShift5 = freq(indexMax5) / 20800;%20800 - freq(indexMax5);

    fprintf('doppler shift1: %i\n', dopplerShift1);
    fprintf('doppler shift2: %i\n', dopplerShift2);
    fprintf('doppler shift3: %i\n', dopplerShift3);
    fprintf('doppler shift4: %i\n', dopplerShift4);
    fprintf('doppler shift5: %i\n', dopplerShift5);
    fprintf('-----------------------\n');

    avg = (dopplerShift1 + dopplerShift2 + dopplerShift3 + dopplerShift4 + dopplerShift5) / 5;
    %avgFreq = (20000 + 20200 + 20400 + 20600 + 20800) / 5;
    
    if (avg < 1 && avg > 0)
       avg = 0;
    end 
    
    fprintf('avg doppler shift: %i\n', avg);
    fprintf('-----------------------\n');
    
    
    %fprintf('time now %i\n', s);
    %fprintf('time beg %i\n', toc);
    xdist = xdist + (avg * 340)* 0.4;
    
   % fprintf('-----------------------\n');
   % fprintf('time difference %i\n', dT);
    fprintf('x dist %i\n', xdist);
    fprintf('-----------------------\n');
    plot(counter, xdist);
    counter = counter +1;
    
    % paint the spectorgram for debugging
    spectrogram(audioIn, window, noverlap, nfft, Fs, 'yaxis')
    
    % paint the spectrum analyzer
    step(spectrum, audioIn);
end

% clean up
release(microphone)
release(spectrum)