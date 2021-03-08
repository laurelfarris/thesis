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
;- 14 December 2020
;- Examples from source code "ssw_jsoc_time2data.pro":
;-   ssw_jsoc_time2data, $
;-     '12:00 10-jun-2010', $
;-     '13:45 10-jun-2010', $
;-     index, KEY='wavelnth,exptime,img_type,t_obs,date__obs'
;-   ssw_jsoc_time2data, $
;-     '15-dec-2011', '17-dec-2011', $
;-     drms, urls, /urls_only, cadence='1h', waves='171, 193, 304', /jsoc2
;-


;M1.5 2013-08-12 T~10:21:00


;=========================================================================
;= 05 March 2021
;=

;- C8.3, 2013-08-30,  2:04, 2:46, 4:06
@par2
flare = multiflare.C83


ssw_jsoc_time2data, $
    ;'01:30 2011-02-15', '02:30 2011-02-15', $
    '00:00 2013-08-30', '05:00 2013-08-30', $
    index, $
    ;ds='aia.lev1_euv_12s',$
    waves='1600', $
    key='t_obs,wavelnth,datamean,exptime', $
    cadence='24s'
;
xdata = index.t_obs
ydata = index.datamean/index.exptime


print, max( index.datamean/index.exptime )

stop;----

UTPLOT, xdata, ydata, psym=1, yrange=[min(ydata),max(ydata)]



stop

d_start = '01:30 30-aug-2013'
d_end   = '02:30 30-aug-2013'
;ds = 'aia.lev1_euv_12s'
key = 't_obs, wavelnth, datamean, exptime'
cadence = '24s'
waves = '1600'
;-

ssw_jsoc_time2data, d_start, d_end, index, ds=ds, waves=waves, key=key, cadence=cadence


utplot, index.t_obs, index.datamean/index.exptime, psym=1

end
