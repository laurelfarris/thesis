;; Last modified:   25 October 2017 17:22:36

;; Search for files
tstart = '2011/02/15 ';00:00:00'
tend =   '2011/02/15 ';01:00:00'

t1 = [ $
    '02:52:00', $
    '03:16:00', $
    '03:40:00', $
    '04:16:00']
t2 = [ $
    '02:54:00', $
    '03:18:00', $
    '03:42:00', $
    '04:18:00']

instr = 'hmi'
dir='/solarstorm/laurel07/Data/HMI/'

for i = 0, 3 do begin
    datHMI  = VSO_SEARCH(tstart+t1[i], tend+t2[i], instr=instr, physobs='intensity')
    statusHMI=VSO_GET(datHMI,/force,out_dir=dir)
endfor


end
