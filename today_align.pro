;+
;- 05->06 April 2021
;-


;+
;- TO DO:
;-
;-  [] re-align images
;-       • interpolate
;-       • align in pieces
;-       • use subset outside flare to compute alignment for all pixels
;-  [] interpolate to fill in missing 1700 images
;-  [] compute powermaps
;-

;- C8.3 2013-08-30 T~02:04:00  (1)
;- M1.5 2013-08-30 T~02:04:00  (1)


instr = 'aia'
;
channel = 1600
;channel = 1700

@par2

;flare_index = 1  ; C8.3
;flare = multiflare.(flare_index)
;-
;- OR, since flare_index is not used anywhere else, just use the TAGNAME:
;flare = multiflare.C83
flare = multiflare.M10
;flare = multiflare.M15
;-

;===

buffer = 1
;
date = flare.year + flare.month + flare.day
print, date
;
class = strsplit(flare.class, '.', /extract)
class = strlowcase(class[0] + class[1])
print, class
;

path = '/solarstorm/laurel07/flares/' + class + '_' + date + '/'
;
;filename = class + '_' + date + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
;shifts = allshifts[*,*,0]
;
filename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'cube.sav'
;
print, path + filename
print, file_exist(path + filename)

stop;----

restore, path + filename


;dw
;plt = PLOT_SHIFTS( allshifts[*,*,0], buffer=buffer)
;

;save2, class + '_' + instr + strtrim(channel,1) + '_OLD_shifts'

STOP

;----------------------------

;- Active Variables :
;-  index, cube, allshifts, ref, 
;-

;plot, allshifts[0,*,0]
;oplot, allshifts[1,*,0]

;help, allshifts[*,*,0]
;help, reform(allshifts[*,*,0])

;resolve_routine, 'plot_shifts', /is_function

;xdata = [310:360]
;xdata = [575:625]
;
;dw
;plt = PLOT_SHIFTS( $
;    ;allshifts[*,*,0], $
;    allshifts[*,xdata,0], $
;    xdata=xdata, $
;    buffer=buffer $
;    )
;save2, 'm15_allshifts'
;
;PLOT_ALLSHIFTS,  allshifts[*,*,0]




;- INTERPOLATE


;testarr = FLOAT([0,1,2,3,20,25,60,40,8,9])
;print, interpolate( testarr, [4,5,6,7] )
;;
;testarr = FLOAT( [0,1,2,3,8,9] )
;print, INTERPOL( testarr, 10 )
;;
;testarr = [-30.0, 30.0]
;result = INTERPOL( testarr, 750 )


;================================================================================================
;=>> Start here after restoring ...cube.sav (aka UNaligned) and re-do alignment
;=


;+
;- align_cube3, modified
;-

sz = size(cube, /dimensions)
shifts = fltarr(2,sz[2])
ref = reform(cube[*,*,sz[2]/2])
;
;aligned_cube = make_array( sz, /nozero )
;help, aligned_cube



;+
;- 1.
;- COMPUTE and PLOT [X,Y] shifts for each image 
;-


print, ''
print, 'Started computation at ', systime()
start_time = systime(/seconds)
;
for ii = 0, sz[2]-1 do begin
    ;offset = ALIGNOFFSET( cube[*,*,ii], ref )
    ;shifts[*,ii] = offset
    shifts[*,ii] = ALIGNOFFSET( cube[*,*,ii], ref )
endfor
;
runtime = systime(/seconds) - start_time
print, 'Finished computation at ', systime()
print, 'Total runtime = ', runtime, ' seconds = ', runtime/60., ' minutes'
print, ''
;-


;- Plot shifts
dw
plt = PLOT_SHIFTS(shifts, buffer=buffer)
save2, class + '_' + instr + strtrim(channel,1) + '_NEW_shifts'
;-
;- Save shifts to file
;shiftsfilename=class + '_' + instr + strtrim(channel,1) + '_shifts.sav'
;save, shifts, filename=shiftsfilename
;-




;
;
;+
;- 2.
;- INTERPOLATE shifts
;-
x_endpoints = [ shifts[0, 0], shifts[0, -1] ]
y_endpoints = [ shifts[1, 0], shifts[1, -1] ]
;
interp_shifts = make_array( size(shifts, /dimensions) )
interp_shifts[0,*] = interpol( x_endpoints, sz[2] )
interp_shifts[1,*] = interpol( y_endpoints, sz[2] )
;
;-
;- Plot interpolated shifts (should be straight lines)
dw
plt = PLOT_SHIFTS( interp_shifts, buffer=buffer )
save2, class + '_' + instr + strtrim(channel,1) + '_INTERP_shifts'
;--


