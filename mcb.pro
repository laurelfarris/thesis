;Copied from clipboard


t0 = '01:30 15-feb-2011'
t1 = '02:30 15-feb-2011'
;ds = 'aia.lev1_euv_12s'
waves = '1600'
key = 't_obs, wavelnth, datamean, exptime'
cadence = '24s'
;-
ssw_jsoc_time2data, $
    t0, t1, $  ;- user time range
    index, $
    ;ds=ds, $  ;- data series name
    waves=waves, $
    key=key, $
    cadence=cadence
;-
;help, index[0]
;
utplot, index.t_obs, index.datamean/index.exptime;, psym=1

end

