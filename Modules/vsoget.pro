;- Last modified:
;-   23 July 2019
;-
;- AIA: cycle through each of the EUV wavelengths and get images at intervals
;-   set by 'sample' keyword (e.g. sample='60' gets images at 1 minute intervals)


;- Start/End times, in UT
tstart = '2014/04/18 10:33:00'
tend   = '2014/04/18 10:59:59'

;- HMI image(s) around peak flare time (couple minutes' worth)
tstart = '2014/04/18 13:02:00'
tend   = '2014/04/18 13:04:00'

;- t-separation between observation times (in case cadence is just too damn good).
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
;datHMIlosV = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_velocity') 
;datHMIlosB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='LOS_magnetic_field') 
;datHMIvectorB = VSO_SEARCH(tstart, tend, instr='hmi', physobs='VECTOR_MAGNETIC_FIELD') 

stop


;+
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
