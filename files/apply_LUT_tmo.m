function out = apply_LUT_tmo(in, x, y, s)

if (nargin<4)
    
out = interp1(x, y ,in, 'linear', 'extrap');

else

in_lum = lum(in);
out_lum = interp1(x, y, in_lum, 'linear', 'extrap');
out = (in ./ repmat(in_lum, [1,1,3])) .^ s .* repmat(out_lum, [1,1,3]);

% out = zeros(size(in));
% out(:, :, 1) = (in(:, :, 1) ./ (in_lum)) .^ s .* (out_lum) ;
% out(:, :, 2) = (in(:, :, 2) ./ (in_lum)) .^ s .* (out_lum) ;
% out(:, :, 3) = (in(:, :, 3) ./ (in_lum)) .^ s .* (out_lum) ;

%out(out > max(y)) = max(y);

end

end
