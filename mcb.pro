;Copied from clipboard


if buffer ne 0 then begin
    xstepper2, $
        CROP_DATA( cube, center=[475,250], dimensions=[200,200] ), $
        channel=channel, subscripts=[300:500], scale=2.00
        ;- Does this work while ssh-ed?? --> yes, but very slow.
endif
;save2, 'align_shifts'

end

