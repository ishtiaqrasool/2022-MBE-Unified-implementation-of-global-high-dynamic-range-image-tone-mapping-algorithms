function [imgOut, L, Ld] = ReinhardTMO_IRK(img, pAlpha, pWhite, pLocal, pPhi)
% This is a modified version of the code taken from Benterle's toolbox.
% Only the returned values are changed.
%
%
%   Input:
%       -img: input HDR image
%       -pAlpha: value of exposure of the image
%       -pWhite: the white point 
%       -pLocal: boolean value. If it is true a local version is used
%                otherwise a global version.
%       -pPhi: a parameter which controls the sharpening
%
%   Output:
%       -imgOut: output tone mapped image in linear domain (the original)
%       -L: HDR luminance array %Ishtiaq
%       -Ld: LDR luminance array %Ishtiaq
%
%     Copyright of the original code (C) 2011-15  Francesco Banterle.
%     Licensed uder GNU General Public License

tic
check13Color(img);

%Luminance channel
L = lum(img);

if(~exist('pLocal', 'var'))
    pLocal = 0;
end

if(~exist('pAlpha', 'var'))
    pAlpha = ReinhardAlpha(L);
else
    if(pAlpha <= 0)
        pAlpha = ReinhardAlpha(L);
    end
end

if(~exist('pWhite', 'var'))
    pWhite = ReinhardWhitePoint(L);
else
    if(pWhite <= 0)
        pWhite = ReinhardWhitePoint(L);
    end
end

if(~exist('pPhi', 'var'))
    pPhi = 8;
else
    if(pPhi < 0)
        pPhi = 8;
    end
end

%Logarithmic mean calcultaion
Lwa = logMean(L);

%Scale luminance using alpha and logarithmic mean
Lscaled = (pAlpha * L) / Lwa;

%Local calculation?
if(pLocal)
    L_adapt = ReinhardFiltering(Lscaled, pAlpha, pPhi);
else
    L_adapt = Lscaled;
end

%Range compression
pWhite2 = pWhite * pWhite;
Ld = (Lscaled .* (1 + Lscaled / pWhite2)) ./ (1 + L_adapt);

%Changing luminance
imgOut = ChangeLuminance(img, L, Ld); %original code

end

function alpha = ReinhardAlpha(L)

LMin = MaxQuart(L, 0.01);
LMax = MaxQuart(L, 0.99);

log2Min     = log2(LMin + 1e-9);
log2Max     = log2(LMax + 1e-9);
logAverage  = logMean(L);
log2Average = log2(logAverage + 1e-9);

alpha = 0.18*4^((2.0*log2Average - log2Min - log2Max)/( log2Max - log2Min));

end


function Lav = logMean(img)

delta = 1e-6;
img_delta = log(img + delta);

Lav = exp(mean(img_delta(:)));

end

function wp = ReinhardWhitePoint(L)

LMin = MaxQuart(L, 0.01);
LMax = MaxQuart(L, 0.99);

log2Min     = log2(LMin + 1e-9);
log2Max     = log2(LMax + 1e-9);

wp = 1.5 * 2^(log2Max - log2Min - 5);

end
