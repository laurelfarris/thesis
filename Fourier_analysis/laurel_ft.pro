;-----------------------------------------------------;
; The purpose of this code is to produce a lightcurve
; for a bright point. Each pixel that is considered part
; of the BP (i.e. higher than some predetermined threshold)
; is added to the total sum for that time point.
; The total sum is then written to file to be read in for 
; plotting
;-----------------------------------------------------;

; Values needed from data cube
t = (size(cube))[3]
tau = indgen(t)-(t/2)
pixels = (size(cube))[1]

; Pixel values
x = 240
y = 1730

; Define radius of pixels that may contain the BP
s = 20
threshold = 150

;; Define the bright point data cube
bp = cube[x-s:x+s, y-s:y+s, *]
length = n_elements(bp[*,0,0])

; Set mask to array size of bp, all elements=0
mask = intarr(length, length, t)

; Array that only has values greater than threshold
;mask[where(bp gt threshold, /NULL)] = 1
;bp = bp*mask

bp_size = []
intensity = []

for n = 0, t-1 do begin
    ii=0
    tot=0
    for x0 = x-s, x+s do begin
        jj=0
        for y0 = y-s, y+s do begin
            ;print, jj
            if bp[ii,jj,n] ge threshold then begin
                mask[ii,jj,n] = 1
                tot++
            endif
            jj++
        endfor
        ii++
    endfor
    bp[*,*,n] = bp[*,*,n] * mask[*,*,n]
    intensity = [intensity,(total(bp[*,*,n]))/tot]
    bp_size = [bp_size, tot]
endfor

f_i = fourier2(intensity, 1.)
f_s =  fourier2(bp_size, 1.)

end
