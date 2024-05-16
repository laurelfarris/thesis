;-
;- 16 May 2024
;-   > ls timestamp = 31 July 2019 (most recent edit time before today)
;-
;-
;- 20 December 2018
;-   Main Level, lots of hardcoded stuff...
;-
;-


;- 19 November 2018 (p. 73)

pro image_maps, imdata, title=title, rgb_table=rgb_table

    ;- Try image3.pro at some point

end

;---- Quiescent region power maps ----;

goto, start
journal, '2018-11-19.pro'
;- attach to bottom of today.pro?

start:;-------------------------------------------------------------------------------------------------

cc = 1
channel = A[cc].channel
restore, '../aia' + channel + 'map_2.sav'

;- Center coords (lower right corner)
x0 = 425
y0 = 75
r = 125

;- Crop both continuum image (cont) and power map (map).
;quiet_cont = crop_data( map, center=[x0,y0], dimensions=[r,r] )
;quiet_map = crop_data( map, center=[x0,y0], dimensions=[r,r] )

;- Better way: same variable for images and maps... last 63 elements of map will be zeros.
quiet = fltarr(r, r, 749, 2)
quiet[0,0,0,0] = crop_data( A[cc].data, center=[x0,y0], dimensions=[r,r] )
quiet[0,0,0,1] = crop_data( map, center=[x0,y0], dimensions=[r,r] )

;- Don't need mask because this area isn't saturated.

dz = 64

;- BDA (B: between pre-flare event and main flare, D: flare start, A: between two post-flare events)
z_start = [196, 260, 525]

time = strmid( A[0].time, 0, 5 )


imdata = [ $
    [[ mean(quiet[*,*,[z_start[0]:dz-1],0], dim=3) ]], $
    [[ mean(quiet[*,*,[z_start[1]:dz-1],0], dim=3) ]], $
    [[ mean(quiet[*,*,[z_start[2]:dz-1],0], dim=3) ]], $
    [[ quiet[*,*,z_start[0],1] ]], $
    [[ quiet[*,*,z_start[1],1] ]], $
    [[ quiet[*,*,z_start[2],1] ]] $
]


    ; 16 May 2024 -- how I think these arrays were meant to be defined:
    imdata = [ $
        [[ mean(quiet[*,*,[z_start[0]:z_start[0]+dz-1] ,0], dim=3) ]], $
        [[ mean(quiet[*,*,[z_start[1]:z_start[1]+dz-1] ,0], dim=3) ]], $
        [[ mean(quiet[*,*,[z_start[2]:z_start[2]+dz-1] ,0], dim=3) ]], $
        [[ quiet[*,*,z_start[0],1] ]], $
        [[ quiet[*,*,z_start[1],1] ]], $
        [[ quiet[*,*,z_start[2],1] ]] $
    ]

max_value = [ 239, 239, 239, 103, 103, 103 ]
min_value = [ 50, 50, 50, 0.006, 0.006, 0.006 ]

;for ii = 0, 5 do print, min(imdata[*,*,ii])

    dw
    wx = 8.0
    wy = 6.0
    win = window( dimensions=[wx,wy]*dpi, /buffer )

    cols = 3
    rows = 2

    title = [ $
        time[z_start[0]] + '-' + time[z_start[0]+dz-1], $
        time[z_start[1]] + '-' + time[z_start[0]+dz-1], $
        time[z_start[2]] + '-' + time[z_start[1]+dz-1], $
        time[z_start[0]] + '-' + time[z_start[1]+dz-1], $
        time[z_start[1]] + '-' + time[z_start[2]+dz-1], $
        time[z_start[2]] + '-' + time[z_start[2]+dz-1] $
    ]

        ; 16 May 2024 -- how I think these arrays were meant to be defined:
        title = [ $
            time[z_start[0]] + '-' + time[z_start[0]+dz-1], $
            time[z_start[1]] + '-' + time[z_start[1]+dz-1], $
            time[z_start[2]] + '-' + time[z_start[2]+dz-1], $
            time[z_start[0]] + '-' + time[z_start[0]+dz-1], $
            time[z_start[1]] + '-' + time[z_start[1]+dz-1], $
            time[z_start[2]] + '-' + time[z_start[2]+dz-1] $
        ]

    for ii = 0, 5 do begin

        im = image2( $
            imdata[*,*,ii], $
            layout = [cols,rows,ii+1], $
            margin = 1.00*dpi, $
            /current, /device, $
            min_value = min_value[ii], $
            max_value = max_value[ii], $
            xtitle = 'X (pixels)', $
            ytitle = 'Y (pixels)', $
            rgb_table = A[cc].ct, $
            title = title[ii] )
    endfor

file = 'aia' + A[cc].channel + '_quiet_powermaps'
;-  NOTE: in Dropbox/Figures/Subregions/, there are a few figures of
;-    quiet sun powermaps, overlaid with contours, but didn't find any
;-    figures that match the file name defined here.
;-  May have renamed these figures at some point during quest to find
;-   the perfect file naming system (or at least good enough to know what
;-   kind of figure is shown and whether it's the one I'm looking for...
;- (31 July 2019)

save2, file, /add_timestamp

end
