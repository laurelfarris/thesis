;; Last modified:   25 October 2017 18:53:29

;get data from the VS0
;
;
; AIA: cycle through each of the EUV wavelengths
;   and get images at intervals set by 'sample' keyword [seconds]


;; Search for files
tstart = '2011/02/15 00:00:00'
tend =   '2011/02/15 01:59:59'

;; For FT examples on 5-minute oscillations (28 Sep 2017)
;tstart = '2011/02/14 00:00:00'
;tend =   '2011/02/14 02:00:00'

;sample='60'
instr = 'aia'
;instr = 'hmi'

;dat94   = vso_search(tstart,tend, instr=instr,sample=sample,wave='94')
;dat131  = vso_search(tstart,tend, instr=instr,sample=sample,wave='131')
;dat171  = vso_search(tstart,tend, instr=instr,sample=sample,wave='171')
;dat193  = vso_search(tstart,tend, instr=instr,sample=sample,wave='193')
;dat211  = vso_search(tstart,tend, instr=instr,sample=sample,wave='211')
dat304  = vso_search(tstart,tend, instr=instr,sample=sample,wave='304')
;dat335  = vso_search(tstart,tend, instr=instr,sample=sample,wave='335')
;dat1600 = vso_search( tstart, tend, instr=instr, sample=sample, wave='1600')
;dat1700 = vso_search( tstart, tend, instr=instr, sample=sample, wave='1700')

;datHMI  = VSO_SEARCH(tstart, tend, instr=instr, physobs='intensity')
;datHMI  = VSO_SEARCH(tstart, tend, instr=instr, physobs='LOS_velocity') 
;
stop

; Download the data.
; This will take a long time and uninterupted internet connect.
; Can run while ssh'd using the 'screen' command.

dir='/solarstorm/laurel07/Data/AIA/'
;dir='/solarstorm/laurel07/Data/HMI/'

;shouldn't redownload data that's already stored in the local directory
;status94 = vso_get(dat94, /force, out_dir=dir)
;status131 = vso_get(dat131, /force, out_dir=dir)
;status171 = vso_get(dat171, /force, out_dir=dir)
;status193 = vso_get(dat193, /force, out_dir=dir)
;status211 = vso_get(dat211, /force, out_dir=dir)
status304 = vso_get(dat304, /force, out_dir=dir)
;status335 = vso_get(dat335, /force, out_dir=dir)
;status1600 = vso_get(dat1600, /force, out_dir=dir)
;status1700 = vso_get(dat1700, /force, out_dir=dir)
;statusHMI=VSO_GET(datHMI,/force,out_dir=dir)

end
