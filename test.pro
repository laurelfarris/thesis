
pro TEST, data, X, Y

    common defaults
    wx = 8.5
    wy = wx

    sz = size( data, /dimensions )

    win = window( dimensions=[wx,wy]*dpi, /buffer )
    im = image2( data, $
        X, Y, $
        layout=[1,1,1], margin=1.0*dpi, $
        title="unchanged", $
        /current, /device )

end



data = indgen(10, 5)
X = findgen(10)/10
Y = findgen(5)/10

TEST, data, X, Y

save2, 'test1.pdf'
dw



data2 = congrid(data, 100, 50)
X = congrid(X,100)
Y = congrid(Y,50)

TEST, data2, X, Y

save2, 'test2.pdf'
dw


end
