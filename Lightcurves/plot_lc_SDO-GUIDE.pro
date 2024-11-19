;+
;- LAST MODIFIED:
;-   06 August 2024 --
;-      copied brief paragraph + code from
;-      SDO_guide_2020.pdf, § 7.7.4:  'Plotting an AIA Light Curve':
;-     
;- 10 March 2020 --
;-   Guide to SDO data analysis, September 12, 2019
;-     6  How to process AIA Data
;-     6.7.4  Plotting an AIA Light Curve
;-
;- Plot an exposure-time-corrected  (!!)
;-   LC, using DATAMEAN and T_OBS from headers.
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

;=======================================================================================================
;= 05 March 2021
;=

;- C8.3, 2013-08-30,  2:04, 2:46, 4:06
;@par2
;flare = multiflare.C83

;== NEW (variables defined in one script so dont' have to type same thing over and over
;    in every single ML code every single session...):
@main

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

; UTPLOT**
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

; utplot**
utplot, index.t_obs, index.datamean/index.exptime, psym=1



; ** UTPLOT procedure
;  => see "Guide to SDO Data Analysis" (p. 79-80 in SDO_guide_2019.pdf)
;       for utplot useage + examples
; -- 27 December 2023


;=======================================================================================================
;= 06 August 2024
;=

;-    "Because the image headers are segregated from the images in the JSOC,
;-     any quantity that can be derived directly from the keywords can be computed quickly.
;-     For example, to plot an exposure-time-corrected AIA light curve as a function of time,
;-     one can use data contained in the DATAMEAN and T_OBS keywords from the image headers...
;-   
;-    In this example, a light curve from the 335Å channel for two weeks in early
;-      2011 is plotted using the SSW procedure utplot.pro.
;-      (Incidentally, the jump in the light curve occurring late in the day of 24 February 2011
;-       is a result of a bakeout of AIA Telescope #1 on this day,
;-       an event listed on the SDO Joint Science Operations Calendar.)"
;-
;-

ssw_jsoc_time2data, $
    '2011-02-20', '2011-03-06', index, $
    ds='aia.lev1_euv_12s', $
    waves='335', $
    key='t_obs, wavelnth, datamean, exptime', $
    cadence='1h'
;
utplot, index.t_obs, index.datamean/index.exptime, psym=1

;- Pretty sure this is the same text copied above more than three years ago...
;-


end
