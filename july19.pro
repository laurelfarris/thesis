;; Last modified:   12 August 2017 16:54:22

;; Useful things:
;;      Using headers to get time/indices of missing data


goto, START


;; Starting work with aia... all I've done so far is align
restore, 'aia_1600_aligned.sav'
a1600 = cube
restore, 'aia_1700_aligned.sav'
a1700 = cube



;; Confirming that I actually did not overwrite the 1600 file with the 1700 one. :)
x1 = 200
x2 = 650
y1 = 200
y2 = 500
data = cube[*,*,0] ;; HMI - comparing relative coordinates
im1 = image(  data, layout=[1,1,1], dimensions=[600,600], margin=0 )
STOP
data = (a1600[x1:x2,y1:y2,0])^0.5
im1 = image(  data, layout=[1,1,1], dimensions=[600,600], margin=0 )
data = (a1600[x1:x2,y1:y2,-1])^0.5
im2 = image( data, layout=[1,1,1], dimensions=[600,600], margin=0 )
STOP
im3 = image( a1700[*,*,0], layout=[1,1,1], dimensions=[600,600], margin=0 )
im4 = image( a1700[*,*,-1], layout=[1,1,1], dimensions=[600,600], margin=0 )



;; Read headers to figure out where data is missing
@main.pro
fls = file_search(aia_path + '*1700*.fits')
read_sdo, fls, index, data, /nodata

sec = []
for i = 0, n_elements(index)-1 do begin
    t_obs = index[i].date_obs
    sec = [sec, get_timestamp( t_obs, /sunits )]
endfor

diff = sec - shift(sec, 1)

missing_indices = where( diff ne 24.0 )
print, diff[missing_indices]
STOP


;; Going to proceed with 1600 for now, since it's not missing any images.


;; find coordinates of images during flare
times = strmid(aia_1600_index.date_obs, 11, 5)
t1 = (where( times eq '01:20' ))[0]
t2 = (where( times eq '03:10' ))[-1]

sz = size(a1600, /dimensions)


;; Fourier analysis


delt = 24.

;; Total flux of each image
flux_all = []
for i = 0, sz[2]-1 do begin
    flux_all = [flux_all, total(a1600[*,*,i]) ]
endfor
flux_during = []
for i = t1, t2 do begin
    flux_during = [flux_during, total(a1600[*,*,i]) ]
endfor

;; Calculate FT
result = fourier2( flux_all, delt, /norm )

;; Plots


START:;-------------------------------------------------------------------------------------------
period = (1./result[0,*])/60.
ps = result[1,*]
p2 = plot( period, ps, xtitle="period [min]", ytitle="power" , $
    xrange=[min(period), 6.0], $
    yrange=[min(ps), 0.5])


;; Images



end
