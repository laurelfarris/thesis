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

DLpath = 'AIA/'
;DLpath = 'HMI/'

;+
;- 14 December 2020
;-
;- C8.3 2013-08-30 T~02:04:00
tstart = '2013/08/30 00:00:00'
tend   = '2013/08/30 05:00:00'
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





;- Start/End times, in UT
;tstart = '2014/04/18 10:00:00'
;tend   = '2014/04/18 14:59:59'

;tstart = '2014/04/18 11:40:00'
;tend   = '2014/04/18 11:50:59'
;tstart = '2014/04/18 13:16:00'
;tend   = '2014/04/18 13:31:59'

;------------
;- 1600

;
;tstart = '2014/04/18 10:53:00'
;tend   = '2014/04/18 10:55:00'
;
;tstart = '2014/04/18 12:18:00'
;tend   = '2014/04/18 12:20:00'
;
;tstart = '2014/04/18 12:28:00'
;tend   = '2014/04/18 12:30:00'
;
;tstart = '2014/04/18 12:57:00'
;tend   = '2014/04/18 12:59:00'
;-----------------

;- 1700
;
;tstart = '2014/04/18 10:59:00'
;tend   = '2014/04/18 11:01:00'
;
;tstart = '2014/04/18 11:59:00'
;tend   = '2014/04/18 12:01:00'
;
;tstart = '2014/04/18 12:59:00'
;tend   = '2014/04/18 13:01:00'
;
;tstart = '2014/04/18 13:26:00'
;tend   = '2014/04/18 13:28:00'
;
;tstart = '2014/04/18 13:39:00'
;tend   = '2014/04/18 13:41:00'
;
;tstart = '2014/04/18 13:59:00'
;tend   = '2014/04/18 14:01:00'
;

;sample='60'

;+
;- Search for files

;dat94   = vso_search(tstart,tend, instr='aia',sample=sample,wave='94')
;dat131  = vso_search(tstart,tend, instr='aia',sample=sample,wave='131')
;dat171  = vso_search(tstart,tend, instr='aia',sample=sample,wave='171')
;dat193  = vso_search(tstart,tend, instr='aia',sample=sample,wave='193')
;dat211  = vso_search(tstart,tend, instr='aia',sample=sample,wave='211')
;dat304  = vso_search(tstart,tend, instr='aia',sample=sample,wave='304')
;dat335  = vso_search(tstart,tend, instr='aia',sample=sample,wave='335')
;dat1600 = vso_search( tstart, tend, instr='aia', sample=sample, wave='1600')
dat1700 = vso_search( tstart, tend, instr='aia', sample=sample, wave='1700')

;datHMIcont = VSO_SEARCH(tstart, tend, instr='hmi', physobs='intensity')
;datHMIlosB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_magnetic_field') 

;datHMIvectorB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='VECTOR_MAGNETIC_FIELD') 

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


;status94 = VSO_GET(dat94, /force, out_dir=dir)
;status131 = VSO_GET(dat131, /force, out_dir=dir)
;status171 = VSO_GET(dat171, /force, out_dir=dir)
;status193 = VSO_GET(dat193, /force, out_dir=dir)
;status211 = VSO_GET(dat211, /force, out_dir=dir)
;status304 = VSO_GET(dat304, /force, out_dir=dir)
;status335 = VSO_GET(dat335, /force, out_dir=dir)
;status1600 = VSO_GET(dat1600, /force, out_dir=dir)
status1700 = VSO_GET(dat1700, /force, out_dir=dir)

;statusHMIcont = VSO_GET(datHMIcont, /force, out_dir=dir)
;statusHMIlosB = VSO_GET(datHMIlosB, /force, out_dir=dir)
;statusHMIlosV = VSO_GET(datHMIlosV, /force, out_dir=dir)
;statusHMIvectorB=VSO_GET(datHMIvectorB,/force,out_dir=dir)

end
