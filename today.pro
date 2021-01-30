;+
;- 29 January 2021
;-
;- TO DO:
;-
;-  []  Save subset (and header!) centered on [xcen,ycen]; PADDED dimensions.
;-    --> INCOMPLETE
;-
;-  []  ALIGN data
;-    --> INCOMPLETE
;-
;-  []  IMAGE alongside concurrent AIA obs; check relative AR position.
;-    --> INCOMPLETE
;-
;- [] copy today.pro to some Module generalized for running alignment
;-    on any group of level 1.5 fits files (or level 1.0, shouldn't matter)
;-    --> INCOMPLETE
;-
;



;-- 

;+
;- Alignment -- broken down into detailed steps:
;-   • read level 1.5 (PREPPED) fits : index + data
;-   • crop to subset centered on AR
;-   • padded CUBE + INDEX -> fileame.sav
;-       (read_sdo takes too long and bogs system down to where nothing gets done
;-   • align cube to reference image (center of time series)
;-   • aligned_cube + INDEX -> filename2.sav
;-       index still the same, only data has changed...
;-


;-
;- IDEA for possibly making my life so much easier:
;-   Modify INDEX returned from READ_SDO instead of defining my own structures
;-   from scratch? Retain the few tags I need:
;-     • -> SAFER! No risk of entering incorrect numbers
;-           (like reversing the exptime for 1600 and 1700 ...)
;-     • Will save so much time w/o repeatedly looking up fits filename syntax,
;-         read_my_fits syntax, high CPU and memory useage to read large files,
;-         (even with /nodata set, still takes forever.)
;-
;-  [] Learn how to modify/update structures,  tho?
;-      Remove tags, add new tags,
;-      Combine multiple strucs into one master struc or array, 
;-      Syntax to access tags/values using tagnames OR index, eg "struc.(ii)"
;-      
;-


;+
;- Current collection in multiflare project:
;-   • C8.3 2013-08-30 T~02:04:00  (1)
;-   • M1.0 2014-11-07 T~10:13:00  (3)
;-   • M1.5 2013-08-12 T~10:21:00  (0)
;-   • C4.6 2014-10-23 T~13:20:00  (2)
;-  multiflare.(N) --> structure of structures
;-    current index order is as listed to the right of each flare
;-    (chronological order).
;-
;-

;-
;maxmin, variable

;--------


buffer = 1

instr = 'aia'
;channel = 1600
;channel = 1700

;instr = 'hmi'


flare_index = 0  ; M1.5
;flare_index = 1  ; C8.3
;flare_index = 2  ; C4.6
;flare_index = 3  ; M1.0

;--------


@par2
;- defines structure of structures:
;;-   IDL>   multiflare = { m15:m15, c83:c83, c46:c46, m10:m10 }
;help, multiflare

flare = multiflare.(flare_index)
date = flare.year + flare.month + flare.day

;- 'AIAyyyymmdd_hhmmss_wave.fits'

path = '/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
fnames = strupcase(instr) + date + '*' + strtrim(channel,1) + '.fits'

fls = FILE_SEARCH( path + fnames )

help, fls

;start_time = systime()
;for ii = 0, n_elements(index)-1 do begin
;    ind = [ii:ii+increment-1]
;    READ_SDO, fls[ind], index, data
;endfor


stop;---------------------------------------------------------------------------------------------



;!CPU

;for ii = 50, 745, 50 do begin
;    ind = [ ii-50 : ii-1 ]
;    print,  ii-50, ii-1
;endfor
;ind = [ 0 : n_elements(fls)-1 : 1 ]
;help, ind
;print, ind[0:4]
;print, ind[-5 : -1]
;while ii = 0,  do


;-----------------------------------------------
;- START HERE ----------------------------------
;-----------------------------------------------


dimensions = [800,800]
READ_SDO, fls, index, data, /nodata
spatial_scale = index[0].cdelt1
exptime = index[0].exptime
;print, array_equal( index.exptime, index[0].exptime )
;print, index[0].pixlunit
;
;half_dimensions = [ index[0].crpix1, index[0].crpix2 ]
;center =  half_dimensions + ([flare.xcen, flare.ycen]/spatial_scale)
full_dimensions = [ index[0].naxis1, index[0].naxis2 ]
center = FIX( (full_dimensions/2) + ([flare.xcen, flare.ycen]/spatial_scale) )
;-  "full_dimensions" avoids fractional pixel coords, if it matters...
;print, 'center coords = ',  center, ' (pixels)'

;ind = indgen(7)*100

cube = []

stop;---------------------------------------------------------------------------------------------


;for ii = 0, n_elements(fls), 100 do begin
;    if ii+100-1 GE n_elements(fls) then begin
;        ind = [ii:n_elements(fls)-1]
;    endif else begin
;        ind = [ii:ii+100-1]
;    endelse
;    READ_SDO, fls[ind], index, data
;    cube = [ [[ cube ]], $
;        [[ CROP_DATA( data, dimensions=dimensions, center=center ) ]] ]
;    help, cube
;    undefine, index
;    undefine, data
;endfor

;cube = fltarr( dimensions[0], dimensions[1], n_elements(fls) )

start_time = systime()
;
for ii = 0, n_elements(fls)-1 do begin
    READ_SDO, fls[ii], index, data
    cube = [ [[ cube ]], $
        [[ CROP_DATA( data, dimensions=dimensions, center=center ) ]] ]
    ;cube[*,*,ii] = CROP_DATA( data, dimensions=dimensions, center=center )
    ;help, cube
    undefine, index
    undefine, data
endfor
;
print, "Started at ", start_time
print, "Finished at ",  systime()

stop;---------------------------------------------------------------------------------------------

READ_SDO, fls, index, data, /nodata
help, index
;- [] check that n_elements(index) matches sz[2] of cube.
;
;help, flare
;savefile = 'm15_' + instr + strtrim(channel,1) + 'cube.sav'
savefile = date + '_' + instr + strtrim(channel,1) + 'cube.sav'
print, savefile
;

SAVE, index, cube, filename=savefile



end
