;+
;-   
;-   
;- Not really used ...
;-   one line in "MAKE_PLOTS.pro", but it's commented
;-



function NORMALIZE_YDATA_OLD, p
    ; Last modified:  Sometime before 17 November 2018
    for i = 0, n_elements(p)-1 do begin
        p[i].GetData, x, y
        y = y-min(y)
        y = y/max(y)
        p[i].SetData, x, y
    endfor
    ax = p[0].axes
    ax[1].style = 2
    ax[1].tickinterval = 0.2
    ax[1].title = 'Intensity (normalized)'
    return, p
end



pro NORMALIZE_YDATA, plt
    ; Last modified:    17 November 2018

    for ii = 0, n_elements(plt)-1 do begin

        plt[ii].GetData, xx, yy

        ;yy = yy-min(yy)
        ;yy = yy/max(yy)

        ;- 20 November 2018
        ;- Finally figured a one-line way to normalize between 0 and 1
        yy_norm = (yy-min(yy)) / (max(yy)-min(yy))

        plt[ii].SetData, xx, yy_norm

    endfor

    ax = plt[0].axes
    ;ax[1].style = 2
    ;ax[1].major = 5
    ;ax[1].tickinterval = 0.2
    ;ax[1].tickvalues = [0.0, 0.5, 1.0]
    ax[1].tickvalues = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
    ;ax[1].tickformat = '(F0.1)'
    ;ax[1].tickname = strtrim(ax[1].tickvalues,1)
    ax[1].title = ax[1].title + ' (normalized)'
    ax[3].showtext = 0
end
