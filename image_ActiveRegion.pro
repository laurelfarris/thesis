;; Last modified:   09 February 2018 08:54:27

goto, start


restore, 'aia_1600_cube.sav'
image1 = cube[ *,*,0 ]
restore, 'aia_1700_cube.sav'
image2 = cube[ *,*,0 ]


sz = size(image1, /dimensions)

imageWidth = 500
imageHeight = 330

x1 = (sz[0])/2 - imageWidth/2
x2 = x1 + imageWidth - 1
y1 = (sz[1])/2 - imageHeight/2
y2 = y1 + imageHeight - 1


u1 = im1[ uniq(im1, sort(im1)) ]
u2 = im2[ uniq(im2, sort(im2)) ]

p1 = plot( u1 )
p2 = plot( u2 )





start:;---------------------------------------------------------------------------------

;; New variables so that if I mess up or want to change them,
;;  'image1' and 'image2' are unchanged, and don't have to restore
;;  in full date set every time.
im1 = float(image1[ x1:x2, y1:y2 ])
im2 = float(image2[ x1:x2, y1:y2 ])

im1 = im1-min(im1)
;im1 = im1^0.3

im2 = im2-min(im2)
im2 = (im2/max(im2))*max(im1)
;im2 = im2^0.5

im1 = im1^0.5
dat = [ [[ im1 ]], [[ im2 ]] ]

;; Absolute coords
;;  Need to define this BEFORE taking subset of 1000x1000 cube...
;;  except can't really use these numbers for that... but they
;; need to adjust if I want to shift the image center a bit... crap.
xCenter = 2400
yCenter = 1650
imageLocation = [ $
    xCenter - (imageWidth/2), $
    yCenter - (imageHeight/2) ]


;; Global properties
@graphics

;; Properties for all panels in window
local_props = { $
    xtitle:"X (pixels)", $
    ytitle:"Y (pixels)", $
    image_location:imageLocation $
    }

;; Properties for individual plots/images within window
color = [ 'dark olive green', 'dark slate blue' ]
title = [ $
    "AIA 1600$\AA$ at 01:30", $
    "AIA 1700$\AA$ at 01:30" ]
txt = [ '(a)', '(b)' ]

props = create_struct( image_props, local_props )
    
im = objarr(2)

wx = 4.0*dpi
wy = wx*2*(float(imageHeight)/float(imageWidth))
win = window( dimensions=[wx,wy] )
for i=0,1 do begin

    im[i] = image( $
        dat[*,*,i], $
        /current, $
        ;/device, $
        layout=[1,2,i+1], $
        margin=[0.15,0.15,0.15,0.15], $
        ;rgb_table = [ 'black', 'green', 'white' ], $
        ;title=title[i], $
        _EXTRA=props)


    ax = im[i].axes

    ind = ax[0].tickvalues
    ax[2].tickname = string(round(ind * 0.6))
    ax[2].title = "X (arcseconds)"
    ax[2].showtext = 1

    ax[3].tickname = strtrim( round(ax[1].tickvalues * 0.6),1 )
    ax[3].title = "Y (arcseconds)"
    ax[3].showtext = 1

    t = text( 0.03, 0.9, txt[i], target=im[i], /relative, color='white' )

endfor






end
