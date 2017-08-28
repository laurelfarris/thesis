;; Last modified:   14 August 2017 23:51:48

str = index[0].date_obs
t1 = strmid( str, 0, 11 )
t2 = strmid( str, 11, 11 )

print, str
print, t1,t2

x = float(t2)

end
