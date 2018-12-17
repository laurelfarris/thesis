

; Last modified:    17 November 2018


;- Do axes already need to be labeled with the desired
;- xtickinterval or xtickvalues?
;-  --> YES.

pro LABEL_TIME, plt, time=time, jd=jd



    win = GetWindows(/current)
    ax = plt[0].axes

;    g = goes()
;    utbase = g.utbase
    ax[0].title = 'Start Time (15-Feb-2011 00:00:01 UT)'

    ;- Version1: LCs plotted as func of index, not jd.
    if keyword_set(time) then begin
        time = strmid(time,0,5)
        ax[0].tickname = time[ax[0].tickvalues]
    endif


    ;- Version2: LCs plotted as func of jd. Much more complicated...

    if keyword_set(jd) then begin

        plt[0].GetData, xx, yy
        ;- If plotted as function of JD (ie xtickvalues are julian dates):
        diff = (plt[0].xtickvalues)[0] - (xx[0])
        plt[0].xtickvalues =  plt[0].xtickvalues - diff

        CALDAT, plt[0].xtickvalues, $
          month, day, year, hour, minute, second

        hour = strtrim(hour,1)
        minute = strtrim(minute,1)
        for jj = 0, n_elements(hour)-1 do begin
            if strlen(hour[jj]) eq 1 then hour[jj] = '0' + hour[jj]
            if strlen(minute[jj]) eq 1 then minute[jj] = '0' + minute[jj]
        endfor
        ax[0].tickname = hour + ':' + minute
    endif

    return
;---




    ;- older stuff: input time and use it to set ticklabels

    ;ax[0].xtitle = 'Start time (UT) on ' + gdata.utbase
    ;time = strmid(A[0].time,0,5)
    ax[0].tickname = time[ax[0].tickvalues]

;---


    ; use JULDAY to set xtickvalues before plotting?
    month = 2
    day = 15
    year = 2011
    minute = 0
    second = 0

    xmajor = 5
    xtickvalues = julday( month, day, year, indgen(xmajor), minute, second )

    ;xtickvalues = fltarr(xmajor)
    ;for i = 0, xmajor do begin $
        ;xtickvalues[i] = julday( month, day, year, indgen(xmajor), minute, second )

    ; Or use intervals...
    xtickinterval = 75

    ; there's a separate subroutine for this...
    ax = lc[0].axes
    ax[0].title = xtitle[0]
    ax[2].title = xtitle[1]
    ax[1].title = ytitle[0]
    ax[3].title = ytitle[1]


end
