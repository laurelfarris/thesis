
;- Sun Jan 27 13:39:46 MST 2019
;- Plot 3minute power as function of magnetic field strength
;-
;-
;- To Do:
;-   Plot array of scatterplots, one for each time period of interest.
;-   Locate or create general routine or reference file with coords of subregions
;-     (both small ones and major ones around each sunspot).




function PLOT_POWER_VS_MAG, mag, power

    wx = 8.0
    wy = 8.0
    win = window( dimensions=[wx,wy]*dpi, location=[500,0] )

    plt = scatterplot2( $
        mag, power, $
        /current, $
        ;xrange=[200, max(xdata)], $
        ylog=1, $
        symbol='period', $
        xtitle = 'ABS(B$_{LOS}$)', $
        ytitle = '3-minute power' $
        )

end


goto, start
start:;----------------------------------------------------------------------------------

;im = image2( alog10(A[1].map[*,*,450]), /current, rgb_table = A[1].ct )

cc = 1


;- subregion coords
r = 10
x0 = 365
y0 = 215

;- Start time(s)
t_start = '01:19'
;t_start = '03:00'

stop
;------------------------------------------------------------------------------------------


;- Code below shouldn't have to change for different t_start, subregion, etc.
;-   (for now).
;- Uses a lot of info from A and H structures, so have to keep at main level for now.


dz = 64
dz_hmi = fix( (25.6 * 60)/H[0].cadence )
;dz_hmi = 34

time_aia = strmid(A[0].time, 0, 5)
time_hmi = strmid(H[0].time, 0, 5)

z_start_aia = (where( time_aia eq t_start ))[0]
z_start_hmi = (where( time_hmi eq t_start ))[0]


;- Crop data to desired subregion and time.
power = CROP_DATA( A[cc].map, dimensions=[r,r], center=[x0,y0], $
    z_ind=[z_start_aia] )
mag = CROP_DATA( H[0].data, dimensions=[r,r], center=[x0,y0], $
    z_ind=[z_start_hmi : z_start_hmi + dz_hmi - 1] )


;- Average B_LOS over dt from which 3minute power was obtained.
mag = mean( abs(mag), dimension=3 )


sz = size(power, /dimensions)
power = reform( power, sz[0]*sz[1] )
mag = reform( mag, sz[0]*sz[1] )



stop
;- Stopping this for now
;- Sun Jan 27 16:18:08 MST 2019




;--------------------------------------------------------------------------------- 
;- Below is original code from 2018-12-14.pro.
;- Haven't looked through this yet.


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
