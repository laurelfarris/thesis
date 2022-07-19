;+
;-  MODIFIED:
;-
;-
;-  13 January 2021
;-    Generalized so variable "instr" can be set to "aia" OR "hmi"
;-      • Assigns delimiter to date ("-" or ".") depending on instr.
;-      • Loop iterations computed using REFORM(fls)... may not work if n_elem(fls)
;-           is not a nice even number like 800...
;-      • Does NOT use channel, reads ALL fits files at given instr and date.
;-           Read ALL filenames into fls (is just a string array, so no memory/speed problems),
;-           then run READ_SDO and AIA_PREP on small chunks of fls at a time,
;-           freeing memory by undefining old_data and data after each iteration.
;-      
;-
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
;
;
;    AIA
;      UNprepped fits (level 1.0):
;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;
;      PREPPED fits (level 1.5):
;        'AIA20131228_100000_1600.fits'
;        'AIA20131228_100000_0304.fits'
;
;
;    HMI
;      UNprepped (level 1.0):
;        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'
;
;      PREPPED fits (level 1.5)
;        'HMIyyyymmdd_hhmmss_cont.fits'
;        'HMIyyyymmdd_hhmmss_*?*.fits'
;        'HMIyyyymmdd_hhmmss_mag.fits'
;        'HMIyyyymmdd_hhmmss_dop.fits'
;
;
;---
;-


;==--

;- OLD:
;date = '2013-08-12'
;date = '2013-08-30'
;date = '2014-10-23'
;date = '2014-11-07'
;--


;- NEW (the better way):
;date = [ '2013', '08', '12' ]  ; ?
;date = [ '2013', '08', '30' ]  ; C8.3 
date = [ '2014', '04', '18' ]  ; M7.3
;date = [ '2014', '10', '23' ]  ; M1.?
;date = [ '2014', '11', '07' ]  ; M1.?
;date = [ '2011', '02', '15' ]  ; X2.2


;==--
;instr = 'aia'
;channel = '1600'
;channel = '1700'

instr = 'hmi'
;channel = 'B_LOS'
channel = 'mag'
;channel = 'cont'

;- Set path(s) to level 1.0 fits and where new, level 1.5 fits are to be saved.
@path_temp
;path_to_fits = '/solarstorm/laurel07/Data/AIA/'
path_to_fits = path + 'Data/' + strupcase(instr) + '/'
outdir = path + 'Data/' + strupcase(instr) + '_prepped/'

print, ''
print, 'Are these paths correct?:'
print, '  LVL 1.0 (input_dir)  = ', path_to_fits
print, '  LVL 1.5 (outdir)     = ', outdir
print, ''


if strlowcase(instr) eq 'aia' then delimiter = '-'
if strlowcase(instr) eq 'hmi' then delimiter = '.'

;delimiter = '.'
;Result = STRJOIN( String [, Delimiter], /SINGLE )
;print, STRJOIN( date, delimiter )
;print, STRJOIN( String, '-', /SINGLE )
;
;--


;-- §1.  Search for level 1.0 fits files

;        'aia.lev1.1600A_2013-12-28T10_00_00.00Z.image_lev1.fits'
;        'aia.lev1.304A_2013-12-28T10_00_00.00Z.image_lev1.fits'

;        'hmi.ic_45s.yyyy.mm.dd_hh_mm_ss_TAI.continuum.fits'
;        'hmi.m_720s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.m_45s.yyyy.mm.dd_hh_mm_ss_TAI.magnetogram.fits'
;        'hmi.v_45s.yyyy.mm.dd_hh_mm_ss_TAI.Dopplergram.fits'


;fls = FILE_SEARCH( path_to_fits + $
;  Old:
;    'aia.lev1.' + channel + 'A_' + date + 'T*Z.image_lev1.fits' )
;  Better:
;    strlowcase(instr) + '.lev1.' + channel + 'A_' + date + 'T*Z.image_lev1.fits' )



fnames = strlowcase(instr) + '*' + STRJOIN( date, delimiter ) + '*.fits'
print, path_to_fits + fnames
fls = FILE_SEARCH( path_to_fits + fnames )
help, fls



stop;------------------------------------------------------------------------------------------

;fls_temp_1 = fls[0:399]
;fls_temp_2 = fls[401:-2]
;help, fls_temp_1
;help, fls_temp_2
;
;fls_old = fls
;fls = [ fls_old[0:399], fls_old[401:-2] ]
;help, fls
;
;ind = [0,1,399,400,401,402,800,801]
;ind = [0,1,398,399,400,401,798,799]
;ind = [0,1,397,398,399,400,798,799]
;ind = [0,1,397,398,399,400,796,797]
;print, ind
;print, fls[ind]
;-
;-
;- ===>>>  CAUTION!!!!  <<<===
;-   Be careful running test code like this :  accidently cropped fls after moving on to
;-     the next flare... thought I was oging to have to re-download a few files.
;-    (13 January 2021)
;-

;stop;------------------------------------------------------------------------------------------


interval = 50
;
;print, n_elements(fls)
;print, n_elements(fls)-interval
;print, n_elements(fls)-interval-1
;print, n_elements(fls)/interval
;
;
;for ii = 0, n_elements(fls)/interval-1  do begin
;    ;print, ii*interval, ii*interval + interval - 1
;    ind = [ ii*interval : ii*interval + interval - 1 ]
;    help, fls[ind]
;endfor
;
fls2 = reform( fls, interval, n_elements(fls)/interval )
sz = size(fls2, /dimensions)
;
;for ii = 0, n_elements(fls)-1, 50 do begin
;for ii = 0, n_elements(fls)-45-1, 50 do begin
;for ii = 0, n_elements(fls)-interval, 50 do begin
;
;for ii = 0, interval-1 do begin
;    READ_SDO, fls2[ii,*], old_index, old_data, nodata=1
;    stop
;endfor
;



;READ_SDO, fls, old_index, old_data, nodata=1

for ii = 0, interval-1 do begin
    ;+
    ;- read lvl 1.0 fits
    READ_SDO, fls2[ii,*], old_index, old_data, nodata=0
    ;READ_SDO, fls[ii:ii+49], old_index, old_data, nodata=0
    ;-
    ;+
    ;- process with aia_prep.pro
    AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir
    ;+
    ;- free up some memory
    undefine, old_index
    undefine, index
endfor

;READ_SDO, fls, old_index, old_data, nodata=0
;AIA_PREP, old_index, old_data, index, data, /do_write_fits, outdir=outdir

stop;------------------------------------------------------------------------------------------



;- run READ_SDO on N files at a time ( N << 750 ... ) :
;-   b/c of memory issues

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
