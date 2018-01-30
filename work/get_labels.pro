;; Last modified:   16 August 2017 10:37:14

function GET_LABELS, label_1, n_major

    ;; Difference between each tick label
    increment = n_elements(label_1)/n_major


    ;; No "-1" in FOR loop... want this to be inclusive.
    indices = []
    for i=0, n_major do begin
        indices = [ indices, i*increment ]
    endfor
    return, label_1[indices]
end
