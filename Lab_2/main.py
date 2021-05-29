import matplotlib.pyplot as plt                 # Для створення та відображення графіків
import numpy as numpy
from signalGenerator import generateRandomSignal
from fourie import dft_f, fft_f

n = 8                                           # Число гармонік в сигналі
W = 2000                                        # Гранична частота
N = 256                                         # Кількість дискретних відліків

N_addTask = [4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096]
figNames = ['randomSignal2', 'randomSignal3', 'randomSignal4', 'randomSignal5', 'randomSignal6', 'randomSignal7', 'randomSignal8', 'randomSignal9', 'randomSignal10', 'randomSignal11', 'randomSignal12']
figFftNames = ['figFft2', 'figFft3', 'figFft4', 'figFft5', 'figFft6', 'figFft7', 'figFft8', 'figFft9', 'figFft10', 'figFft11', 'figFft12']
figFftNumpyNames = ['figFftNumpy2', 'figFft3Numpy', 'figFftNumpy4', 'figFftNumpy5', 'figFftNumpy6', 'figFftNumpy7', 'figFftNumpy8', 'figFftNumpy9', 'figFftNumpy10', 'figFftNumpy11', 'figFftNumpy12']

N_addTask_len = N_addTask.__len__()
for num in range(N_addTask_len):
    randomSignal = generateRandomSignal(n, W, N_addTask[num])
    time = range(N_addTask[num])
    fig1, plot1 = plt.subplots()
    plot1.plot(randomSignal)
    plot1.set(xlabel='time', ylabel='randomSignal', title='Випадково згенерований сигнал')
    fig1.savefig(figNames[num] + '.png')

    fig2, plot2 = plt.subplots()
    plot2.plot(fft_f(randomSignal))
    plot2.set_xlim(0, int(N_addTask[num] / 4))
    plot2.set(xlabel='time', ylabel='randomSignal', title='Швидке перетворення Фур`є')
    fig2.savefig(figFftNames[num] + '.png')

    fig3, plot3 = plt.subplots()
    plot3.plot([abs(x) for x in numpy.fft.fft(randomSignal)])
    plot3.set_xlim(0, int(N_addTask[num] / 4))
    plot3.set(xlabel='time', ylabel='randomSignal', title='Швидке перетворення Фур`є з Numpy')
    fig3.savefig(figFftNumpyNames[num] + '.png')













