Fs = 44100;
samplesPerFrame = 44100;
duration=50;

% org signal
fs = 44100;
amp = 1;

microphone = dsp.AudioRecorder('SamplesPerFrame', samplesPerFrame, 'NumChannels', 1);

spectrum = dsp.SpectrumAnalyzer('SampleRate', Fs);

window = 1764;            % stft sample in hamming window
noverlap = 882;           % the overlap of the stft samples
nfft = 44100;             % number of fft samples

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
freq1Avg = (20000 + 20200 + 20400 + 20600 + 20800) / 5;

values=0:1/fs:duration;

xdist = 0;
counter = 0;
tic;
while toc < 50
    % get a sample from the microphone
    audioIn = step(microphone);
    
    % do stft with the window number overlapped nfft and the sampling freq
    [s, F, T, P] = spectrogram(audioIn, hamming(window), noverlap, nfft, Fs);
  
    noisevar1 = (sum(P(19050:19990))/40) + (sum(P(20010:20050))/40);
    noisevar2 = (sum(P(20150:20190))/40) + (sum(P(20210:20250))/40);
    noisevar3 = (sum(P(20350:20390))/40) + (sum(P(20410:20450))/40);
    noisevar4 = (sum(P(20550:20590))/40) + (sum(P(20610:20650))/40);
    noisevar5 = (sum(P(20750:20790))/40) + (sum(P(20810:20850))/40);

    % remove the noise
    s(range1(1):range1(2)) = s(range1(1):range1(2)) / noisevar1;
    s(range2(1):range2(2)) = s(range2(1):range2(2)) / noisevar2;
    s(range3(1):range3(2)) = s(range3(1):range3(2)) / noisevar3;
    s(range4(1):range4(2)) = s(range4(1):range4(2)) / noisevar4;
    s(range5(1):range5(2)) = s(range5(1):range5(2)) / noisevar5;

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

    avg = (freq(indexMax1) + freq(indexMax2) + freq(indexMax3) + freq(indexMax4) + freq(indexMax5)) / 5;
    
    % display the strongest frequency
    fprintf('freq1: %i\n', freq(indexMax1));
    fprintf('freq2: %i\n', freq(indexMax2));
    fprintf('freq3: %i\n', freq(indexMax3));
    fprintf('freq4: %i\n', freq(indexMax4));
    fprintf('freq5: %i\n', freq(indexMax5));
    
    dopplerShift = freq1Avg - avg;
    fprintf('avg %i\n', avg);
    
    fprintf('Doppler shift %i\n', dopplerShift);
    
    xdist = xdist + (avg * 340)* 0.4;
    
    fprintf('-----------------------\n');
    fprintf('x dist %i\n', xdist);
    fprintf('-----------------------\n');
    
    % paint the spectorgram for debugging
    spectrogram(audioIn, window, noverlap, nfft, Fs, 'yaxis')
    
    % paint the spectrum analyzer
    step(spectrum, audioIn);
end

% clean up
release(microphone)
release(spectrum)