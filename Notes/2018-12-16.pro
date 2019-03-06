
;- Sun Dec 16 21:03:07 MST 2018

;- Test routine that will eventually be the base routine or template for plotting,
;-  regardless of whether using multi-panels or just one, and whether overplotting
;-  or only one line per panel.
;- Already have batch_plot... combine these?
;-
;- Write as if plot3 didn't exist, to get a better idea of how to write it.


goto, start


mm = 100
nn = 2

;xdata = byte(indgen(mm) # (intarr(nn)+1))
;- matrix operators return LONG result.
;- byte is easier to see when printing to IDL command line, but
;- this may cause problems with real data, so be careful with data types.

;xdata = byte(indgen(mm) # (intarr(nn)+1))
;ydata = byte( [ [y1], [y2] ] )

;xdata =  x # (intarr(nn)+1)
;ydata =  [ [y1], [y2] ]


start:;----------------------------------------------------------------------------------

;- Worry about creating xdata later. Now just work on plot3.

dpi = 96
mm = 10000
x = findgen(mm)/100

color = ['green', 'purple']
name = ['line', 'squared']

s1 = { $
    xdata : x, $
    ydata : x, $
    props : { $
        symbol : 'Circle', $
        sym_size : 0.7, $
        thick : 0.5, $
        color : 'black', $
        name : 'x$^{1.0}$', $
        overplot : 0 }}

s2 = { $
    xdata : x, $
    ydata : x^1.2, $
    props : { $
        symbol : 'square', $
        sym_size : 0.5, $
        thick : 1.0, $
        color : 'green', $
        name : 'x$^{1.2}$', $
        overplot : 1 }}

s3 = { $
    xdata : x, $
    ydata : x^1.5, $
    props : { $
        symbol : 'tu', $
        sym_size:1.0, $
        thick : 1.5, $
        color : 'purple', $
        name : 'x$^{1.5}$', $
        overplot : 1 }}

parr = { s1:s1, s2:s2, s3:s3 }

n_symbols = 10.

cols = 3
rows = 2

;- used ":r win.pro" to pull lines directly from code.
;dw
;wx = 8.0
;wy = 11.0
;win = window( dimensions=[wx,wy]*dpi, location=[400,0] )

resolve_routine, 'get_position', /either

struc = GET_POSITION( $
    layout=[cols,rows,rows*cols], aspect_ratio=1.0 )


win = window( dimensions=struc.dimensions*dpi, location=[400,0] )

for jj = 0, rows*cols-1 do begin

    struc = GET_POSITION( $
        layout=[cols,rows,jj+1], $
        aspect_ratio=1.0 )
    position = struc.position

    for ii = 0, n_tags(parr)-1 do begin

        plt = plot2( $
            parr.(ii).xdata, $
            ;parr.(ii).ydata + 10000*(ii+1), $
            parr.(ii).ydata, $
            /current, $
            /device, $
            position = position*dpi, $
            ;ylog = 0, $
            ;yrange = [0, max(x^3)], $
            sym_increment = n_elements(parr.(ii).xdata)/n_symbols, $
            xtitle = '|$B_{LOS}$|', $
            ytitle = '3-minute power', $
            title = 'Before', $
            _EXTRA=parr.(ii).props )
            ;- NOTE: extra properties take precedence over same kws defined in
            ;-    call to plot2 - those would have to be the defaults.

    endfor
endfor

stop
resolve_routine, 'save2', /either
save2, 'test', /add_timestamp


;resolve_routine, 'plot3', /either
;plt = plot3( xdata, ydata, buffer=0 )
;    name = name )

;
;xtitle = [ $
;    '|$ B $|', $
;    '|$ \vec B $|', $
;    '|$ \overline{B} $|', $
;    '' ]
;for ii = 0, n_elements(xtitle)-1 do $
;    tt = text( 0.2*ii, 0.1, xtitle[ii], font_size=fontsize )

end
