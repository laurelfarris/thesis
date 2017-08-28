;; Last modified:   15 August 2017 19:48:05



x1 = findgen(1000)
x1 = (x1/max(x1))*8*!PI
y1 = sin(x1)

p1 = plot(x1,y1)


x2 = x1[0:599]
y2 = (sin(x2*3))/2.

const = max(x1)/max(x2)
x2 = x2*const

p2 = plot(x2,y2, color='red', /overplot)


end
