;- 20 December 2018
;- Made a copy so I could experiment with caling the same imaging routine
;- for powermaps, no matter how many there are or whether looking at full
;- AR or small subsection.

;- 17 December 2018
;- Makes array of graphics across single window:
;-   one each for B, D, and A, where each phase in BDA has
;-   several start indices to cover time periods of interest.
;- (Also see bda_powermaps.pro, which generates a single image on which
;-   contours and polygons can be viewed in detail.)
;- At time of writing, powermap figures in article1 were generated from
;-   this routine.


;IDL> .run powermap_mask
;- Restores maps AND multiplies them by saturation mask
;-   (but not without asking first).


;- 3 figures (one each for BDA) with array of 9  power maps each

;phase = "before"
;z_start = [0, 16, 27, 58, 80, 90, 147, 175, 196]
;phase = "during"
;z_start = [197, 200, 203, 216, 248, 265, 280, 291, 311]
phase = "after"
z_start = [ 387, 405, 450, 467, 475, 525, 625, 660, 685 ]

N = n_elements(z_start)
bda = fltarr(500, 330, N)
title = strarr(N*2)

rows = 3
cols = 3

struc = {}
for cc = 0, 1 do begin

    channel = A[cc].channel
    exptime=A[cc].exptime
    time = strmid(A[cc].time,0,5)

    bda = A[cc].map[*,*,z_start]


    ;- Need to review concatenating structures in IDL notes...
    struc = create_struct( $
        struc, $
        imdata : alog10(bda+0.1), $
        title : time[z_start] + '-' + time[z_start+dz-1] + ' UT'
        rgb_table : A[cc].ct, $
    }
end

    resolve_routine, 'image_powermaps_general', /either

    ;- Call with kws that are consistent over all types of structures.
    ;- E.g. define two structures, one for each AIA channel
    ;-  (do this once, instead of redefining all variables over and over).
    ;- Unique kws are pulled from structures.
    im = IMAGE_POWERMAPS_GENERAL( struc, $
        left=0.2, right=1.0, $  ; --> space for colorbar
        rows=3, cols=3 )

    ;- Overlay titles on images instead of above them, left-aligned,
    ;- with letters, (a), etc. also at top, right-aligned
    ;-   --> really hacky.
    title_color = ["white", "black"]
    foreach zz, z_start, ii do begin
        im[ii].title = " "
        ti = text( $
            0+20, sz[1]-5, $
            A[cc].name + ' ' + time[zz] + '-' + time[zz+dz-1] + ' UT', $
            /data, $
            target=im[ii], $
            font_size=fontsize, $
            alignment = 0.0, $
            vertical_alignment = 1.0, $
            color=title_color[cc] )
        txt = text( $
            sz[0]-20, sz[1]-5, $
            alph[ii], $
            target=im[ii], $
            /data, $
            font_size=fontsize, $
            alignment = 1.0, $
            vertical_alignment = 1.0, $
            color=title_color[cc]  )
    endforeach
    resolve_routine, 'colorbar2', /either
    ;cbar = colorbar3( target=im[2], title = 'mean intensity', tickformat='(I0)' )
    ;cbar = colorbar3( target=im[5], title='log 3-minute power' )
    cbar = colorbar2( target=im, title='log 3-minute power' )
endfor
end
