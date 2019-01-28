;- Fri Dec 14 02:36:40 MST 2018

;- Plot 3minute power as function of magnetic field strength
;-   (no spatial info here).

goto, start

aia_dz = 64
hmi_dz = (25.6 * 60)/H[0].cadence
;- dz is different for HMI because cadence is longer - almost twice as long.

;- H[0] is B_LOS, so index is unlikely to change.
cc = 0

;- Compare HMI BLOS at beginning and end of 25.6-minute time segment,
;-   to mean over entire time segment.
;imdata = [ $
;    [[ H[0].data[*,*,0] ]], $
;    [[ H[0].data[*,*,hmi_dz-1] ]], $
;    [[ mean( H[0].data[*,*,0:hmi_dz-1], dimension=3 ) ]]  ]
;title = [ $
;    H[0].name+' '+H[0].time[0], $
;    H[0].name+' '+H[0].time[hmi_dz-1], $
;    'mean ' + H[0].name + ' ' + H[0].time[0] + '-' + H[0].time[hmi_dz-1] ]

;dw
;@win

;for ii = 0, 2 do begin
;    im = image2( $
;        imdata[*,*,ii], $
;        /current, $
;        layout=[3,1,ii+1], $
;        margin=0.1, $
;        title=title[ii])
;endfor
;- very little seems to change...


;-----------------------------------------------------------------------
;- zoom in on AR_1a for simplicity (many fewer plot points...)
r = 10
x0 = 365
y0 = 215
;xdata = (mean( H[0].data[*,*,0:hmi_dz-1], dimension=3 ))[ [x0-r:x0+r-1], [y0-r:y0+r-1] ]
;ydata = (A[cc].map[*,*,0])[ [x0-r:x0+r-1], [y0-r:y0+r-1] ]
;-----------------------------------------------------------------------


;- Test using a few "Before" start indices.
;- NOTE: These are for AIA. Need to adjust for HMI's cadence.
;-   Should be able to just multiply by ratio of the two cadence values?
z_start = [16, 58, 197]
nn = n_elements(z_start)


foreach zz, z_start, ii do begin
    print, A[cc].time[zz]
    print, H[0].time[zz*( A[cc].cadence / H[0].cadence )]
endforeach
;- Close enough :)

stop

start:;---------------------------------------------------------------------------------
;- Full AR

dw
@win
;win = GetWindows(/current)
;win.delete

color = ['black', 'green', 'purple']

plt = objarr(nn)
foreach zz, z_start, ii do begin

    ;- xdata = magnetic field strength averaged over time period over which
    ;- power map was obtained for AIA.
    xdata = mean( H[0].data[*,*, zz : zz+hmi_dz-1], dimension=3 )

    ;- ydata = 3-minute power from AIA power map.
    ydata = A[cc].map[*,*,zz]

    sz = size(ydata, /dimensions)
    ;help, sz[0]*sz[1]
    ;- NOTE: sz is returned as LONG data type

    xdata = reform(xdata, sz[0]*sz[1], /overwrite)
    ydata = reform(ydata, sz[0]*sz[1], /overwrite)
    ;- Both are floats after running REFORM.

    plt[ii] = PLOT2( $
        xdata, ydata, $
        /current, $
        ;overplot=ii<1, $
        layout=[3,1,ii+1], $
        linestyle=6, $
        color=color[ii], $
        symbol='Circle', $
        sym_size=0.2, $
        xtickinterval = 300, $
        xminor = 5, $
        title = 'Pre-flare', $
        xtitle = 'magnetic field strength', $
        ytitle = '3-minute power', $
        name = H[0].time[zz] + '-' + H[0].time[zz:zz+hmi_dz-1] $
    )


endforeach

leg = legend2( target=plt )


;- Image power map and magnetic field used to generate plot(s).
;dw
;@win

;imdata = [ $
;    [[ alog10(A[0].map[*,*,0]) ]], $
;    [[ MEAN( H[0].data[*,*,0:hmi_dz-1], dimension=1 ) ]] ]


;- Could probably use same image/map/contour combos I already have...
;for ii = 0, 1 do begin
;    im = image2( $
;        imdata[*,*,ii], $
;        /current, $
;        layout=[1,2,ii+1], $
;        margin=0.1, $
;        rgb_table=A[0].ct, $
;        title=title[ii] )
;endfor

end
