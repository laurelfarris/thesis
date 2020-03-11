;+
;- 10 March 2020
;-



;+
;- Today's project: create global mask where any pixel that saturates
;-  even once during entire 5-hour time series is set = 0.
;-  Code in current directory called "mask.pro" that's over a year old,
;-  but looks to do almost exactly this.
;-



threshold = 15000.
mask = product( A.data LT threshold, 3 )

title = A.name + " global saturation mask (" $
    + A.time[0] + "-" + A.time[-1]  + ")"


dw
win = window( dimensions=[8.5,11.0]*dpi )
im = objarr(n_elements(A))
for cc = 0, 1 do begin
    im[cc] = image2( $
        mask[*,*,cc], $
        /current, /device, $
        layout=[1,2,cc+1], $
        margin=1.75*dpi, $
        title=title[cc] $
    )
endfor

filename = 'mask_global'
save2, filename, /timestamp








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
