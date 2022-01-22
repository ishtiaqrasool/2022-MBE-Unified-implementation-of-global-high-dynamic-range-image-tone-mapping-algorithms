function [x, y] = design_att(hdr)

nbins = [70; 90];
scale_factor = 179;
hdr = scale_factor * hdr;
hdr_lum = lum(hdr);
[~,midx] = min(hdr_lum); hdr_lum(midx) = min(hdr(:));
[~,midx] = max(hdr_lum); hdr_lum(midx) = max(hdr(:));
%hdr_lum = set_range(hdr_lum, min(hdr(:)), max(hdr(:)));
hdr_lum_log = log10(hdr_lum);

%
% calculate bin centers equi-spaced in terms of JND
%
n = 16;
while(1)
    jnd = [];
    bins = min(hdr_lum(:));
    while (bins(end) < max(hdr_lum(:)))
        jnd = [jnd; 10 ^ (tvi (log10(bins(end))))];
        bins = [bins; bins(end) + n * jnd(end)];
    end
    bins(end) = max(hdr_lum(:));
    if(numel(bins) < nbins(1))
        n = n - 2;
        if n==0; n = 0.1; end
    elseif(numel(bins) > nbins(2))
        n = n + 1.5;
    else break;
    end
end

%
% jnd measured above is based on bin edge. here we adjust it based on bin
% centers also we find nuber of jnd spanned by each bin
%
centers = 0.5*(bins(2:end)+bins(1:end-1));
centers = log10(centers);
jnd = 10.^tvi(centers);
counts = hist(hdr_lum_log(:), centers)';

%
% refined counts ignoring indistinguishable pixels in each bin
%
rcounts = zeros(size(centers));
for i = 1 : numel(rcounts)
    j = find(hdr_lum >= bins(i) & hdr_lum < bins(i+1));
    pix = sort(hdr_lum(j));
    
    while(1)
        diff = pix(2:2:end) - pix(1:2:end-1);
        k = find(diff < jnd(i));
        if(isempty(k))break; end
        pix(2*k) = [];
    end
    
    rcounts(i) = max(size(pix));
end

%figure, plot(counts);    figure, plot(rcounts);

w1 = 0.5;%255/sum(rcounts);
w2 = 0.5;
counts = counts / sum(counts);
rcounts = rcounts / sum (rcounts);

counts = w1*counts + w2*rcounts;

w = [0; counts/max(counts)];
for i = 2 : max(size(w))
    w(i) = w(i) + w(i-1);
end
x = double(bins)/scale_factor;
y = double(w) / max(w);
%figure, plot(x, y);

end

