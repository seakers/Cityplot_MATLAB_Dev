function [normalized]=normMinMaxWithPref(toNorm, preference)
% decalres preference and normalizes for minimization with a max-min
% linear scale normalization.
% intended as a helper to cityplot. 
% to flip to maximization consider:
%        @(toNorm, pref) 1-normMinMaxWithPref(toNorm,pref)
normalized=normMinMax(toNorm.*preferenceToPMone(preference, 'OutputShape', size(toNorm,1)));