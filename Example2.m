
addpath '.\files\';

hdr_file = 'memorial.hdr';
hdr = hdrread(hdr_file);

hdr_lum = lum(hdr);
s = 1;

%% When original TMO uses a LUT
% Here we show an example, where the original TMO is available in the form
% of a look-up-table (LUT). We take the example of ATT algorithm.

[x0, y0] = design_att(hdr);
ldr0 = apply_LUT_tmo(hdr, x0, y0, s);

%% Unified Representation
% [x0, y0] above defines the LUT which can be used for tone-mapping using
% interploation. However, the size of x0 and y0 can change every time ATT is
% designed for a different image. We modify [x0, y0] to a new LUT where y is
% a vector of 256 eqally spaced values in [min(ldr), max(ldr)] range, and x
% is the corresponding HDR vector.

min_y0 = min(y0(:)); 
max_y0 = max(y0(:));
y = min_y0 : (max_y0-min_y0)/255 : max_y0;
x = interp1(y0, x0, y, 'linear', 'extrap');

%% How well the unified representation fit the original tone-curve?
y = 0:255; 
y = min_y0 : (max_y0-min_y0)/255 : max_y0;
figure, plot(x0, y0, '*', x, y, '-');

%% Uniform implementation
% The 256 values of x, min_y0, max_y0 generated above by the original
% TMO can accurately represent the original TMO. We call it the unified
% format for global TMOs.
%
% For ATT the min_y0 max_y0 are 0 and 255, however, this may not be the
% case for all TMOs, so we keep our code general to cover LUTs for other
% ranges. 
%
% Unified format allows a single implementation of all global TMOs. Next,
% we show this implementation.

ldr2 = apply_unified_tmo(hdr, hdr_lum, x, min_y0, max_y0);

%% Error
% calculate maximum deviation from the original. We show maximum of the
% absolute difference but other metrics can also be used.

delta = max(abs(ldr0(:)-ldr2(:)));
sprintf('%s %g', 'Max absolute difference is = ', delta)
