




    N = 10

    common defaults

    test = intarr(N,N)
    test[*,0:N/2] = 1

    width = N
    height = width

    x1 = 1.
    x2 = x1 + width
    y1 = x1
    y2 = y1 + height
    position=[x1,y1,x2,y2]*dpi
    ;position = fix(position)

    dw
    win = window(dimensions=[8.0,8.0]*dpi, /buffer)
    im = image( test, $
        ;/device, $
        /current, $
        ;/buffer, $
        layout=[1,1,1], $
        margin=0.1, $
        ;position=position, $
        title='N = ' + strtrim(N,1) )

    ;save2, 'test' + strtrim(N,1) + '.pdf'
    win.save, '~/test.pdf'

end
