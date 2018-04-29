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

% first freq bin at 20 KHz
twentyRange = [17950 18050];
twentyTwoRange = [18150 18250];
twentyFourRange = [18350 18450];
twentySixRange = [18550 18650];
twentyEightRange = [18750 18850];

nineteenRange = [18950 19050];
nineteenTwoRange = [19150 19250];
nineteenFourRange = [19350 19450];
nineteenSixRange = [19550 19650];
nineteenEightRange = [19750 19850];

range1 = round(twentyRange);
range2 = round(twentyTwoRange);
range3 = round(twentyFourRange);
range4 = round(twentySixRange);
range5 = round(twentyEightRange);

range6 = round(nineteenRange);
range7 = round(nineteenTwoRange);
range8 = round(nineteenFourRange);
range9 = round(nineteenSixRange);
range10 = round(nineteenEightRange);

% calculate the frequencies
freq = Fs*(0:samplesPerFrame/2-1)/samplesPerFrame;
freq1 = 18000;
freq2 = 18200;
freq3 = 18400;
freq4 = 18600;
freq5 = 18800;

freq6 = 19000;
freq7 = 19200;
freq8 = 19400;
freq9 = 19600;
freq10 = 19800;

freq1Avg = (18000 + 18200 + 18400 + 18600 + 18800) / 5;
freq2Avg = (19000 + 19200 + 19400 + 19600 + 19800) / 5;

values=0:1/fs:duration;

speakerDist1 = 0;
speakerDist2 = 0;
lastDopplerShift = 0;
lastDopplerShift2 = 0;
x = 0;
% d = 60 cm
d = 60;

