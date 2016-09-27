function [normalized]=normMinMax(toNorm)
%normalizes the rows of toNorm to 0-1 by the following (v is a row vector
%from toNorm, v_i is then the components of v)
%vNormed_i=(v_i - min({v_i | v in toNorm}))...
%                   /(max({v_i | v intoNorm})-min({v_i | v in toNorm})))

normalized=toNorm-repmat(min(toNorm,[],1),size(toNorm,1),1);
normalized=normalized./repmat(max(normalized,[],1),size(normalized,1),1);
return