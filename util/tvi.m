function threshold = tvi(intensity)

threshold = zeros(size(intensity));

idx = find(intensity < -3.94);
threshold (idx) = -2.86;

idx = find(intensity >= -3.94 & intensity < -1.44);
threshold (idx) = (0.405 * intensity(idx) + 1.6) .^ 2.18 - 2.86;

idx = find(intensity >= -1.44 & intensity < -0.0184);
threshold (idx) = intensity(idx) - 0.395;

idx = find(intensity >= -0.0184 & intensity < 1.9);
threshold(idx) = (0.249 * intensity(idx) + 0.65) .^ 2.7 - 0.72;

idx = find(intensity >= 1.9);
threshold (idx) = intensity(idx) - 1.255;       

%http://www.anyhere.com/gward/papers/DefDynRngSID08.pdf
% Ward thinks that 0.95 should be subtracted to get a better model
threshold = threshold - 0.95;