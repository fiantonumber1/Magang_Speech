%%% https://github.com/HidekiKawahara/legacy_STRAIGHT
%%% https://www.mathworks.com/help/matlab/ref/audiowrite.html
[x, fs] = audioread('vaiueo2d.wav'); 
f0raw = MulticueF0v14(x,fs); 
ap = exstraightAPind(x,fs,f0raw);
n3sgram=exstraightspec(x,f0raw,fs);
[sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs);

filename = 'vaiueo2d_synthesis_straight.wav';
audiowrite(filename,sy,fs);
clear sy Fs
