function [x1, y1, x, y] = Unified_TMO(L, Ld)
%   [x1, y1, x, y] = Convert_TMO_to_MATT(L, Ld)
%   This code represents any global TMO into a form of 256 co-efficients,
%   and thus allows a uniform implementation for all global TMOs
%
%   Input:
%       -L: input HDR image luminance
%       -Ld: Display luminance (LDR) obtained by using the original TMO
%        Ideally the relationship should be monotonic.
%           
%   Output:
%       -[x1, y1]: LUT of order 1 representing the TMO usisng 256 values.
%         y1 is fixed here y1 = [0:255]. So the TMO is actually represented
%         by the 256 coefficients of x1 only.
%       -[x,y] : LUT of order 2 representing the TMO. Here both x and y
%         have the same length which is not 256 necessarily
%
%     Copyright (C) Ishtiaq Rasool Khan
%     Please cite: I. R. Khan, MBE 2022

% Sort L and Ld
L1 = L(:); 
[L1, idx] = sort(L1); 
Ld1 = Ld(:); 
Ld1= Ld1(idx);

% Remove duplicate HDR values
[L1, idx]=unique(L1);
Ld1 = Ld1(idx);

% Extract key points
[x, y] = ikey_points(L1, Ld1, 0.00001, 5000);
%figure, plot(L(:), Ld(:), '.b', x, y, '+r');

% Convert to a unified format: 
% Extract 256 HDR values where LDR values are 0, 1, 2, ..., 255.
lm = 0:255;
y1 = min(y)+lm/255*(max(y)-min(y));
x1 = interp1(y, x, y1,'linear','extrap');
%figure, plot(x, y, '+', (x1), y1);

end

%% ---------------------------------------------------------------------
function [yy, xx, delta] = ikey_points(y, x, delta, max_no_key_points)
%-----------------------------------------------------------------------

% Reshape data as a vector of unique values
y1 = y;
[x, i] = unique(x);
y = y(i);
y(end) = y1(end); % sometimes maximum value is lost % added for Kim TMO on SNOW.hdr

% default values of the input arguments
if nargin < 3, 
    delta = 0.005; %(max(y) - min(y))/nPoints;
end
if nargin < 4
    max_no_key_points = 100;
end

% start with two end points in the LUT
xx = [min(x), max(x)];
yy = [min(y), max(y)];

% Approximated values of y using the initial LUT
y0 = interp1(xx, yy, x);

while(numel(xx) < max_no_key_points)
    
    % deviation of original y from approximated y0
    [m, j] = max(abs(y - y0));
    if m <= delta, break; end
    
    % add the point with maximum deviation to the LUT for better accuracy
    xx = [xx, x(j)]; xx = sort(xx);
    yy = [yy, y(j)]; yy = sort(yy);
    
    % Calculate y0, the approximate y, using new LUT
    y0 = interp1(xx, yy, x);
    
    %figure(4), plot(y, x, 'r', yy, xx, 'b');
end
delta = m;

end



