


; 18 September 2018

goto, start


; What is dt between AIA 1600 and 1700 observation times?
diff = A[0].jd[0] - A[1].jd[0]
print, diff * 24. * 3600.
; 1600 lags 1700 by 9.41 seconds
;  ('lag' may not be the best term since they're alternating.
;  As the user I chose to crop the data set so that the observations
;  in array for one channel were as close in time as possible to the
;  observations in array for other channel
; I'm terrible at wording things... in coding language,
;  I wanted to minimize dt between A[i].obs_time[j] and A[i+1].obs_time[j],
;  for given value of j.
; If I'd done it the other way, dt would have been around 14.58 seconds,
;  like Figure 10 in Milligan et al. 2014.


; cc --> channel.
; Trying this because I think it would be a good idea to have a
; consistent counter variable for accessing different channels.
cc = 0

aia_lct, r, g, b, wave=fix(A[cc].channel), /load
xstepper, A[cc].data


; my version: don't need to load table (do need to give channel as
;  argument, but subroutine converts it to integer),
;  plus normalizes images to same max and min to get rid of "flickering".
; seems like I had trouble running this in the past, but don't remmber
; why... solarstorm running kind of slow, lot of processes going on.
xstepper2, A[cc].data, channel=A[cc].channel


; added if statement to xstepper2 to use colortable 0 (black and white)
;   as default.
; added invert_colors kw to xstepper2 to invert black and white.
;   (for reference figure). Using IDL ct 54.

resolve_routine, 'xstepper2'
xstepper2, A[cc].data, /invert_colors


; inverted colors look really nice! As in, useful printout for my
;   own reference.

; sidebar: what is dt between AIA 1600 and 1700 observation times?
; -->  See top of this file.


cc = 1
resolve_routine, 'xstepper2', /either
xstepper2, A[cc].data, /invert_colors, scale=0.80



start:;-------------------------------------------------------------------

;z_start = [90, 270, 315, 455, 463, 472 ]
z_start = 460
cc = 1
dw

resolve_routine, 'get_position', /either
wx = 8.5
wy = 11.0
win = window( $
    dimensions=[wx,wy]*dpi, $
    title = 'AIA ' + A[cc].channel, $
    location=[500,0] )

rows = 5
cols = 3
im = objarr(rows*cols)
for i = 0, n_elements(im)-1 do begin
    z = z_start + 2*i
    im_data = aia_intscale( $
        A[cc].data[*,*,z], $
        wave=fix(A[cc].channel), $
        exptime=A[cc].exptime )
        
    width = 2.0
    position = dpi*GET_POSITION( $
        left=1.25, $
        ;bottom=0.25, $
        ;right=0.25, $
        top = 2.0, $
        xgap=0.1, ygap=0.3, $
        width = width, $
        height = width*(330./500), $
        layout=[cols,rows,i+1] )
      ; The kws for this subroutine need some work...

    im[i] = image2( $
        ;im_data[*,*,i], A[i].X, A[i].Y, $
        im_data, A[cc].X, A[cc].Y, $
        /current, $
        /device, $
        ;layout=[cols,rows,i+1], $
        ;margin=0.25*dpi, $
        position = position, $
        xminor = 4, $
        yminor = 4, $
        ;xshowtext = 1, $
        ;yshowtext = 1, $
        axis_style=0, $
        ;title = A[cc].name + ' ' + A[cc].time[z_start] + ' UT', $
        title = A[cc].time[z] + ' (' + strtrim(z,1) + ')', $
        xtickinterval = 50, $
        ytickinterval = 50, $
        xtitle = 'X (arcseconds)', $
        ytitle = 'Y (arcseconds)', $
        ;rgb_table = 54 )
        rgb_table = reverse( A[cc].ct, 1 ) )

    ;ax = im[i].axes
    ;ax[2].title = 'X (pixels)'
    ;ax[3].title = 'Y (pixels)'

    pos = im[i].position
    CONTINUE

    txt = text( pos[0], pos[3], title, $
        ;/relative, $
        /normal, $
        target=im[i], $
        vertical_alignment=1.0, $
        font_style='Bold', $
        font_size=fontsize )

endfor


file = 'reference_images_' + A[cc].channel + '_02.pdf'
print, ''
print, file
save2, file

end
