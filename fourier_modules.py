import numpy as np
import math
import matplotlib.pyplot as plt


def signif_conf(ts, p):
    ''' Given a timeseries (ts), and desired probability (p),
    compute the standard deviation of ts (s) and use the
    number of points in the ts (N), and the degrees of freedom (DOF)
    to calculate chi. '''
    s = np.std(ts)
    N = ts.size
    DOF = 2

    # chi = chi_sqr(1.-p, DOF)
    chi = chi_sqr(1.-p, DOF)

    signif = ((s**2)*chi) / ((N/2)*DOF)
    return signif


def fourier2(Flux, Delt,
             pad=None, rad=None, norm=None, signif=0.95, display=None):

    ''' Subtract the mean '''
    Flux = np.array(Flux)
    newflux = np.array(Flux) - np.array(Flux).mean()
    N = newflux.size

    ''' Start padding if keyword was specified '''
    if pad:
        base2 = int(np.log(N)/np.log(2)) + 1
        if (N != 2.**(base2-1)):
            np.append(newflux, np.array(long(2)**base2-N, dtype=float))
            N = newflux.size
            print ("Padded " + str(N) + " data points with " +
                   str(long(2)**(base2) - N) + " zeros.")
            print ("**RECOMMEND checking against fourier spectrum of non padded "
                   "time series**")

    ''' make the frequency array '''
    Freq = np.arange((N/2)+1) / (N*Delt)

    ''' Calculate the (forward) FFT of the form a(w) + ib(w) '''
    V = np.fft.fft(newflux)

    ''' Calculate the power and amplitude '''
    Power = 2*(abs(V)**2)
    Amplitude = 2*(abs(V))

    ''' Since we are taking the FFT of a real time series, (not complex), the
    second half is a duplicate, so it can be removed.
    Also do not use the zero-eth element becuase it will just be equal to the
    mean, which has been set to zero anyway '''
    Freq = (Freq[1:]).flatten
    Power = (Power[1:N/2]).flatten
    Amplitude = (Amplitude[1:N/2]).flatten

    '''
    By Parseval's Theorem, the variance of a time series should be equal to the total
    of its power spectrum (this is just conservation of energy). Check that you
    have the correct normalization for your Power Spectrum by comparing the total
    of your spectrum (with N/2 points) with the variance
    print 'Variance of time series = ' + str(newflux.var)
    print 'Total of Power Spectrum = ' + str(np.sum(Power))
    '''

    ''' Get real and imaginary parts of V '''
    imag = (V.imag)[1:N/2]
    amp = (V.real)[1:N/2]

    ''' Calculate the the phase for each frequency.
    In simple terms this is just arctan(y/x), since tan(phase)=y/x.
    Gives phase in radians between -pi and pi, and converts to degrees
    by default'''
    if rad:
        Phase = np.arctan2(amp, imag)
    else:
        Phase = np.degrees(np.arctan2(amp, imag))

    '''
    sig_lvl = 0.
    if signif:
        conf = signif
    else:
        conf = 0.95
    sig_lvl = signif_conf(newflux, conf)
    '''
    conf = signif  # The variable conf seems redundant...
    sig_lvl = signif_conf(newflux, signif)

    if norm:
        var = np.var(newflux)
        power = power * (N/var)
        sig_lvl = sig_lvl * (N/var)
        print "White noise has an expectation value of 1"

    if display:
        if sig_lvl != 0:
            print ("Confidence level at " + str(int(conf*100)) +
                   " is: " + str(sig_lvl))
        fig = plt.figure()
        ax = fig.add_subplot(111)
        ax.plot(Freq, Power)
        ax.plot(Freq, Power, '.')
        # horline, sig_lvl .... ?
        plt.show()

    '''
    The final output is an array containing the power and phase at each frequency
    '''
    Result = np.zeros(Power.size, 4)
    Result[:,0] = Freq
    Result[:,1] = Power
    Result[:,2] = Phase
    Result[:,3] = Amplitude
    print "Result[:,0] is frequency"
    print "Result[:,1] is the power spectrum"
    print "Result[:,2] is the phase"

    return Result

f = np.array([1, 3, 4, 5, 3, 2, 6, 4, 3, 4, 1])
blah = fourier2(f, 1)