;
diff = ABS(interp_shifts - shifts)
;
;shift_stats = make_array([2,4])
;shift_stats[0,*] = moment(diff[0,*])
;shift_stats[1,*] = moment(diff[1,*])
;print, shift_stats
;
;shift_stddev = shift_stats[*,1]
shift_stddev = make_array(2)
shift_stddev[0] = stddev(diff[0,*])
shift_stddev[1] = stddev(diff[1,*])
;help, shift_stddev
print, shift_stddev
;print, shift_stddev^2
;
dw
plt = PLOT_SHIFTS( diff, buffer=buffer )
save2, class + '_' + instr + strtrim(channel,1) + '_DIFF_shifts'
;

print, shift_stddev
print, n_elements( where( diff[0,*] gt shift_stddev[0] ))
print, n_elements( where( diff[1,*] gt shift_stddev[1] ))
;
print, 2.0*shift_stddev
print, n_elements( where( diff[0,*] gt 2*shift_stddev[0] ))
print, n_elements( where( diff[1,*] gt 2*shift_stddev[1] ))



;;= Test loop
;for jj = 0, 0 do begin
;    for ii = 310,324 do begin
;        print, diff[jj,ii] , shifts[jj,ii], shift_stddev[jj], diff[jj,ii] gt shift_stddev[jj]
;    endfor
;endfor
;====

;threshold = shift_stddev        ;- stddev
;threshold = shift_stddev * 2.0  ;- 2\sigma
;

;- threshold for iterations ii=1 and beyond
threshold = [1.0, 1.0]
;
;= Real loop
;-   NOTE: Better alternative : set locs = where( diff gt 5 ) & shifts[locs] = interp_shifts[locs]
;-     Later..
for jj = 0, 1 do begin
    for ii = 0, sz[2]-1 do begin
        ;if diff[ jj,ii ] gt threshold[jj] then shifts[ jj,ii ] = interp_shifts [ jj, ii ]
        if ABS(shifts[jj,ii]) gt threshold[jj] then shifts[ jj,ii ] = interp_shifts [ jj, ii-1 ]
    endfor
endfor
;
dw
plt = PLOT_SHIFTS( shifts, buffer=buffer )
save2, class + '_' + instr + strtrim(channel,1) + '_CORRECTED_shifts'
;====


;restore, 'm15_aia1600_CORRECTED_shifts.sav'
;--


;shiftsfilename=class + '_' + instr + strtrim(channel,1) + '_CORRECTED_shifts.sav'
;print, shiftsfilename
;save, shifts, filename=shiftsfilename


;+
;- 3.
;- APPLY shifts to z-th image in cube (negative offsets because offsets represent
;-    CUREENT offset from ref, e.g. first image has offset[0] = ~ -30, so must be shifted +30
;-    to align with ref.
;-
;- Started at
;-   19:14 Monday, 05 April
;- Again at
;-   00:28 Tuesday, 06 April
;- Finished in ~1 minute (no need to save?)

;-
;- !!!!!!  IMPORTANT  !!!!!
;-   ===>>   cube is MODIFIED here! Don't apply same shifts more than once!
print, ''
print, 'Started applying shifts to cube ', systime()
start_time = systime(/seconds)
;
for ii = 0, sz[2]-1 do begin
    offset = shifts[*,ii]
    cube[*,*,ii] = SHIFT_SUB( cube[*,*,ii], -offset[0], -offset[1] )
endfor
;
runtime = systime(/seconds) - start_time
print, 'Finished computation at ', systime()
print, 'Total runtime = ', runtime, ' seconds ( ', runtime/60., ' minutes)'
print, ''
;


alignedfilename = class + '_' + strlowcase(instr) + strtrim(channel,1) + 'aligned.sav'
print, alignedfilename
;
print, ''
if file_exist( alignedfilename ) then $
    print, '  ===>>  FILE EXISTS! Overwrite "' + alignedfilename + '"?'
print, ''

stop


;- Saved updated cube, plus LATEST shifts (don't have 3D "allshifts" here..)
save, cube, shifts, filename=alignedfilename


;===========================================================================-

;- [] interpolate MISSING 1700 images from ALIGNED cubes before computing power maps

channel=1700

;path =
;restore, ...  --> see top of this code.



end
