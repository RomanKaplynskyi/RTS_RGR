import random
import math


def generateRandomSignal(harmonicsAmount, frequency, N):
    signal = [0] * N
    Wm = frequency / harmonicsAmount
    for harmonic in range(0, harmonicsAmount):
        Ap = random.random() # Генеруємо випадкову амплітуду
        FIp = random.random() # Генеруємо випадкову фазу
        for t in range(N): # Знаходимо суму
            signal[t] += Ap * math.sin(Wm * t + FIp)
        Wm += Wm # Переходимо до наступної частотної складової
    return signal
