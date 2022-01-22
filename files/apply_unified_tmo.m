function ldr = apply_unified_tmo(hdr, hdr_lum, x, min_y, max_y, s)

if ~exist('s', 'var'), s=1; end

% form equally spaced vector of 256 LDR luminance values
y = 0:255; 

% adjust the range to the min and max of original LDR luminance
y = min_y+y/255*(max_y-min_y); 

% generate ldr luminance
ldr_lum = interp1(x, y, hdr_lum, 'linear', 'extrap'); 

% get ldr RGB channels
s = 1;
ldr = (hdr ./ hdr_lum) .^ s .* repmat(ldr_lum, [1,1,3]); 

end