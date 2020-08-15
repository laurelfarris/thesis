;+
;- 15 May 2020
;-
;- ==>>  Don't forget to either put plot_sdo_lc.pro back in /ss/laurel07/SDO_guide/,
;-   or add documentation of its re-location.
;-
;-
;- Define three separate array structures
;-  i.e. A, B, C (or something else)
;-  Lots of code written to access "A[cc].whatever"...
;-



;+
;- ML code in struc_aia.pro:
;-

aia1600 = STRUC_AIA( aia1600index, aia1600data, cadence=24., instr='aia', channel='1600' )
aia1700 = STRUC_AIA( aia1700index, aia1700data, cadence=24., instr='aia', channel='1700' )


A = [ aia1600, aia1700 ]
undefine, aia1600
undefine, aia1600index
undefine, aia1600data
undefine, aia1700
undefine, aia1700index
undefine, aia1700data
A[0].color = 'blue'
A[1].color = 'red'



;-



format = '(e0.4)'
;-
cc = 0
print, ''
print, A[cc].channel
;print, max(A[cc].flux), format=format
print, min(A[cc].flux/A[cc].exptime), format=format
print, max(A[cc].flux/A[cc].exptime), format=format
;-
cc = 1
print, ''
print, A[cc].channel
;print, max(A[cc].flux), format=format
print, min(A[cc].flux/A[cc].exptime), format=format
print, max(A[cc].flux/A[cc].exptime), format=format





;-
;-------
;--- SDO guide

;- aia light curve (exptime-corrected) using DATAMEAN and T_OBS keywords from image headers:
SSW_JSOC_TIME2DATA, $
    '2011-02-20', $
    '2011-03-06', $
    index, $
    ds='aia.lev1_euv_12s', $
    waves='335', $
    key='t_obs,wavelnth,datamean,exptime', $
    cadence='1h'
;-
UTPLOT, index.t_obs, index.datamean/index.exptime, psym=1

;- plot_map.pro
result=vso_search(’2011-01-01 1:00’,’2011-01-01 1:01’,inst=’aia’,wave=171,sample=60)
log=vso_get(result,out_dir=’data’,filenames=fnames,/rice)
aia_prep,fnames,-1,out_index,out_data


;----
;- Actualy, already did this once: copied contents of Notes/2020-03-10.pro,
;-   to which I was pointed by the README file in /solarstorm/laurel07/SDO_guide/

;+
;- 10 March 2020
;-

;+
;- Guide to SDO data analysis, September 12, 2019
;-   6  How to process AIA Data
;-
;-
;--
;-   6.7.4  Plotting an AIA Light Curve
;--
;-
;- "Plot an exposure-time-corrected  (!!)
;-   LC, using DATAMEAN and T_OBS from headers..."
;-

;- documentation for ssw_jsoc_time2data;
;-   use "which" procedure to show directory containing these routines:
which, 'ssw_jsoc_time2data'
;-

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


;--
;-   6.7.5  plot_map.pro
;--



;t0 = '2011-01-01 1:00'
;t1 = '2011-01-01 1:01'
t0 = '2011-02-15 1:40'
t1 = '2011-02-15 1:41'
;-
inst = 'aia'
;wave = 171
wave = 1600
;-
sample = 60



;-
;-
;- query, download, and run aia_prep on test data.
result = VSO_SEARCH(t0, t1, inst=inst, wave=wave, sample=sample)
log = VSO_GET(result, out_dir='SDO_guide',filenames=fnames, /rice)
aia_prep, fnames, -1, out_index, out_data
;-
;-
;- convert images to a map structure, plot the first one.
index2map, out_index, out_data, map
plot_map, map, /log, drange=[1e2, 1e4]
;-
;-
;-


end
