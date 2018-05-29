;; Last modified:   24 May 2018 22:47:40


;+
;
; CREATED       04 April 2018
;
; ROUTINE:      Prep.pro
;
; PURPOSE:
;
; USEAGE:
;
; AUTHOR:       Laurel Farris
;
;-


pro split_cube

    ; put these lines in procedure to get them out of the way
    aia1600before = aligned_cube[100:599,66:395,0:260]
    aia1600during = aligned_cube[100:599,66:395,261:349]
    aia1600after  = aligned_cube[100:599,66:395,350:748]

    aia1600 = create_struct( aia1600, 'before', aia1600before )
    aia1600 = create_struct( aia1600, 'during', aia1600during )
    aia1600 = create_struct( aia1600, 'after', aia1600after )
end


resolve_routine, 'read_my_fits', /compile_full_file
resolve_routine, 'image_ar', /is_function


;READ_AIA, aia1600index, aia1600data, '1600'
;READ_AIA, aia1700index, aia1700data, '1700'
;READ_HMI, index, data

;aia1600 = PREP_AIA(aia1600index, aia1600data, '1600', color='dark orange')
;aia1700 = PREP_AIA(aia1700index, aia1700data, '1700', color='dark cyan')
;hmi = PREP_HMI( index, data )

;hmi = create_struct( hmi, 'ct', 0 )
;S = {  aia1600 : aia1600, aia1700 : aia1700, hmi : hmi  }
;A = [ aia1600, aia1700 ]

; Align HMI data
;cube = data_rotated
;ref = cube[*,*,sz[2]/2]
;align_cube3, cube, ref



temp = [ $
    [[ (S.(0).data - min(S.(0).data))  ]], $
    [[ (S.(1).data - min(S.(1).data))  ]], $
    [[S.(2).data>(-300)<300]] $
    ]

sz = size( temp, /dimensions )
X = (indgen(sz[0])-aia1600index.crpix1) * aia1600index.cdelt1
Y = (indgen(sz[1])-aia1600index.crpix2) * aia1600index.cdelt2

x0 = 2420 + 35
y0 = 1665
xl = 500
yl = 330
temp2 = temp[ x0-(xl/2):x0+(xl/2)-1, y0-(yl/2):y0+(yl/2)-1, * ]
sz2 = size( temp2, /dimensions )
X2 = (indgen(sz2[0])-aia1600index.crpix1) * aia1600index.cdelt1
Y2 = (indgen(sz2[1])-aia1600index.crpix2) * aia1600index.cdelt2


;dat = { $


im = image_AR( temp, layout=[3,2] )
;im = image_AR( temp2, X2, Y2, layout=[3,2] )

;if i le 1 then im[i].rgb_table = S.(i).ct
im[0].rgb_table = S.(0).ct
im[3].rgb_table = S.(0).ct
im[1].rgb_table = S.(1).ct
im[4].rgb_table = S.(1).ct





end
