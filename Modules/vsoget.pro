;- Last modified:
;-   24 July 2019 -- cleaned up this code. See E-note "vsoget" for previous mess.
;-
;- AIA: cycle through each of the EUV wavelengths and get images at intervals
;-   set by 'sample' keyword (e.g. sample='60' gets images at 1 minute intervals)
;- (aka t-separation between observations when cadence is just too damn good).
;- HMI: cycle through each of the four types of data products
;-   --> set kw "physobs" (in place of "wave" for AIA - see examples below).
;-
;+

;sample='60'


DLpath = 'AIA/'
instr = 'aia'
wave = '1600'
;wave = '1700'





;+
;- 14 December 2020
;-
;- C8.3 2013-08-30 T~02:04:00
;tstart = '2013/08/30 00:00:00'
;tend   = '2013/08/30 05:00:00'
;----
;-
;- Missing data (03 January 2021)
;-
;- 1600
;tstart = '2013/08/30 00:00:16'
;tend   = '2013/08/30 00:03:28'
;tstart = '2013/08/30 03:57:00'
;tend   = '2013/08/30 05:00:00'
;-
;- 1700
;tstart = '2013/08/30 00:00:00'
;tend   = '2013/08/30 00:02:30'
tstart = '2013/08/30 03:46:00'
tend   = '2013/08/30 05:00:00'
;-
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


;+
;- Search for files

dat = VSO_SEARCH( tstart, tend, instr=instr, sample=sample, wave=wave )


;-----
;DLpath = 'HMI/'
;datHMIcont = VSO_SEARCH(tstart, tend, instr='hmi', physobs='intensity')
;datHMIlosB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_magnetic_field') 
;datHMIvectorB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='VECTOR_MAGNETIC_FIELD') 
;-----

stop


;+
;- Download data:
;-   This will take a long time and uninterupted internet connect.
;-   Can run while ssh'd using the 'screen' command.

;-   keyword /NODOWNLOAD will get header info only (no data).
;-   Shouldn't redownload data that's already stored in the local directory.
;-     (though parsing through these can still take a lot of time, even without
;-       downloading anything)


;dir='/solarstorm/laurel07/Data/AIA/'
;dir='/solarstorm/laurel07/Data/HMI/'
dir='/solarstorm/laurel07/Data/' + DLpath
;- Too easy to forget to set the right path when this line is this far
;-  down in the file (24 July 2019)

status = VSO_GET(dat, /force, out_dir=dir)

;statusHMIcont = VSO_GET(datHMIcont, /force, out_dir=dir)
;statusHMIlosB = VSO_GET(datHMIlosB, /force, out_dir=dir)
;statusHMIlosV = VSO_GET(datHMIlosV, /force, out_dir=dir)
;statusHMIvectorB=VSO_GET(datHMIvectorB,/force,out_dir=dir)

end
