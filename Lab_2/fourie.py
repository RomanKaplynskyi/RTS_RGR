import math


def calcCoef(p, N):
    return complex(math.cos((2 * math.pi * p / N)), math.sin((2 * math.pi * p / N)))


def dft_f(signal):
    N = signal.__len__()
    dft = [0] * N
    for x in range(N):
        for y in range(N):
            dft[x] += complex(math.cos(2.0 * math.pi * x * y / N), -math.sin(2.0 * math.pi * x * y / N)) * signal[y]
    dft = [abs(x) for x in dft]
    return dft


def fft_f(signal):
    N = signal.__len__()
    fft = [0] * N
    half_len = int(N / 2)

    for p in range(half_len):
        func1 = sum([signal[2 * k + 0] * calcCoef(k * p, half_len) for k in range(half_len)])
        func2 = sum([signal[2 * k + 1] * calcCoef(k * p, half_len) for k in range(half_len)])
        fft[p] = func2 + calcCoef(p, N) * func1
        fft[p + half_len] = func2 - calcCoef(p, N) * func1
    fft = [abs(x) for x in fft]
    return fft
