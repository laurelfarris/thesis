;- Last modified:  13 December 2018 10:27:22 MST
;-
;- Purpose:
;-  get data from the VS0
;-
;- NOTE:
;-  vsoget_original.pro is in directory for original codes, so don't need to preserve anything here.
;-
;- To Do:
;-  Copy url from lmsal (or wherever) for help on this stuff.




;- AIA: cycle through each of the EUV wavelengths and get images at intervals
;        set by 'sample' keyword (e.g. sample='60' gets images at 1 minute intervals)
;



;- Start/End times, in UT

;tstart='2011/02/11 01:36:00'
;tend='2011/02/11 02:00:00' 

;tstart = '2011/02/15 00:00:00'
;tend =   '2011/02/15 04:59:59'
;tend =   '2011/02/15 00:02:00'

;; For FT examples on 5-minute oscillations (28 Sep 2017)
;tstart = '2011/02/14 00:00:00'
;tend =   '2011/02/14 02:00:00'


;- 06 March 2019 -- search for new flare
;tstart='2013/12/28 12:42:00'
;tend  ='2013/12/28 12:52:00' 
;- quiet sun to test codes and look for expected osc. behavior NOT during flares


;tstart='2013/12/28 10:00:00'
;tend  ='2013/12/28 13:59:59' 
;tstart='2013/12/28 14:00:00'
;tend  ='2013/12/28 14:59:59' 

;- 2019 July 19
;tstart='2012/03/09 03:21:00'
;tend  ='2012/03/09 03:23:59'
tstart='2014/04/18 13:24:00'
tend  ='2014/04/18 14:59:59'

;- HMI, just to see what it looks like
;tstart='2013/12/28 12:45:00'
;tend  ='2013/12/28 12:49:00' 


;- "sample kw --> Cadence desired (seconds).
;-   (not instrumental cadence, just whatever interval you want between data files.
;-   Maybe you only want data separated by an hour so you can see long term trends without
;-   downloading a ton of data.)
;sample='60'
;sample='12'
;sample='60'




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


;datHMI=VSO_SEARCH(tstart,tend, instr='hmi')

;datHMIcont = VSO_SEARCH(tstart, tend, instr='hmi', physobs='intensity')
;datHMIlosV = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_velocity') 
;datHMIlosB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_magnetic_field') 
;datHMIvectorB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='VECTOR_MAGNETIC_FIELD') 

;- Return a structure for each bandpass

stop


;- Download data:
;-   This will take a long time and uninterupted internet connect.
;-   Can run while ssh'd using the 'screen' command.

;-   keyword /NODOWNLOAD will get header info only (no data).
;-   Shouldn't redownload data that's already stored in the local directory.



dir='/solarstorm/laurel07/Data/AIA/'
;dir='/solarstorm/laurel07/Data/HMI/'


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
;statusHMIlosV = VSO_GET(datHMIlosV, /force, out_dir=dir)
;statusHMIlosB = VSO_GET(datHMIlosB, /force, out_dir=dir)
;statusHMIvectorB=VSO_GET(datHMIvectorB,/force,out_dir=dir)

end
