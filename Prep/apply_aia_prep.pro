;+
;-  MODIFIED:
;-
;-  05 January 2021
;-
;- PURPOSE:
;-     1.  read level 1.0 data from file (/ss/laurel07/Data/[Inst]/whatever.fits)
;-     2.  Process with aia_prep, save new fits files to instr_prepped dir.
;-
;- INPUT:
;-   NONE -- ML code only
;-
;- USEAGE:
;-   uncomment variables INSTR and CHANNEL
;-
;- KEYWORDS:
;-
;- OUTPUT:
;-
;- TO DO:
;-   [] change so that all channels can be processed in one run
;-      (currently have to comment each channel one by one ... )
;-


;+
;- Naming convention of fits files for, e.g. AIA 1600\AA{}
;     UNprepped fits:
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;     PREPPED fits:
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;-


instr = 'aia'
;channel = '1600'
channel = '1700'

;- Set path(s) to level 1.0 fits and where new, level 1.5 fits are to be saved.
path_to_fits = '/solarstorm/laurel07/Data/AIA/'
outdir='/solarstorm/laurel07/Data/' + strupcase(instr) + '_prepped/'
;print, 'LVL 1.0 (input_dir)  = ', path_to_fits
;print, 'LVL 1.5 (outdir)     = ', outdir



;date = '2013-08-12'
;date = '2013-08-30'
;date = '2014-10-23'
date = '2014-11-07'


;-- §1.  Search for level 1.0 fits files

fls = FILE_SEARCH( path_to_fits + $
    'aia.lev1.' + channel + 'A_' + date + 'T*Z.image_lev1.fits' )
help, fls

;---
;- Check for files that have already been processed (if any):
;fls_prepped = file_search( outdir + $
    ;'AIA20130812_*' + $
    ;'AIA20130830_*' + $
    ;'AIA20141023_*' + $
    ;'AIA20141107_*' + $
    ; strtrim(channel,1) + '.fits' $
;)
;help, fls_prepped
;---


print, fls[0]
print, fls[-1]

stop;-----------------



;- Better way: run READ_SDO on N files at a time ( N << 750 ... ) :

;for ii = 0, n_elements(fls)-1, 50 do begin
for ii = 0, n_elements(fls)-45-1, 50 do begin
    ;
    READ_SDO, fls[ii:ii+49], old_index, old_data, nodata=0
    AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
    ;
    undefine, old_index
    undefine, old_data
    undefine, index
    undefine, data
endfor
;=== Need some error handling here!!
READ_SDO, fls[700:744], old_index, old_data, nodata=0
AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
undefine, old_index
undefine, old_data
undefine, index
undefine, data

;----------------------------------------------------------------------------





;print, systime()
;start_time = systime()
;-


;READ_SDO, fls[0:99], old_index, old_data
;AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
;;
;READ_SDO, fls[100:199], old_index, old_data
;AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
;;
;for ii = 200, n_elements(fls)-1, 50 do begin
;    ind = [ii:ii+49]
;    ;READ_SDO, fls[ind], old_index, old_data, nodata=0
;    ;help, old_index
;    ;help, old_data
;    ;AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
;    AIA_PREP, old_index[ind], old_data[*,*,ind], index, data, /do_write_fits, outdir=outdir
;    undefine, index
;    undefine, data
;endfor




;print, 'started READ_SDO  ==>>  ', start_time
;print, 'finished  ...     ==>>  ', systime()
;print, ''

;stop;-----------------


;-- §2.  Process level 1.0 fits with aia_prep.pro, write new fits for level 1.5


;print, ''
;print, systime()
;start_time = systime()
;-
;- ....
;-
;print, 'started READ_SDO  ==>>  ', start_time
;print, 'finished  ...     ==>>  ', systime()
;print, ''

end
