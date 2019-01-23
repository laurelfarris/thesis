;; Concatenation of all journals. To be added onto, daily.


; IDL Version 8.0.1 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Mon Mar 30 09:34:39 2015
 
mreadfits, fls, index, data
; % Variable is undefined: FILES0.
print, "variable is undefined: FILES0...?"
;variable is undefined: FILES0...?

;;-------------------------------------------------------------------;;

; IDL Version 8.0.1 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Mon Apr  6 08:49:58 2015
 
result=vso_search('*.fits')
; % VSO::PARSE_DATERANGE: Error parsing start date
result=vso_search('2014-02-01 16:00','2014-02-01 22:00', inst='aia', wave=193, sample=60)
;Records Returned : SDAC_AIA : 0/0
;Records Returned : JSOC : 360/360
log=vso_get(result,out_dir='data'filenames=fnames, /rice)
; % Syntax error.
log=vso_get(result,out_dir='data',filenames=fnames, /rice)
; y
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;compress=rice;record=193_1170345643-1170345643
; % WRITE_DIR: Invalid or non-existent directory - data
;; This went on for 700+ lines... deleted.

log=vso_get(result,out_dir='data',filenames=fnames, /rice)
; y
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;compress=rice;record=193_1170345643-1170345643

;; This query and download appears to have been copied from lmsal.com:
;; Guide to SDO Data Analysis (06/25/15)

;;-------------------------------------------------------------------;;

; IDL Version 8.0.1 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Sat Apr 11 18:49:53 2015
 
print, pi
; % PRINT: Variable is undefined: PI.
print, !pi
;      3.14159
print, 60*60*24*365.25
;  7.62058e+06
print, 60*60*24*365
;   13184
print, 60.0*60.0*24.0*365.25
;  3.15576e+07

;;-------------------------------------------------------------------;;

; IDL Version 8.0.1 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Mon Apr 13 07:35:36 2015
 
read_sdo, fls, index, data, /use_shared_lib
; % Variable is undefined: FILES.
read_sdo, fls, index, data
; % Variable is undefined: FILES.
read_sdo, 'fls', index, data
; % FITS_OPEN:  ERROR: Invalid header, no SIMPLE keyword
; % Expression must be a structure in this context: FCB.
read_sdo, 'fls', index, data, /use_shared_lib
; % FITS_OPEN:  ERROR: Invalid header, no SIMPLE keyword
; % Expression must be a structure in this context: FCB.
read_sdo, fls, index, data
; % Variable is undefined: FILES.
help, fls
retall
help, fls
ls
; % Attempt to call undefined procedure/function: 'LS'.
$ls
fls = file_search('*.fits')
help, fls
read_sdo, fls, index, data
retall
read_sdo, fls[0:2], index, data
; --------------------------------------------
;| unmapping existing segment> MREADFITS_SHMD |
; --------------------------------------------
; % Syntax error.
; % Attempt to call undefined procedure/function: 'FITSHEAD2STRUCT'.
retall

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Thu Jun 11 12:45:14 2015
 
help, fls
data_cube
fls = file_search(*.fits)
; % Syntax error.
fls = file_search (*.fits)
; % Syntax error.
fls = file_search ('*.fits')
help, fls
x = [1,1]
help, x
read_sdo, fnames, index, data
; % Variable is undefined: FILES.
read_sdo, fls, index, data
; % Variable is undefined: FILES.
help, fls
fls = file_search ('*.fits')
help, fls
read_sdo, fls, index, data
retall
help, fls
read_sdo, fls, index, data
; --------------------------------------------
;| unmapping existing segment> MREADFITS_SHMJ |
; --------------------------------------------
help, index
help, data
help, fls
SAVE, file = 'read_fits.sav'

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Fri Jun 12 17:08:28 2015
 
fls = file_search('*.fits')
help, fls
read_sdo, fls, index, data
retall
read_sdo, fls[0:2], index, data
; --------------------------------------------
;| unmapping existing segment> MREADFITS_SHMC |
; --------------------------------------------
help, index
help, data
SAVE, /VARIABLES, FILENAME='read_fits.sav'
help, fls
print, index
print, index
print, data
help, data

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Tue Jun 16 16:32:10 2015
 
fls = file_search('aia*00*.fits')
help, fls
print, fls
;aia.lev1.193A_2014-02-01T21_00_30.84Z.image_lev1.fits
image = file_search('aia*00*.fits')
print, image
;aia.lev1.193A_2014-02-01T21_00_30.84Z.image_lev1.fits
image1 = file_search('aia*00*.fits')
print, image1
;aia.lev1.193A_2014-02-01T21_00_30.84Z.image_lev1.fits
graphic = IMAGE(image1)
; % Type conversion error: Unable to convert given STRING to Long64.
help, index
RESTORE, 'read_fits.sav'
help, index
print, index ;; deleted output 
help, index
help, data

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Wed Jun 17 13:20:39 2015
 
RESTORE, read_fits.sav
; % Expression must be a structure in this context: READ_FITS.
help, index
RESTORE, 'read_fits.sav'
help, index
help, data
print, data [0,0,0]
;       2
print, data [4095,4095,0]
;       0
print, data [409,500,0]
;      17
cube = data
help, cube
.compile align_cube3_copy
.compile align_cube3_copy
align_cube3_copy, cube
help, cube
print, cube [409,500,0]
;      18
print, data [409,500,0]
;      17
help, index
print, index[0]
OPENW, 1, 'header1.txt'
help, header
help, index ;; deleted output
PRINTF, index
; % PRINTF: Expression must be a scalar or 1 element array in this context: INDEX.
PRINTF, 1, index

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Fri Jun 19 14:29:26 2015
 
