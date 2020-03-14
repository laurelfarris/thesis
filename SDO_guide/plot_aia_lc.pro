;+
;- 10 March 2020
;-
;- Guide to SDO data analysis, September 12, 2019
;-   6  How to process AIA Data
;-   6.7.4  Plotting an AIA Light Curve
;-
;- Plot an exposure-time-corrected  (!!)
;-   LC, using DATAMEAN and T_OBS from headers.
;-
;-


d_start = '2011-02-14'
d_end   = '2011-02-16'
ds = 'aia.lev1_euv_12s'
key = 't_obs, wavelnth, datamean, exptime'
cadence = '1h'
;-
ssw_jsoc_time2data, d_start, d_end, index, ds=ds, $
    waves=waves, key=key, cadence=cadence


utplot, index.t_obs, index.datamean/index.exptime, psym=1

end
