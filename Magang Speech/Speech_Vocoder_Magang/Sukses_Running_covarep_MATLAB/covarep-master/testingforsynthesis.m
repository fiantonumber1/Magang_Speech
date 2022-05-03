% Harmonic Model + Phase Distortion (HMPD) vocoder
%
% Copyright (c) 2014 University of Crete - Computer Science Department(UOC-CSD)/ 
%                    Foundation for Research and Technology-Hellas - Institute
%                    of Computer Science (FORTH-ICS)
%
% License
%  This file is under the LGPL license,  you can
%  redistribute it and/or modify it under the terms of the GNU Lesser General 
%  Public License as published by the Free Software Foundation, either version 3 
%  of the License, or (at your option) any later version. This file is
%  distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
%  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
%  PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
%  details.
%
% This function is part of the Covarep project: http://covarep.github.io/covarep
%
% Author
%  Gilles Degottex <degottex@csd.uoc.gr>
%

clear all;

fname = 'vaiueo2d';
[wav, fs] = audioread([fname '.wav']);


% Analysis ---------------------------------------------------------------------

addpath(genpath('vocoder/hmpd'))
addpath(genpath('sinusoidal'))
addpath(genpath('glottalsource'))
addpath(genpath('misc'))
addpath(genpath('envelope'))


hmpdopt = hmpd_analysis();
hmpdopt.f0min   = 75; % To adapt to the analyzed voice
hmpdopt.f0max   = 220;% To adapt to the analyzed voice

% Speed up options
%  hmpdopt.sin.use_ls=false;   % For analysis step, use simple Peak Picking 
%  hmpdopt.sin.fadapted=false; % For analysis step, use the stationary DFT 
%  hmpdopt.usemex = true; % Use mex linear interp (affects mainly the synth.)

% Compression options
%  hmpdopt.amp_enc_method=2; hmpdopt.amp_log=true; hmpdopt.amp_order=39;
%  hmpdopt.pdd_log=true; hmpdopt.pdd_order=12;% MFCC-like phase variance
%  hmpdopt.pdm_log=true; hmpdopt.pdm_order=24;% Number of log-Harmonic coefs
[f0s,VUVDecisions,SRHVal,f0times] = pitch_srh(wav, fs, hmpdopt.f0min, hmpdopt.f0max, 5);
[f0s, AE, PDM, PDD] = hmpd_analysis(wav, fs,f0s, hmpdopt);


% Synthesis --------------------------------------------------------------------

synopt = hmpd_synthesis();
synopt.enc = hmpdopt; 
synopt.usemex = hmpdopt.usemex; % Speed up with mex function
syn = hmpd_synthesis(f0s, AE, [], PDD, fs, length(wav), synopt);
audiowrite([fname '.hmpd-pdd.wav'], syn, fs);

