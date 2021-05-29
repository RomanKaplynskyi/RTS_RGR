import matplotlib.pyplot as plt                 # Для створення та відображення графіків
import numpy                                    # Для проведення математичних операцій
from signalGenerator import generateRandomSignal
import correlation

n = 8                                           # Число гармонік в сигналі
W = 2000                                        # Гранична частота
N = 256                                         # Кількість дискретних відліків

randomSignal = generateRandomSignal(n, W, N)
Mx = numpy.mean(randomSignal)
Dx = numpy.var(randomSignal)
print("Мат. очікуваання", numpy.mean(randomSignal))  # Вбудована в numpy функція для обчислення Мат. очікування
print("Дисперсія", numpy.var(randomSignal))     # Вбудована в numpy функція для обчислення Дисперсії

autoCorr = correlation.correlation(N, Mx, Dx, randomSignal)[0]
numpyAutoCorrelation = numpy.correlate(randomSignal, randomSignal, "same")
print("numpyAutoCorrelation", numpyAutoCorrelation)

plt.figure(1)
plt.title("AutoCorrelation")
plt.plot(list(range(len(autoCorr))), autoCorr)
plt.savefig("AutoCorrelation.png")
plt.close(1)

plt.figure(1)
plt.title("numpyAutoCorrelation")
plt.plot(list(range(len(numpyAutoCorrelation))), numpyAutoCorrelation)
plt.savefig("numpyAutoCorrelation.png")
plt.close(1)

randomSignal2 = generateRandomSignal(n, W, N)
Mx2 = numpy.mean(randomSignal2)
Dx2 = numpy.var(randomSignal2)
interCorr = correlation.correlation(N, Mx, Dx, randomSignal, Mx2, Dx2, randomSignal2)[0]
numpyInterCorrelation = numpy.correlate(randomSignal, randomSignal2, "same")

plt.figure(2)
plt.title("InterCorrelation")
plt.plot(list(range(len(interCorr))), interCorr)
plt.savefig("InterCorrelation.png")
plt.close(2)

plt.figure(2)
plt.title("numpyInterCorrelation")
plt.plot(list(range(len(numpyInterCorrelation))), numpyInterCorrelation)
plt.savefig("numpyInterCorrelation.png")
plt.close(2)

time = range(N)
plotImg, plot1 = plt.subplots()
plot1.plot(randomSignal)
plot1.set(xlabel='time', ylabel='randomSignal', title='Випадково згенеровані сигнали')
plotImg.savefig("randomSignal.png")
