

;- 18 October 2018
;-   Subroutine to normalize data between 0.0 and 1.0, but there are so few lines
;-   that it's not a big deal to do this manually every time it's needed.


function normalize, data

    new_data = data - min(data)
    new_data = new_data / max(new_data)
    return, new_data

end
