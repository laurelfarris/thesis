;; Last modified:   14 August 2017 11:30:36


goto, START



restore, "Sav_files/hmi_aligned.sav"
help, cube


;; Test:
;;  Create defaults first, then create structure with defaults plus new values
default = create_struct('title', "HMI", 'max_value', 24)
props = create_struct(default, 'min_value', 0)



;; Test for how to put double axes on plots
period = indgen(10)+1

y = sin(period)

p = plot(period, y, axis_style=2)

ax = p.axes


ax[0].title = "period [minutes]"
ax[1].title = "sin(period)"


ax[2].showtext = 1
T = [2,4,6,8,10]
T = period
f = (1./(60.*T))*1000.

ax[2].title = "frequency [Hz]"


result = string(f, format='(F5.1)')
ax[2].tickname = result
;ax[2].tickvalues = period + 1
;ax[2].major = 10
;ax[2].coord_transform = 

;ax[0].tickformat = '(F4.2)'

;ax[2].tickvalues = f


;; Fucking Christ it took forever to figure out how to label the second (top)
;;   x-axis. But finally got it.

;; August 13, 2017

START:;-------------------------------------------------------------------------------------------

x = indgen(10)
y = x^4

p = plot(x,y, ylog=1)


end
