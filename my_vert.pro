;; Last modified:   25 October 2017 16:53:35



function my_vert, x

    y1 = p.yrange[0]
    y2 = p.yrange[1]
    vert = plot( [x,x], [y1,y2], linestyle=2, /overplot ) 

end



function my_hor, y

    x1 = p.xrange[0]
    x2 = p.xrange[1]
    hor = plot( [x1,x2], [y,y], linestyle=2, /overplot ) 

end
