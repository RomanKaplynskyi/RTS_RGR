import matplotlib.pyplot as plt
import json

QUANTUM = 3


def parseJson(text):
    return json.loads(text)


def main():
    data = None
    with open('results.txt') as file:
        buildPlot(parseJson(file.read()))


def buildPlot(data):

    avgTime = {"id": [], 'avgWaitTimeOnAppend': [], 'waitTime': []}
    avgWaitTimeOnAppend = sorted(data, key=lambda item: item['avgWaitTimeOnAppend'], reverse=False)
    waitTimes = []
    idle = [(process['totalWaitTime'] - process['processed']) / process['totalWaitTime'] for process in data]
    #idle = [(process['totalWaitTime'] - process['waitTime']) / process['totalWaitTime'] for process in data]
    processes = [process['processes'] for process in data]

    for item in avgWaitTimeOnAppend:
        if item['avgWaitTimeOnAppend'] not in avgTime['avgWaitTimeOnAppend']:
            avgTime['id'].append(item['id'])
            avgTime['avgWaitTimeOnAppend'].append(item['avgWaitTimeOnAppend'])
            avgTime['waitTime'].append(item['waitTime'])

    for process in data:
        if process['id'] == max(avgTime['id']):
            waitTimes.append(process['waitTime'])
            break
        waitTimes.append(process['waitTime'])

    plt.plot(list(range(1, len(avgTime['id']) + 1)), avgTime['avgWaitTimeOnAppend'])
    plt.xlabel("Інтенсивність вхідного потоку")
    plt.ylabel("Середній час очіквання")
    plt.title("Графік залежності середнього часу очікування від інтенсивночті входного потоку")
    plt.figure()

    plt.plot(list(reversed(processes)), list(idle))
    plt.ylabel("Процент простою")
    plt.xlabel("Інтенсивність вхідного потоку")
    plt.title("Графік залежності проценту простою від інтенсивночті входного потоку")
    plt.figure()

    plt.plot(list( range(1, max(avgTime['id']) + 1) ), waitTimes)
    plt.xlabel("Пріорітет")
    plt.ylabel("Середній час очіквання")
    plt.title("Графік залежності середнього часу очікування від пріорітету")

    plt.show()


if __name__ == '__main__':
    main()
