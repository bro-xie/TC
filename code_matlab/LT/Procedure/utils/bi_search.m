% find the first number larger than val(equaling is okay).
function [index] = bi_search(vector, val)
    l = 1;
    r = length (vector);
    mid = floor ((l + r) / 2);
    while (l < r)
        if (vector (mid) < val)
            l = mid + 1;
        else
            r = mid;
        end
        mid = floor ((l + r) / 2);
    end
    index = mid;
end