hold on;
tic;
while toc < 20
    %fprintf('toc %i \n', toc);
    % get a sample from the microphone
    audioIn = step(microphone);
    
    % do stft with the window number overlapped nfft and the sampling freq
    [s, K, Q, P] = spectrogram(audioIn, hamming(window), noverlap, nfft, Fs);
  
    % find the noise variance for each channel which is the average of all
    % of the signal not near the base signal
    noisevar1 = (sum(P(17950:18990))/40) + (sum(P(18010:18050))/40);
    noisevar2 = (sum(P(18150:18190))/40) + (sum(P(18210:18250))/40);
    noisevar3 = (sum(P(18350:18390))/40) + (sum(P(18410:18450))/40);
    noisevar4 = (sum(P(18550:18590))/40) + (sum(P(18610:20650))/40);
    noisevar5 = (sum(P(18750:18790))/40) + (sum(P(18810:18850))/40);

    noisevar6 = (sum(P(18950:18990))/40) + (sum(P(19010:19050))/40);
    noisevar7 = (sum(P(19150:19190))/40) + (sum(P(19210:19250))/40);
    noisevar8 = (sum(P(19350:19390))/40) + (sum(P(19410:19450))/40);
    noisevar9 = (sum(P(19550:19590))/40) + (sum(P(19610:19650))/40);
    noisevar10 = (sum(P(19750:19790))/40) + (sum(P(19810:19850))/40);

    % weight each frame against inverse of the noise variance for MRC
    s(range1(1):range1(2)) = s(range1(1):range1(2)) / noisevar1;
    s(range2(1):range2(2)) = s(range2(1):range2(2)) / noisevar2;
    s(range3(1):range3(2)) = s(range3(1):range3(2)) / noisevar3;
    s(range4(1):range4(2)) = s(range4(1):range4(2)) / noisevar4;
    s(range5(1):range5(2)) = s(range5(1):range5(2)) / noisevar5;

    s(range6(1):range6(2)) = s(range6(1):range6(2)) / noisevar6;
    s(range7(1):range7(2)) = s(range7(1):range7(2)) / noisevar7;
    s(range8(1):range8(2)) = s(range8(1):range8(2)) / noisevar8;
    s(range9(1):range9(2)) = s(range9(1):range9(2)) / noisevar9;
    s(range10(1):range10(2)) = s(range10(1):range10(2)) / noisevar10;

    % only want the real portions of the stft
    sAbs =  abs(s);
      
    % find the max power frequency in the window
    [maxValue1, indexMax1] = max(sAbs(range1(1):range1(2)));
    [maxValue2, indexMax2] = max(sAbs(range2(1):range2(2)));
    [maxValue3, indexMax3] = max(sAbs(range3(1):range3(2)));
    [maxValue4, indexMax4] = max(sAbs(range4(1):range4(2)));
    [maxValue5, indexMax5] = max(sAbs(range5(1):range5(2)));

    [maxValue6, indexMax6] = max(sAbs(range6(1):range6(2)));
    [maxValue7, indexMax7] = max(sAbs(range7(1):range7(2)));
    [maxValue8, indexMax8] = max(sAbs(range8(1):range8(2)));
    [maxValue9, indexMax9] = max(sAbs(range9(1):range9(2)));
    [maxValue10, indexMax10] = max(sAbs(range10(1):range10(2)));

    % index is max index + the window start
    indexMax1 = indexMax1 + range1(1);
    indexMax2 = indexMax2 + range2(1);
    indexMax3 = indexMax3 + range3(1);
    indexMax4 = indexMax4 + range4(1);
    indexMax5 = indexMax5 + range5(1);

    indexMax6 = indexMax6 + range6(1);
    indexMax7 = indexMax7 + range7(1);
    indexMax8 = indexMax8 + range8(1);
    indexMax9 = indexMax9 + range9(1);
    indexMax10 = indexMax10 + range10(1);

    % each signal has been weighted against inverse of noise variance so
    % average
    avg1 = (freq(indexMax1) + freq(indexMax2) + freq(indexMax3) + freq(indexMax4) + freq(indexMax5)) / 5;
    avg2 = (freq(indexMax6) + freq(indexMax7) + freq(indexMax8) + freq(indexMax9) + freq(indexMax10)) / 5;
    
    % display the strongest frequency
    fprintf('freq1: %i\n', freq(indexMax1));
    fprintf('freq2: %i\n', freq(indexMax2));
    fprintf('freq3: %i\n', freq(indexMax3));
    fprintf('freq4: %i\n', freq(indexMax4));
    fprintf('freq5: %i\n', freq(indexMax5));
    
    dopplerShift1 = freq1Avg - avg1;
    dopplerShift2 = freq2Avg - avg2;
     
    % outlier removal
    if (dopplerShift1 > 10)
        % if the shift is larger than 10 then take the closest to the last
        % doppler shift estimation
        a = [(freq1 - freq(indexMax1))
             (freq2 - freq(indexMax2))
             (freq3 - freq(indexMax3)) 
             (freq4 - freq(indexMax4))
             (freq5 - freq(indexMax5))];
         
        b = [abs(lastDopplerShift1 - abs(a(1)))
             abs(lastDopplerShift1 - abs(a(2)))
             abs(lastDopplerShift1 - abs(a(3)))
             abs(lastDopplerShift1 - abs(a(4)))
             abs(lastDopplerShift1 - abs(a(5)))];
         
        [value, index] = min(b);
        % assign doppler shift to the closest
        dopplerShift1 = a(index);
    end
    lastDopplerShift1 = dopplerShift1;

        if (dopplerShift2 > 10)
        % if the shift is larger than 10 then take the closest to the last
        % doppler shift estimation
        a = [(freq6 - freq(indexMax6))
             (freq7 - freq(indexMax7))
             (freq8 - freq(indexMax8)) 
             (freq9 - freq(indexMax9))
             (freq10 - freq(indexMax10))];
         
        b = [abs(lastDopplerShift2 - abs(a(1)))
             abs(lastDopplerShift2 - abs(a(2)))
             abs(lastDopplerShift2 - abs(a(3)))
             abs(lastDopplerShift2 - abs(a(4)))
             abs(lastDopplerShift2 - abs(a(5)))];
         
        [value, index] = min(b);
        % assign doppler shift to the closest
        dopplerShift2 = a(index);
    end
    lastDopplerShift2 = dopplerShift1;

    %[kamf K M F] = kalman(dopplerShift, 0.00001, 0.00001);
    %kalmf = kalmf(1,:)
    fprintf('avg 1 %i\n', avg1);
    
    fprintf('Doppler shift 1 %i\n', dopplerShift1);
    
    speakerDist1 = speakerDist1 + (dopplerShift1) * 1;
    speakerDist2 = speakerDist2 + (dopplerShift2) * 1;
    
    % theta 1
    theta = acos(((speakerDist1^2) + (d^2) - (speakerDist2^2))/(2*d*speakerDist1));
    
    x1 = speakerDist1 * cos(theta);
    y1 = speakerDist1 * sin(theta);
    fprintf('X1: %i Y1 %i\n', x1, y1);
 
    plot(x1, y1, '*');
    
    fprintf('-----------------------\n');
    fprintf('speaker dist 1 %i\n', abs(speakerDist1));
    fprintf('speaker dist 2 %i\n', abs(speakerDist2));
    fprintf('-----------------------\n');
    
    % paint the spectorgram for debugging
    %spectrogram(audioIn, window, noverlap, nfft, Fs, 'yaxis')
    
    % paint the spectrum analyzer
    step(spectrum, audioIn);
end

% clean up
release(microphone)
release(spectrum)