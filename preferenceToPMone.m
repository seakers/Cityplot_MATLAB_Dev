function multiplier=preferenceToPMone(preference, varargin)
% takes preferences as a vector or cell array and returns a multiplier of +/- 1 such that
% when a matrix of criteria is elementswise multiplied, gets a minimization
% problem 
% allowable preferences are:
%     mimization: 'min', 'minimization' ,'smaller-is-better', 'sib', numbers ~=0, true
%     maximization: 'max', 'maximization', 'larger-is-better', 'lib', numbers ==0, false
% NOTE: currently assumes a nxm martix output where n the OutputShape and m
% is the length of the preference vector.
p=inputParser;
p.addRequired(p, 'preference');
p.addOptional(p, 'OutputShape',1);
parse(p);

numRows=p.OutputShape; 
multiplier=ones(numRows, length(preference));

if ~iscell(preference)
    preference=num2cell(preference);
end

for i=1:length(preference)
    thisPref=preference{i};
    if ~toLogical(thisPref)
        multiplier(:,i)=-multiplier(:,i);
    end
end
    
return

function logPref=toLogical(pref)
if islogical(pref)
    logPref=pref;
elseif isnumeric(pref)
    logPref=logical(pref);
elseif(ischar(pref))
    if strcmp(pref, {'min', 'minimization' ,'smaller-is-better', 'theRightWay'})
        logPref=true;
    elseif strcmp(pref, {'max', 'maximization', 'larger-is-better', 'lib', 'wasteOfTime'})
        logPref=false;
    else
        error(['unrecognized string input to preferenceToPMone: ',pref]);
    end
end