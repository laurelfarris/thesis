;; Last modified:   25 October 2017 18:45:54

;; Search for files
tstart = '2011/02/15 ';00:00:00'
tend =   '2011/02/15 ';01:00:00'

t1 = [ $
    '01:30:00', $
    '02:30:00', $
    '03:30:00', $
    '04:30:00' ]
t2 = [ $
    '01:30:30', $
    '02:30:30', $
    '03:30:30', $
    '04:30:30' ]

instr = 'aia'
dir='/solarstorm/laurel07/Data/AIA/'

for i = 0, 3 do begin
    datAIA  = VSO_SEARCH(tstart+t1[i], tend+t2[i], instr=instr, wave='1700')
    STOP
    statusAIA=VSO_GET(datAIA,/force,out_dir=dir)
endfor


end
