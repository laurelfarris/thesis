

; Last modified:    17 November 2018


pro NORMALIZE_YDATA, plt
    for ii = 0, n_elements(plt)-1 do begin
        plt[ii].GetData, xx, yy
        yy = yy-min(yy)
        yy = yy/max(yy)
        plt[ii].SetData, xx, yy
    endfor

    ax = plt[0].axes
    ;ax[1].style = 2
    ;ax[1].major = 5
    ;ax[1].tickinterval = 0.2
    ;ax[1].tickvalues = [0.0, 0.5, 1.0]
    ax[1].tickvalues = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
    ;ax[1].tickformat = '(F0.1)'
    ;ax[1].tickname = strtrim(ax[1].tickvalues,1)
    ax[1].title = 'Intensity (normalized)'
    ax[3].showtext = 0
end
