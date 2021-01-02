;+
;- 01 January 2021
;-
;-



;sample='60'


download_dir = 'AIA/'
instr = 'aia'
;wave = '1600'
wave = '1700'


;+
;- C8.3 2013-08-30 T~02:04:00
;tstart = '2013/08/30 00:00:00'
;tend   = '2013/08/30 05:00:00'
;-
;;- M1.0 2014-11-07 T~10:13:00
;tstart = '2014/11/07 08:15:00'
;tend   = '2014/11/07 13:15:00'
;;-
;;- M1.5 2013-08-12 T~10:21:00
;tstart = '2013/08/12 08:20:00'
;tend   = '2013/08/12 13:20:00'
;;-
;;- C4.6 2014-10-23 T~13:20:00
tstart = '2014/10/23 11:20:00'
tend   = '2014/10/23 16:20:00'
;-
;---


;+
;- Search for files

dat = vso_search( tstart, tend, instr=instr, sample=sample, wave=wave )

print, '--'
print, wave
print, tstart
print, '--'

stop


;+
;- Download data:

;dir='/solarstorm/laurel07/Data/AIA/'
;dir='/solarstorm/laurel07/Data/HMI/'
dir='/solarstorm/laurel07/Data/' + download_dir
;- Too easy to forget to set the right path when this line is this far
;-  down in the file (24 July 2019)
;
;
status = VSO_GET(dat, /force, out_dir=dir)

;statusHMIcont = VSO_GET(datHMIcont, /force, out_dir=dir)
;statusHMIlosB = VSO_GET(datHMIlosB, /force, out_dir=dir)
;statusHMIlosV = VSO_GET(datHMIlosV, /force, out_dir=dir)
;statusHMIvectorB=VSO_GET(datHMIvectorB,/force,out_dir=dir)

end
