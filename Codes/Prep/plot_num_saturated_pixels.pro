



;- Sun Dec  2 21:37:34 MST 2018
;- Plot number of saturated pixels as function of index (time).


;nsat = float(aia1700index.nsatpix); + 1.0

;print, min(nsat)
;print, max(nsat)
;ind = [0:249]

;ind = where( nsat ne 0 )
;yy = nsat[ind]


;xx = [0:264]
;xx = [265:375]
;xx = [376:n_elements(nsat)-1]


;foreach ii, ind do $
;    print, format='(I4, I8)', ii, nsat[ii]


;get_lun, unit
;openw, unit, 'aia1700sat.txt'
;foreach ii, ind do $
;    printf, unit, format='(I4, I8)', ii, nsat[ii]
;close, unit

;ind = [0, 265, 376, n_elements(nsat)]
;ind = [0, 269, $ 320, 450, $ 450, 650, $ 650, n_elements(nsat) ]



left   = 1.5
right  = 1.5
top    = 1.5
bottom = 1.5

cols = 2
rows = 3



for cc = 0, 1 do begin

    if cc eq 0 then begin
        nsat = aia1600index.nsatpix
        file = 'aia1600sat'
    endif
    if cc eq 1 then begin
        nsat = aia1700index.nsatpix
        file = 'aia1700sat'
    endif

    ind = [ 0, 180, 268, 328, 480, 667, n_elements(nsat)-1 ]
    nn = n_elements(ind)

    wx = 8.5
    wy = 11.0
    win = window( dimensions=[wx,wy]*dpi, location=[500,0])
    plt = objarr(nn-1)

        for ii = 0, nn-2 do begin
            xx = [ ind[ii] : ind[ii+1]-1 ]
            plt[ii] = plot2( $
                xx, nsat[xx]+0.1, $
                /current, $
                /device, $
                layout=[cols,rows,ii+1], $
                xticklen=0.015, $
                yticklen=0.015, $
                ytickformat='(I0)', $
                margin=[left, bottom, right, top]*dpi, $
                stairstep=1, $
                color=A[cc].color )
        endfor
    save2, file, /add_timestamp
endfor
stop

;----------------------------------------------------------------------------------------




for ii = 0, nn-2 do begin
    xx = [ ind[ii]:ind[ii+1]-1 ]
    plt[ii] = plot2( $
        xx, nsat[xx], $
        /current, $
        /device, $
        layout=[1,nn-1,(ii/2)+1], $
        margin=[left, bottom, right, top]*dpi, $
        stairstep=1, $
        color='red' )
    ;print, (plt.position)*wy
    ;plt.position = plt.position + [0.0, 0.05, 0.0, 0.05]*ii

endfor

;plt[1].position = plt[1].position + [0.0, -0.050, 0.0, 0.050]
;plt[3].position = plt[3].position + [0.0, 0.0, 0.0, 0.1]
;plt[4].position = plt[1].position + [0.0, -0.1, 0.0, 0.1]

stop

plt = BATCH_PLOT( $
    xx, nsat[xx], $
    wx = 11.0, $
    wy = 8.5, $
    top    = 2.5, $
    bottom = 2.5, $
    color='red', stairstep=1, $
    ;ylog=1, $
    buffer=0 )

;- indices of missing images from aia 1700
;missing = [148, 297, 446, 595]


;for ii = 1, 1 do $
    ;print, nsat[ missing[ii]-5 : missing[ii]+5 ]


;yy = [ [aia1600index.nsatpix], [aia1700index.nsatpix] ]
;help, yy


end
