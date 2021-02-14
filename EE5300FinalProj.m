%%
%Run script
%EE5300 Project
%Evan Lucas

%grab file
[loadme,loadpath] = uigetfile('*.*');
curdir = pwd;
cd(loadpath);
[y,Fs] = audioread(loadme);
cd(curdir);

%%
%get that spectrogram
figure
% 
% [s,f,t] = spectrogram(y(:,1),hanning(floor(Fs/20)),floor(Fs/80),floor(Fs/20),Fs);

[s,f,t] = spectrogram(y,hanning(128),0,128,Fs);
s = abs(s);
figure(1)
imagesc(t,f,log(abs(s)))
set(gca, 'YDir','normal')

% s = filter(Num5,1,s);
% s = filter([-1 1],1,s);
g = abs(asinh(s));
figure(3)
imagesc(t,f,log(g))
set(gca, 'YDir','normal')

b = [-1 1];
differentiated = filter(b,1,g,[],2);

figure(2)
imagesc(t,f,log(abs(differentiated)))
set(gca, 'YDir','normal')

e = sum(abs(differentiated));


figure
plot(t,e)

[p,i] = findpeaks(e,'MinPeakProminence',4);

%tempo assumption is 40 to 220 bpm

tempoq = 1./diff(t(i));
%%


imagesc(t,f,log(abs(s)))
set(gca, 'YDir','normal')

%simple smoothing lpf
filtsize = 3;
% smoothingfilt = ones(filtsize)./filtsize^2;
% smoothed = conv2(smoothingfilt,s);
smoothed = medfilt2(s);
figure(2)
imagesc(t,f,log(abs(smoothed)))
set(gca, 'YDir','normal')

%create remez differentiator filter using filter order from paper
b = cfirpm(8,[.1 1],{@differentiator});
% figure(4)
% fvtool(b,1,'OverlayedAnalysis','phase')
% b = [-1 1];
differentiated = filter(b,1,smoothed,[],2);

figure(3)
imagesc(t,f,log(abs(differentiated)))
set(gca, 'YDir','normal')


%spectral flux
figure(6)
x = sum(abs(differentiated));
plot(x)

%alternate method

s2 = asinh(s);
b = [-1 1];
differentiated2 = filter(b,1,s2,[],2);

figure(4)
imagesc(t,f,log(abs(differentiated2)))
set(gca, 'YDir','normal')



%spectral flux
figure(5)
x = sum(abs(differentiated2));
plot(t,x)
