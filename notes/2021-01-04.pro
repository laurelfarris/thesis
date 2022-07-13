;+
;- 01 January 2021


;+
;- C8.3 2013-08-30 T~02:04:00
;tstart = '2013/08/30 00:00:00'
;tend   = '2013/08/30 04:59:59'
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
;tstart = '2014/10/23 11:20:00'
;tend   = '2014/10/23 16:20:00'
;-
;---


;---
;- AIA
;download_dir = 'AIA/'
;instr = 'aia'
;wave = '1600'
;wave = '1700'
;-

;---
;- HMI
download_dir = 'HMI/'
instr = 'hmi'
;physobs = 'intensity'
physobs = 'LOS_magnetic_field'
;physobs = 'VECTOR_MAGNETIC_FIELD'
;-


;+
;- Search for files

;datAIA = VSO_SEARCH( tstart, tend, instr=instr, sample=sample, wave=wave )
datHMI = VSO_SEARCH( tstart, tend, instr=instr, physobs=physobs )

print, '---------------------'
print, datHMI[0].physobs
print, datHMI[0].time.start
;print, datHMI[0].time._end
print, '---------------------'


stop;-----------------


;+
;- Download data:

dir='/solarstorm/laurel07/Data/' + download_dir

;statusAIA = VSO_GET(datAIA, /force, out_dir=dir)
statusHMI = VSO_GET(datHMI, /force, out_dir=dir)


end