help, fls
RESTORE, 'read_fits.sav'
help, fls
help, data
help, index
read_sdo, fls[0:9], index, data
help, index
help, data
read_sdo, fls[10:19], index, data
read_sdo, fls[19:29], index, data
read_sdo, fls[29:39], index, data
read_sdo, fls[39:49], index, data
read_sdo, fls[49:59], index, data
; % Illegal subscript range: FLS.
help, fls
read_sdo, fls[49:58], index, data
read_sdo, fls[0:9], index, data
help, index
RESTORE, 'read_fits.sav'
help, index
help, fls
help, data
?
TVIM, data[*,*,0]
; % Attempt to call undefined procedure/function: 'TVIM'.
print, data[*,*,0]

;; read_sdo, fls[#:#], index, data
;; not working except for fls[0:9]. Everything else said:
;; " %FXPAR: WARNING: Value of KEYWDDOC invalid in FITS Header (no trailing') "

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Mon Jun 22 11:49:25 2015
 
help, index
RESTORE, 'read_fits.sav'
help, index
TVIM, index[*,*,0]
; % Attempt to call undefined procedure/function: 'TVIM'.
$vi test.pro
test
;This is a test.
$rm test.pro
$vi test.pro
test
;This is a test.
.compile test
test
;This is a test again!
help, fls
TVIM, fls[0]
; % Attempt to call undefined procedure/function: 'TVIM'.
TVIM
; % Attempt to call undefined procedure/function: 'TVIM'.
TVIM, dist(32), /scale, title='An Image', range = [10,20]
; % Attempt to call undefined procedure/function: 'TVIM'.
tv, 'puppy.jpg'
; % TV: Expression must be an array in this context: <STRING   ('puppy.jpg')>.
IMAGE('puppy.jpg')
;IMAGE <5135>
TVIM
; % Attempt to call undefined procedure/function: 'TVIM'.
PRINT
TVIM, 'aia.lev1.193A_2014-02-01T21_59_06.84Z.image_lev1.fits'
; % Attempt to call undefined procedure/function: 'TVIM'.
which
;WHICH -- Syntax error.
;   Usage: WHICH, 'filename' [,/ALL, file=file]
; 
print
plot
; % PLOT: Incorrect number of arguments.
?
WHICH, 'TVIM'
WHERE, 'tvim'
; % Attempt to call undefined procedure/function: 'WHERE'.
WHERE, 'TVIM'
; % Attempt to call undefined procedure/function: 'WHERE'.
WHICH, 'print'
;PRINT is an IDL built-in routine.
WHICH, 'TV'
;TV is an IDL built-in routine.
WHICH, 'TVIM'
$vi tvim.pro
tvim
; % Attempt to call undefined procedure/function: 'XHELP'.
help, tvim
help, print
which
;WHICH -- Syntax error.
;   Usage: WHICH, 'filename' [,/ALL, file=file]
; 
WHICH, 'TVIM'
FILE_WHICH('TVIM')
Result = FILE_WHICH('TVIM')
help, result
Result = FILE_WHICH('TVIM')
help, result
Result = FILE_WHICH('tvim.pro')
help, result
TVIM
; % Attempt to call undefined procedure/function: 'XHELP'.
help, index
RESTORE, 'read_fits.pro'
; % RESTORE: Error opening file. Unit: 101, File: read_fits.pro
;   No such file or directory
RESTORE, 'read_fits.sav'
help, index
help, data
TVIM, data[*,*,0]
$ pwd
$ vi which.pro
$ ls -l *.pro
$ chmod +x which.pro
$ ls -l *.pro
WHICH, TVIM
;WHICH -- Syntax error.
;   Usage: WHICH, 'filename' [,/ALL, file=file]
; 
WHICH, 'TVIM'
result = WHICH, 'TVIM'
; % Keyword RESULT not allowed in call to: PRINT
help, result
x = WHICH, 'TVIM'
; % Keyword X not allowed in call to: PRINT
retall
retall
x = WHICH, 'TVIM'
; % Keyword X not allowed in call to: PRINT
x = WHICH, 'tvim.pro'
; % Keyword X not allowed in call to: PRINT
WHICH, 'tvim.pro'
;/home/users/laurel07/research/tvim.pro
$ vi 'which.pro'
which, 'tvim.pro' ;; This is the correct way to do this.
                  ;; Need full filename, in quotes, and 
                  ;; tvim.pro in current directory (executable)

;/home/users/laurel07/research/tvim.pro
which, tvim
;WHICH -- Syntax error.
;   Usage: WHICH, 'filename' [,/ALL, file=file]
; 

;;-------------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Thu Jun 25 12:05:01 2015
 
$vi vsoget.pro
;; Picking through vsoget.pro line by line...
$ ls -l
help, vso_search
help, vso_search.pro
; % Syntax error.
help, 'vso_search.pro'
;; Also... journaling from terminal #1.
$vi vsoget.pro
;; Testing query/download on ~2 files:
result = VSO_SEARCH ('2015-01-01 1:00','2015-01-01 1:01',$
inst = 'aia',wave = 193,sample = 60)
; % Syntax error.
result = VSO_SEARCH ('2015-01-01 1:00','2015-01-01 1:01',$
PRO
; % Syntax error.
.RUN
result = VSO_SEARCH('2015-01-01 1:00','2015-01-01 1:01', inst='aia', $
; % Syntax error.
nd
end
; % 1 Compilation error(s) in module $MAIN$.
tstart = '2015-01-01 1:01'
tstart = '2015-01-01 1:00'
tend = '2015-01-01 1:01'
help, tstart & help, tend
result = VSO_SEARCH('2015-01-01 1:00','2015-01-01 1:01', instr='aia', $
; % Syntax error.
help, tstart & help, tend
help, tstart & help, tend
result = vso_search(tstart,tend,instr='aia',sample=60,wave='193')
; % Syntax error.
result = vso_search(tstart,tend,instr="aia",sample=60,wave='193')
; % Syntax error.
result = vso_search(tstart,tend,inst='aia',sample=60,wave='193')
; % Syntax error.
help, vso_search
?
compile vsoget
; % Syntax error.
.compile vsoget
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % 7 Compilation error(s) in module $MAIN$.
.compile vsoget
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % 7 Compilation error(s) in module $MAIN$.
;; Even original vsoget.pro is giving a syntax error.
retall
.compile vsoget
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % Syntax error.
; % 7 Compilation error(s) in module $MAIN$.
$vi journals/allJournals.pro
retall
.compile vsoget
; % Syntax error.
; % 1 Compilation error(s) in module $MAIN$.
result = vso_search(tstart,tend)
; % Variable is undefined: VSO_SEARCH.
;; Possibly need to recover vso_search?
result = vsosearch(tstart,tend)
; % Variable is undefined: VSOSEARCH.
;; Quitting to log out and log back in...


; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Thu Jun 25 16:27:15 2015
 
help, tstart
tstart = '2011/12/09 16:00:00'
tend = '2011/12/09 22:00:00'
help, tstart & help, tend
result=vso_search(tstart,tend,instr='aia',sample='60',wave='193')
;Records Returned : JSOC : 360/360
tstart = '2011/12/09 23:00:00'
tend = '2011/12/09 24:00:00'
result=vso_search(tstart,tend,instr='aia',sample=60,wave='193')
;Records Returned : JSOC : 60/60
help, result
;; Just needed a good old logout/logbackin.
;; Examining alignment routines now:
;; Will practice cutting out limb, creating new data cube,
;; aligning new cube, and checking average shifts to see
;; if the alignment is good enough.
help, index
help, result
print, result[0]
;{{ 2011-12-09T23:00:07 2011-12-09T23:00:08}{ FULLDISK      4096.00      4096.00
;      0.00000      0.00000}{      193.000      193.000 NARROW Angstrom}  AIA SDO JSOC
;AIA level 1, 4096x4096 [2.000 exposure] [100.00 percentd] intensity
;aia__lev1:193:1102546843      66200.0      1.99960           0           0
;      100.000  }
print, result.time
;{ 2011-12-09T23:00:07 2011-12-09T23:00:08}{ 2011-12-09T23:01:07 2011-12-09T23:01:08}{
;; Lots of these lines... removed all but the first one.
print, result[0].time
;{ 2011-12-09T23:00:07 2011-12-09T23:00:08}
$vi align_cube3.pro
help, alignoffset
$vi align_cube3.pro
;; Going through whole procedure with 3 images.
RESTORE, 'read_fits.sav'
help, fls
help, data
help, index
TVIM, data[*,*,0]
TVIM, data[500:3500,500:3500,0]
crop1=500 & crop2=3500
help, crop1 & help,crop2
TVIM, data[crop1:crop2,crop1:crop2,0]
crop1=750 & crop2=3250
TVIM, data[crop1:crop2,crop1:crop2,0]
crop1=800 & crop2=3000
TVIM, data[crop1:crop2,crop1:crop2,0]
crop1=900 & crop2=2900
TVIM, data[crop1:crop2,crop1:crop2,0]
help, data
randomarray[1] = 1
; % Variable is undefined: RANDOMARRAY.
result=data[crop1:crop2,crop1:crop2,0]
help, result
new_data=INTARR(2001,2001,3)
help, new_data
help, data
new_coo = result[0]
print, new_coo
;     558
print, n_elements(new_data[0])
;           1
print, new_data[0]
;       0
help, new_data
print, new_data[500,500,0]
;       0
print, crop1
;     900
x1 = crop1
x2=crop2
print, x1 & print, x2
;     900
;    2900
new_data[*,*,0]=data[x1:x2,x1:x2,0]
print, new_data[500,500,0]
;     529
print, data[500,500,0]
;      25
new_data[*,*,1]=data[x1:x2,x1:x2,1]
new_data[*,*,2]=data[x1:x2,x1:x2,2]
;; Tomorrow, run align_cube3.pro on new_data

;;----------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Fri Jun 26 11:25:13 2015
 
help, new_data
help, spawn
spawn, 'ls'
$ ls
restore, 'read_fits.sav'
help, index
help, data
$ cat read_fits.sav ;; Huge mess, don't ever do this :)
help, x1
x1 = 900
x2 = 2900
new_data=INTARR(2001,2001,3)
help, new_data
help, data
new_data[*,*,0]=data[x1:x2,x1:x2,0]
new_data[*,*,1]=data[x1:x2,x1:x2,1]
new_data[*,*,2]=data[x1:x2,x1:x2,2]
help
help, data
help, new_data
SAVE, /VARIABLES, FILENAME='read_fits.sav'
$vi align_cube3.pro
PRINT, N_ELEMENTS(index)
;           3
HELP, index
PRINT, N_ELEMENTS(data)
;    50331648
PRINT, N_ELEMENTS(data)/2
;    25165824
PRINT, N_ELEMENTS(index)/2
;           1
PRINT, N_ELEMENTS(index)/2.0
;      1.50000
mid=N_ELEMENTS(index)/2
print, mid
;           1
ref=REFORM(new_data[*,*,mid])
help, ref
SAVE, /VARIABLES, FILENAME='read_fits.sav'
$vi alignoffset.pro
.compile align_cube3.pro
.compile align_cube3.pro
align_cube3, new_data, ref
;       0
;    -0.181568   -0.0593163
help, new_data
help, data
RESTORE, 'read_fits.sav'
help, new_data
help, data
help, mid
$vi journals/2015_06_17.pro
print, x
; % PRINT: Variable is undefined: X.
print, x
; % PRINT: Variable is undefined: X.
x = 2
print, x
;       2
;; All I did was try to print some var called x.
;; What does align_cube3 have to do with it?
retall
print, y
; % PRINT: Variable is undefined: Y.
;; Maybe just needed a retall.
TVIM, new_data[*,*,0]
TVIM, data[*,*,0]
TVIM, new_data[*,*,0]
TVIM, data[*,*,0]
TVIM, new_data[*,*,0]
.compile align_cube3
help, new_data
help, cube
help, ref
align_cube3, new_data, ref
;       0
;       1
;       2
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
help, shifts
help, cube
.compile align_cube3
align_cube3, new_data, ref
;       0
;       1
;       2
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
$ls -l
$cat shifts.dat
$ mv shifts.dat shifts2.dat
$ls -l
align_cube3, new_data, ref
;       0
;       1
;       2
;   0.00560933   0.00426010
;     -0.00000     -0.00000
;  -0.00268456 -0.000862602
$ls -l
align_cube3, new_data, ref
;       0
;       1
;       2
;   0.00106035  0.000836344
;     -0.00000     -0.00000
; -0.000127980 -0.000184951
align_cube3, new_data, ref
;       0
;       1
;       2
; -0.000294302 -0.000219060
;     -0.00000     -0.00000
;  0.000584179   0.00102537
$ ls -l
RESTORE, 'read_fits.sav'
help, data
help, new_data
help, cube
new_data_aligned = new_data
SAVE, /VARIABLES, FILENAME='read_fits.sav'
.compile align_cube3
align_cube3, new_data_aligned, ref
;       0
;       1
;       2
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
print, new_data_aligned[300,300,0]
;     535
align_cube3, new_data_aligned, ref
;       0
;       1
;       2
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
print, new_data_aligned[300,300,0]
;     535
align_cube3, new_data_aligned, ref
;       0
;       1
;       2
;   0.00560933   0.00426010
;     -0.00000     -0.00000
;  -0.00268456 -0.000862602
print, new_data_aligned[300,300,0]
;     535
cube=new_data
align_cube3, cube, ref
;       0
;       1
;       2
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
print, cube[300,300,0]
;     535
align_cube3, cube, ref
;       0
;       1
;       2
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
print, cube[300,300,0]
;     535

;;----------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Mon Jun 29 20:33:58 2015
 
help
RESTORE, 'read_fits.sav'
help  ;; Possible way to display all current variables, 
      ;; along with a bunch of other crap.

;;----------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Tue Jun 30 13:24:02 2015
 
$ls -l
RESTORE, 'read_fits.sav'
help
help, new_data
help, new_data_aligned
help, shifts
?
   
.compile align_cube3.pro
cube=new_data
help, cube
help, ref
help, shifts
align_cube3, cube, ref, shifts
;       0
;       1
;       2
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
print, shifts
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
align_cube3, cube, ref, shifts
;       0
;       1
;       2
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
print, shifts
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
help, shifts
shifts_avg = FLTARR(2)
print, shifts_avg
;      0.00000      0.00000
print, shifts_avg[0,0]
;      0.00000
print, shifts_avg[1,0]
;      0.00000
print, shifts_avg[1,1]
; % Attempt to subscript SHIFTS_AVG with <INT      (       1)> is out of range.
PRINT, TOTAL(shifts[0,*])
;    0.0112101
print, 0.0275425 - 0.0163324
;    0.0112101
PRINT, MEAN( ABS( shifts[0,*] ) )
;    0.0146249
print, (0.0275425 + 0.0163324) / 2.0
;    0.0219374
print, shifts[0,*]
;    0.0275425
;     -0.00000
;   -0.0163324
print, (0.0275425 + 0.0163324) / 3.0
;    0.0146250
;; Calculated mean off by 0.0000001 from IDL mean.
.compile align_cube3.pro
align_cube3, cube, ref
;Shifts:  
;   0.00560933   0.00426010
;     -0.00000     -0.00000
;  -0.00268456 -0.000862602
;Average: 
;   0.00276463
print, (0.00560933+0.00268456)/3.0 
;   0.00276463
.compile align_cube3.pro
retall
.compile align_cube3.pro
RESTORE, 'read_fits.sav'
align_cube3, cube, ref
;Shifts:  
;   0.00106035  0.000836344
;     -0.00000     -0.00000
; -0.000127980 -0.000184951
;Average: 
;  0.000396109
;  0.000340432
PRINT, SIZE(shifts)
;           2           2           3           4           6
print, shifts
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
print, size(cube)
;           3        2001        2001           3           2    12012003
.compile align_cube3.pro
RESTORE, 'read_fits.sav'
align_cube3, cube, ref
;Shifts:  
; -0.000294302 -0.000219060
;     -0.00000     -0.00000
;  0.000584179   0.00102537
;Average: 
;  0.000292827
;  0.000414812
print, (0.000294302+0.000584179)/2.0
;  0.000439241
.compile align_cube3.pro
; % Syntax error.
; % End of file encountered before end of program.
; % 2 Compilation error(s) in module ALIGN_CUBE3.
.compile align_cube3.pro
RESTORE, 'read_fits.sav'
align_cube3, cube, ref
;Shifts:  
;  0.000829126
;     -0.00000
; -0.000236192
;Average: 
;  0.000355106
print, shifts[0,0] & print, shifts[0,1] & print, shifts[0,2]
;    0.0275425
;     -0.00000
;   -0.0163324
print, shifts[1,0] & print, shifts[1,1] & print, shifts[1,2]
;    0.0187512
;     -0.00000
;   0.00116039
RESTORE, 'read_fits.sav'
print, shifts
;    0.0275425    0.0187512
;     -0.00000     -0.00000
;   -0.0163324   0.00116039
.RESET_SESSION
;; Bunch of stuff deleted, same as sswidl startup
help, shifts
RESTORE, 'read_fits.sav'
help, shifts
help, cube
help, cube
help, new_data
cube = new_data
.compile align_cube3.pro
align_cube3.pro, cube, ref
; % Syntax error.
help, cube
align_cube3, cube, ref
;Shifts:  
;     0.181568
;  3.07222e-06
;    -0.133757
;Average: 
;     0.105109
align_cube3.pro, cube, ref
; % Syntax error.
align_cube3, cube, ref
;Shifts:  
;    0.0275425
;     -0.00000
;   -0.0163324
;Average: 
;    0.0146249

;;----------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Wed Jul  1 14:58:27 2015
 
RESTORE, 'read_fits.sav'
help, cube
help, new_data
cube = new_data
SAVE, /VARIABLES, FILENAME = 'read_fits.sav'
help, new_data
help, cube
.compile align_cube3.pro
align_cube3, cube, ref
;Shifts:  
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
;Average: 
;     0.105109
;    0.0446360
print, (0.181568+(3.07222e-06)-0.133757)/3.0
;    0.0159380
print, (0.181568+(3.07222e-06)+0.133757)/3.0
;     0.105109
print, (0.0593163 + 0.0745919)/3.0
;    0.0446361
print, size(shifts)
;           0           0           0
print, shifts
; % PRINT: Variable is undefined: SHIFTS.
help, shifts
help, cube
help, new_data
;; shifts still needs to be entered when program
;; is run, or value will not be in ML.
RESTORE, 'read_fits.sav'
help, new_data
help, shifts
.compile align_cube3.pro
align_cube3, cube, ref, shifts
;       0
;       1
;       2
;Shifts:  
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
;x average: 
;     0.105109
;y average: 
;    0.0446360
print, size(shifts)
;           2           2           3           4           6
help, new_data
.compile align_cube3.pro
RESTORE, 'read_fits.sav'
help, shifts
align_cube3, cube, ref, shifts
;       0
;       1
;       2
;Shifts:  
;     0.181568    0.0593163
;  3.07222e-06     -0.00000
;    -0.133757    0.0745919
;x average: 
;     0.157664
;y average: 
;    0.0669541
print,  0.0593163
;    0.0593163
print, (0.0593163 + 0.0745919)/2.0
;    0.0669541
;; Working now... lovely.
$ ls data
.run vsoget  ;; Just a search... 'STOP' before VSO_GET routine
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
help, dat94
help, dat193
dir='/home/users/laurel07/research/data'
help, dir
status193=VSO_GET(dat193,/force,out_dir=dir)
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=193_1072990867-1072990867
;% HTTP::GET: 33572160 bytes of aia.lev1.193A_2011-01-01T21_00_31.84Z.image_lev1.fits copied in 17.33 seconds.
;% HTTP::GET: 33572160 bytes of aia.lev1.193A_2011-01-01T21_59_55.84Z.image_lev1.fits copied in 17.35 seconds.
;; etc... deleted most lines.

;; 9:07 pm... downloading complete.
;; (no idea what time it actually stopped.)

;;----------------------------------------------------------------;;

; IDL Version 8.3 (linux x86_64 m64)
; Journal File for laurel07@acrux.nmsu.edu
; Working directory: /home/users/laurel07/research
; Date: Thu Jul  2 10:03:03 2015
 
$ls -l
$ls -l *.sav
help, dat193
.compile vsoget.pro
vsoget
; % Attempt to call undefined procedure/function: 'VSOGET'.
.run vsoget
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 297/297
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 298/298
;Records Returned : JSOC : 0/0
help, dat335
SAVE, /VARIABLES, FILENAME = 'search_data.sav'
$ ls -l
ls test
; % Syntax error.
$ls test
dir = '/home/users/laurel07/research/test'
.compile vsoget
vsoget
; % Attempt to call undefined procedure/function: 'VSOGET'.
.run vsoget
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990874-1072990874
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_00_38.12Z.image_lev1.fits copied in 19.19 seconds.
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990886-1072990886
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_00_50.13Z.image_lev1.fits copied in 23.44 seconds.
;3 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990898-1072990898
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_01_02.12Z.image_lev1.fits copied in 16.24 seconds.
;4 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990910-1072990910
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_01_14.12Z.image_lev1.fits copied in 17.95 seconds.
;5 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990922-1072990922
;% HTTP::STATUS: URL not accessible. Status code = 500
;6 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990934-1072990934
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_01_38.12Z.image_lev1.fits copied in 17.20 seconds.
;7 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990946-1072990946
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_01_50.12Z.image_lev1.fits copied in 17.20 seconds.
;8 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990958-1072990958
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_02_02.12Z.image_lev1.fits copied in 17.24 seconds.
;9 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990970-1072990970
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_02_14.12Z.image_lev1.fits copied in 17.29 seconds.
;10 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990982-1072990982
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_02_26.12Z.image_lev1.fits copied in 23.57 seconds.
;11 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072990994-1072990994
;% HTTP::STATUS: URL not accessible. Status code = 500
;12 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991006-1072991006
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_02_50.12Z.image_lev1.fits copied in 27.49 seconds.
;13 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991018-1072991018
;% HTTP::STATUS: URL not accessible. Status code = 500
;14 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991030-1072991030
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_03_14.12Z.image_lev1.fits copied in 21.93 seconds.
;15 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991042-1072991042
;% HTTP::STATUS: URL not accessible. Status code = 500
;16 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991054-1072991054
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_03_38.12Z.image_lev1.fits copied in 24.42 seconds.
;17 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991066-1072991066
;% HTTP::STATUS: URL not accessible. Status code = 500
;18 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991078-1072991078
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_04_02.12Z.image_lev1.fits copied in 17.23 seconds.
;19 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991090-1072991090
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_04_14.12Z.image_lev1.fits copied in 17.08 seconds.
;20 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991102-1072991102
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_04_26.12Z.image_lev1.fits copied in 20.62 seconds.
;21 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991114-1072991114
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_04_38.12Z.image_lev1.fits copied in 17.28 seconds.
;22 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991126-1072991126
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_04_50.12Z.image_lev1.fits copied in 23.42 seconds.
;23 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991138-1072991138
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_05_02.12Z.image_lev1.fits copied in 13.99 seconds.
;24 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991150-1072991150
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-01-01T21_05_14.12Z.image_lev1.fits copied in 16.01 seconds.
;25 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1072991162-1072991162
.compile vsoget.pro
; % You compiled a main program while inside a procedure.  Returning.
.run vsoget
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
$ cd test
$pwd
help, dat94
help, dat131
help, dat171
help, dat193
help, dat211
help, dat304
help, dat335
print, dat94
;{{ 2011-02-01T21:00:38 2011-02-01T21:00:39}{ FULLDISK      4096.00      4096.00
;      0.00000      0.00000}{      94.0000      94.0000 NARROW Angstrom}  AIA SDO JSOC
;AIA level 1, 4096x4096 [2.901 exposure] [100.00 percentd] intensity
;aia__lev1:94:1075669274      66200.0      2.90099           0           0
;      100.000  }{{ 2011-02-01T21:00:50 2011-02-01T21:00:51}{ FULLDISK      4096.00
;      4096.00      0.00000      0.00000}{      94.0000      94.0000 NARROW Angstrom} 
;AIA SDO JSOC AIA level 1, 4096x4096 [2.901 exposure] [100.00 percentd] intensity
;aia__lev1:94:1075669286      66200.0      2.90099           0           0
;      100.000  }
print, dat94.exposure
; % Tag name EXPOSURE is undefined for structure VSORECORD.
print, dat94.time
;{ 2011-02-01T21:00:38 2011-02-01T21:00:39}{ 2011-02-01T21:00:50 2011-02-01T21:00:51}
print, dat94[0].time
;{ 2011-02-01T21:00:38 2011-02-01T21:00:39}
print, dat94[1].time
;{ 2011-02-01T21:00:50 2011-02-01T21:00:51}
print, dat193[0]
;{{ 2011-02-01T21:00:31 2011-02-01T21:00:32}{ FULLDISK      4096.00      4096.00
;      0.00000      0.00000}{      193.000      193.000 NARROW Angstrom}  AIA SDO JSOC
;AIA level 1, 4096x4096 [2.000 exposure] [100.00 percentd] intensity
;aia__lev1:193:1075669267      66200.0      1.99967           0           0
;      100.000  }
SAVE, /VARIABLES, FILENAME = 'search_testdata.sav'
$ ls -l *.sav
help
.RESET_SESSION
;Executing SSW IDL_STARTUP for: GEN
;Executing SSW IDL_STARTUP for: SXT
;Including Paths:
; -----------------------------------
;| $SSW/yohkoh/gen/galileo/idl/lmsal |
; -----------------------------------
;Executing SSW IDL_STARTUP for: MDI
;Executing SSW IDL_STARTUP for: EIT
;executing EIT IDL_STARTUP
;Executing SSW IDL_STARTUP for: CDS
;Executing SSW IDL_STARTUP for: LASCO
;Including Paths:
; -----------------------------------------------
;| $SSW/packages/nrl/idl/nrlgen/lascoeit         |
;| $SSW/packages/nrl/idl/nrlgen/aia              |
;| $SSW/packages/nrl/idl/nrlgen/widgets          |
;| $SSW/packages/nrl/idl/nrlgen/dfanning         |
;| $SSW/packages/nrl/idl/nrlgen/util/discri_pobj |
;| $SSW/packages/nrl/idl/nrlgen/util             |
;| $SSW/packages/nrl/idl/nrlgen/display/diva     |
;| $SSW/packages/nrl/idl/nrlgen/display          |
;| $SSW/packages/nrl/idl/nrlgen/analysis         |
;| $SSW/packages/nrl/idl/nrlgen/time             |
; -----------------------------------------------
;Executing SSW IDL_STARTUP for: TRACE
;Executing SSW IDL_STARTUP for: XRT
;Including Paths:
; ------------------------------
;| $SSW/hinode/gen/idl/pointing |
;| $SSW/trace/idl/site          |
;| $SSW/trace/idl/ops           |
;| $SSW/trace/idl/wwwidl        |
;| $SSW/trace/idl/util          |
;| $SSW/trace/idl/egse          |
;| $SSW/trace/idl/info          |
; ------------------------------
;Executing SSW IDL_STARTUP for: EIS
;Executing SSW IDL_STARTUP for: AIA
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: EVE
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: HMI
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: SITE
;Including Paths:
; ---------------------------------
;| $SSW/yohkoh/ucon/idl/acton      |
;| $SSW/yohkoh/ucon/idl/bentley    |
;| $SSW/yohkoh/ucon/idl/freeland   |
;| $SSW/yohkoh/ucon/idl/hudson     |
;| $SSW/yohkoh/ucon/idl/labonte    |
;| $SSW/yohkoh/ucon/idl/lemen      |
;| $SSW/yohkoh/ucon/idl/linford    |
;| $SSW/yohkoh/ucon/idl/mcallister |
;| $SSW/yohkoh/ucon/idl/sato       |
;| $SSW/yohkoh/ucon/idl/mctiernan  |
;| $SSW/yohkoh/ucon/idl/metcalf    |
;| $SSW/yohkoh/ucon/idl/morrison   |
;| $SSW/yohkoh/ucon/idl/sakao      |
;| $SSW/yohkoh/ucon/idl/schwartz   |
;| $SSW/yohkoh/ucon/idl/slater     |
;| $SSW/yohkoh/ucon/idl/wuelser    |
;| $SSW/yohkoh/ucon/idl/zarro      |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/trace/ssw_contributed |
; ----------------------------
;Executing SSW IDL_STARTUP: (Personal)
;startup
.compile vsoget.pro
.run vsoget
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
help
.RESET_SESSION
;Executing SSW IDL_STARTUP for: GEN
;Executing SSW IDL_STARTUP for: SXT
;Including Paths:
; -----------------------------------
;| $SSW/yohkoh/gen/galileo/idl/lmsal |
; -----------------------------------
;Executing SSW IDL_STARTUP for: MDI
;Executing SSW IDL_STARTUP for: EIT
;executing EIT IDL_STARTUP
;Executing SSW IDL_STARTUP for: CDS
;Executing SSW IDL_STARTUP for: LASCO
;Including Paths:
; -----------------------------------------------
;| $SSW/packages/nrl/idl/nrlgen/lascoeit         |
;| $SSW/packages/nrl/idl/nrlgen/aia              |
;| $SSW/packages/nrl/idl/nrlgen/widgets          |
;| $SSW/packages/nrl/idl/nrlgen/dfanning         |
;| $SSW/packages/nrl/idl/nrlgen/util/discri_pobj |
;| $SSW/packages/nrl/idl/nrlgen/util             |
;| $SSW/packages/nrl/idl/nrlgen/display/diva     |
;| $SSW/packages/nrl/idl/nrlgen/display          |
;| $SSW/packages/nrl/idl/nrlgen/analysis         |
;| $SSW/packages/nrl/idl/nrlgen/time             |
; -----------------------------------------------
;Executing SSW IDL_STARTUP for: TRACE
;Executing SSW IDL_STARTUP for: XRT
;Including Paths:
; ------------------------------
;| $SSW/hinode/gen/idl/pointing |
;| $SSW/trace/idl/site          |
;| $SSW/trace/idl/ops           |
;| $SSW/trace/idl/wwwidl        |
;| $SSW/trace/idl/util          |
;| $SSW/trace/idl/egse          |
;| $SSW/trace/idl/info          |
; ------------------------------
;Executing SSW IDL_STARTUP for: EIS
;Executing SSW IDL_STARTUP for: AIA
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: EVE
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: HMI
;Including Paths:
; ---------------------------------
;| $SSW/vobs/gen/idl               |
;| $SSW/vobs/ontology/idl/jsoc     |
;| $SSW/vobs/ontology/idl/gen_temp |
;| $SSW/vobs/ontology/idl          |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/sdo/gen/idl/attitude  |
;| $SSW/sdo/gen/idl/utilities |
; ----------------------------
;Executing SSW IDL_STARTUP for: SITE
;Including Paths:
; ---------------------------------
;| $SSW/yohkoh/ucon/idl/acton      |
;| $SSW/yohkoh/ucon/idl/bentley    |
;| $SSW/yohkoh/ucon/idl/freeland   |
;| $SSW/yohkoh/ucon/idl/hudson     |
;| $SSW/yohkoh/ucon/idl/labonte    |
;| $SSW/yohkoh/ucon/idl/lemen      |
;| $SSW/yohkoh/ucon/idl/linford    |
;| $SSW/yohkoh/ucon/idl/mcallister |
;| $SSW/yohkoh/ucon/idl/sato       |
;| $SSW/yohkoh/ucon/idl/mctiernan  |
;| $SSW/yohkoh/ucon/idl/metcalf    |
;| $SSW/yohkoh/ucon/idl/morrison   |
;| $SSW/yohkoh/ucon/idl/sakao      |
;| $SSW/yohkoh/ucon/idl/schwartz   |
;| $SSW/yohkoh/ucon/idl/slater     |
;| $SSW/yohkoh/ucon/idl/wuelser    |
;| $SSW/yohkoh/ucon/idl/zarro      |
; ---------------------------------
;Including Paths:
; ----------------------------
;| $SSW/trace/ssw_contributed |
; ----------------------------
;Executing SSW IDL_STARTUP: (Personal)
;startup
help
.run vsoget
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 2/2
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
;Records Returned : JSOC : 3/3
;Records Returned : JSOC : 0/0
help
SAVE, /VARIABLES, FILENAME = 'search_testdata.sav'
dir = '/home/users/laurel07/research/test'
.compile vsogettest.pro
.run vsogettest
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1075669274-1075669274
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-02-01T21_00_38.12Z.image_lev1.fits copied in 20.86 seconds.
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=94_1075669286-1075669286
;% HTTP::GET: 33572160 bytes of aia.lev1.94A_2011-02-01T21_00_50.12Z.image_lev1.fits copied in 25.57 seconds.
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=131_1075669269-1075669269
;% HTTP::STATUS: URL not accessible. Status code = 500
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=131_1075669281-1075669281
;% HTTP::GET: 33572160 bytes of aia.lev1.131A_2011-02-01T21_00_45.62Z.image_lev1.fits copied in 15.73 seconds.
;3 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=131_1075669293-1075669293
;% HTTP::GET: 33572160 bytes of aia.lev1.131A_2011-02-01T21_00_57.62Z.image_lev1.fits copied in 17.33 seconds.
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=171_1075669271-1075669271
;% HTTP::GET: Identical local file /home/users/laurel07/research/test/aia.lev1.171A_2011-02-01T21_00_36.34Z.image_lev1.fits already exists (not downloaded). Use /clobber to re-download.
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=171_1075669283-1075669283
;% HTTP::GET: 33572160 bytes of aia.lev1.171A_2011-02-01T21_00_48.34Z.image_lev1.fits copied in 17.35 seconds.
;1 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=193_1075669267-1075669267
;% HTTP::GET: Identical local file /home/users/laurel07/research/test/aia.lev1.193A_2011-02-01T21_00_31.84Z.image_lev1.fits already exists (not downloaded). Use /clobber to re-download.
;2 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=193_1075669279-1075669279
;% HTTP::GET: 33572160 bytes of aia.lev1.193A_2011-02-01T21_00_43.84Z.image_lev1.fits copied in 14.24 seconds.
;3 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=193_1075669291-1075669291
;% HTTP::GET: 33572160 bytes of aia.lev1.193A_2011-02-01T21_00_55.84Z.image_lev1.fits copied in 9.65 seconds.
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=211_1075669272-1075669272
;% HTTP::GET: 33572160 bytes of aia.lev1.211A_2011-02-01T21_00_36.63Z.image_lev1.fits copied in 16.97 seconds.
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=211_1075669284-1075669284
;% HTTP::GET: 33572160 bytes of aia.lev1.211A_2011-02-01T21_00_48.62Z.image_lev1.fits copied in 29.85 seconds.
;1 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=304_1075669268-1075669268
;% HTTP::GET: 33572160 bytes of aia.lev1.304A_2011-02-01T21_00_32.12Z.image_lev1.fits copied in 25.51 seconds.
;2 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=304_1075669280-1075669280
;% HTTP::GET: 33572160 bytes of aia.lev1.304A_2011-02-01T21_00_44.13Z.image_lev1.fits copied in 9.85 seconds.
;3 : http://sao.virtualsolar.org/cgi-bin/VSO/drms_export.cgi?series=aia__lev1;record=304_1075669292-1075669292
;% HTTP::GET: 33572160 bytes of aia.lev1.304A_2011-02-01T21_00_56.12Z.image_lev1.fits copied in 14.51 seconds.
;1 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=335_1075669263-1075669263
;% HTTP::GET: 33572160 bytes of aia.lev1.335A_2011-02-01T21_00_27.62Z.image_lev1.fits copied in 17.36 seconds.
;2 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=335_1075669275-1075669275
;% HTTP::GET: 33572160 bytes of aia.lev1.335A_2011-02-01T21_00_39.63Z.image_lev1.fits copied in 18.25 seconds.
;3 : http://sdo4.nascom.nasa.gov/cgi-bin/drms_export.cgi?series=aia__lev1;record=335_1075669287-1075669287
;% HTTP::GET: 33572160 bytes of aia.lev1.335A_2011-02-01T21_00_51.62Z.image_lev1.fits copied in 15.99 seconds.
.compile vsoget.pro
.run vsoget
;Records Returned : JSOC : 5/5
;Records Returned : SDAC_AIA : 0/0
;Records Returned : SDAC_AIA : 0/0
;Records Returned : JSOC : 5/5
;Records Returned : JSOC : 5/5
;Records Returned : SDAC_AIA : 0/0
;Records Returned : SDAC_AIA : 0/0
;Records Returned : JSOC : 5/5
;Records Returned : SDAC_AIA : 0/0
;Records Returned : JSOC : 5/5
;Records Returned : JSOC : 5/5
;Records Returned : SDAC_AIA : 0/0
;Records Returned : JSOC : 5/5
;Records Returned : SDAC_AIA : 0/0
fls = FILE_SEARCH('data/*2011*.fits')
help, fls
PRINT, fls[0]
;data/aia.lev1.193A_2011-01-01T21_00_31.84Z.image_lev1.fits
print, FILE_SEARCH('*2011*.fits')
print, FILE_SEARCH('data/*2011*.fits')
;data/aia.lev1.193A_2011-01-01T21_00_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_00_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_00_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_01_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_01_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_01_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_01_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_02_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_02_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_02_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_02_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_03_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_03_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_03_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_04_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_04_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_04_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_04_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_05_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_05_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_05_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_06_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_06_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_06_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_07_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_07_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_07_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_07_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_08_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_08_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_08_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_08_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_08_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_09_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_09_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_09_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_10_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_10_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_10_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_10_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_11_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_11_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_11_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_11_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_12_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_12_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_12_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_12_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_12_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_13_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_13_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_13_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_13_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_14_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_14_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_14_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_14_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_14_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_15_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_15_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_15_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_16_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_16_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_16_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_16_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_17_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_17_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_17_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_17_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_18_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_18_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_18_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_18_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_19_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_19_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_19_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_19_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_19_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_20_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_20_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_20_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_20_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_20_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_21_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_21_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_21_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_21_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_21_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_22_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_22_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_22_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_22_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_23_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_23_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_23_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_23_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_23_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_24_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_24_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_24_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_25_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_25_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_25_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_25_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_26_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_26_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_26_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_27_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_27_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_27_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_27_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_28_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_28_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_28_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_28_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_29_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_29_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_29_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_29_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_29_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_30_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_30_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_30_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_31_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_31_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_31_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_31_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_32_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_32_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_32_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_32_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_33_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_33_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_33_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_33_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_33_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_34_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_34_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_34_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_34_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_34_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_35_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_35_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_35_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_35_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_35_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_36_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_36_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_36_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_36_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_37_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_37_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_37_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_37_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_37_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_38_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_38_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_38_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_39_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_39_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_39_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_39_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_40_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_40_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_40_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_40_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_40_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_41_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_41_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_41_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_41_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_41_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_42_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_42_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_42_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_43_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_43_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_43_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_43_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_43_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_44_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_44_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_44_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_44_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_45_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_45_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_45_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_45_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_46_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_46_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_46_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_46_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_46_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_47_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_47_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_47_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_48_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_48_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_48_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_48_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_49_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_49_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_49_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_50_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_50_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_50_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_50_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_50_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_51_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_51_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_51_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_52_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_52_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_52_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_52_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_53_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_53_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_53_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_53_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_54_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_54_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_54_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_55_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_55_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_55_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_55_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_56_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_56_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_56_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_56_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_57_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_57_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_57_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_57_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_57_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_58_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_58_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_58_55.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_59_07.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_59_19.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_59_31.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_59_43.84Z.image_lev1.fits
;data/aia.lev1.193A_2011-01-01T21_59_55.84Z.image_lev1.fits
$clear
help, fls
READ_SDO, fls, index, data
; ------------------------------
;| avoiding 4GB byteorder limit |
; ------------------------------
help, index
help, data
SAVE, /VARIALBES, FILENAME = 'read_fits.sav'
; % Keyword VARIALBES not allowed in call to: SAVE
SAVE, /VARIABLES, FILENAME = 'read_fits.sav'
$PWD
help, fls
help, dat191
print, fls[0]
;data/aia.lev1.193A_2011-01-01T21_00_31.84Z.image_lev1.fits
help, dat193
help
$ ls -l
rm read_fits.sav
; % Syntax error.
help, fls
help, data
help, index
SAVE, fls,data,index, FILENAME = 'read_fits.sav'
help, data
help, index
x = 2
SAVE, x, FILENAME='test.sav'
SAVE, fls, FILENAME='fls.sav'
PRINT, SIZE(index)
;           1         243           8         243
PRINT, SIZE(data)
;                     3                  4096                  4096
;                   243                     2            4076863488
SAVE, index, FILENAME='index.sav'
SAVE, data[0], FILENAME='data_0.sav'
; % SAVE: Expression must be named variable in this context: <INT      (      -1)>.
help, data[0]
SAVE, data[*,*,0], FILENAME='data_0.sav'
; % SAVE: Expression must be named variable in this context: <INT       Array[4096,
;          4096]>.
A=data[*,*,0]
help, A
SAVE, A, FILENAME='data_0.sav'
help, data

;;----------------------------------------------------------------;;

