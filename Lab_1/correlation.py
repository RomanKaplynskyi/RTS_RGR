import math
import time


def correlation(N, Mx1, Dx1, randomSignal1, Mx2=None, Dx2=None, randomSignal2=None):
    result = []
    startTime = time.time()
    area = range((N - 1) // 2)
    if randomSignal2 is None:
        randomSignal2 = randomSignal1
        Mx2 = Mx1
        Dx2 = Dx1

    for tau in area:
        cov = 0
        for t in area:
            cov += ((randomSignal1[t] - Mx1) * (randomSignal2[t + tau] - Mx2)) / (N - 1)
        result.append((cov / (math.sqrt(Dx1) * math.sqrt(Dx2))))
    endTime = time.time() - startTime - 1
    return result, endTime
