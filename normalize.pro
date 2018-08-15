


function normalize, data

    new_data = data - min(data)
    new_data = new_data / max(new_data)
    return, new_data

end
