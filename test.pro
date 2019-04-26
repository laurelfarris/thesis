

for ff = 1, 8 do begin

    print, 'freq = ', ff, ' mHz'

    period_sec = 1./(ff/1000.)
    help, period_sec
    period_min = period_sec/60.
    help, period_min
    print, ''

endfor

end
