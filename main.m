hdr_file = 'E:\Datasets\RGBE\memorial.hdr';
Yhdr = lum(hdr);

%% Tone-mapping using original code from hdr toolbox by Banterle
% We slightly modify the original code and return the luminance values for
% our next code
[ldr0, L, Ld] = ReinhardTMO_IRK(hdr);

%% Representing TMO in a unified format
% x is a 256x1 vector of HDR values which along with min and max values of
% LDR luminance can represent the original TMO
x = Unified_TMO(L, Ld);
min_ldr = min(Ld(:)); max_ldr = max(Ld(:));

%% Produce LDR image using modified TMO (in unified format)
y = 0:255;
y = min_ldr+y/255*(max_ldr-min_ldr);
Yldr = interp1(x, y, Yhdr, 'linear', 'extrap');
ldr2 = (hdr ./ Yhdr) .^ s .* repmat(Yldr, [1,1,3]);
max(abs(ldr1(:)-ldr2(:)))
