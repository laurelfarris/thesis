import numpy as np
from scipy.interpolate import interp2d


def shift_sub(image, x0, y0):
    '''
    Purpose:            Shift a (2D) image with subpixel accuracies
    Calling sequence:   Result = shift_sub(image, x0, y0)
    Notes:              Thoroughly converted from the IDL version,
                        although dimensions are questionable
    HISTORY:            2004 August, J. Chae,
                        Added the keyword
                            'cubic' for cubic spline interpolation option
    Last updated:       04 August 2016
    '''

    if int(x0)-x0 == 0. & int(y0)-y0 == 0.:
        image = np.roll(image, x0, axis=1)
        image = np.roll(image, y0, axis=0)
        return image

    s = image.shape
    x = np.matrix(np.ones(s[0])).reshape(s[0], 1) * np.matrix(np.arange(s[1]))
    y = np.matrix(np.arange(s[0])).reshape(s[0], 1) * np.matrix(np.ones(s[1]))

    ''' Set interpolation values '''
    x1 = np.max([0, (x-x0), (s[1]-1.)])
    y1 = np.max([0, (y-y0), (s[0]-1.)])

    ''' return interpolated image '''
    return interp2d(x1, y1, image, kind='cubic')
