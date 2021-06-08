from math import exp, factorial
from random import uniform, choice, randint
from Task import Task
import csv
ACCEPT_K = 1
SIZE = 1000
INTERVAL = 0.5
LAMBDA = SIZE/ACCEPT_K*0.01


def round_digits(n):
    return round(number=n, ndigits=4)


def get_density_random(intensity):
    density = exp(-intensity)
    x = 0
    maxDensity = uniform(0, 1)
    while maxDensity > density:
        x += 1
        density += pow(intensity, x) * exp(-intensity) / factorial(x)
    return x


def erlang_tasks_generator(k_value, interval, intensity):
    i = 0
    skipTaskNum = 0
    while True:
        i += 1
        tasks_count = get_density_random(intensity)
        for _ in range(tasks_count):
            arrival = uniform((i - 1) * interval, i * interval)
            executionTime = uniform(0.00001, 0.1)
            deadline = arrival + executionTime * randint(1, 10)
            skipTaskNum += 1
            if skipTaskNum == k_value:
                skipTaskNum = 0
                yield Task(arrival=round_digits(arrival), executionTime=round_digits(executionTime), deadline=round_digits(deadline), priority=randint(1, 10))


def main():
    task_generator = erlang_tasks_generator(ACCEPT_K, INTERVAL, LAMBDA)
    tasks = [next(task_generator) for _ in range(SIZE)]
    writer = csv.writer(open('tasks.csv', 'w', newline=""))
    writer.writerow(['ID', 'Arrival', 'ExecTime', "DeadLine", "priority"])
    for taskID, task in enumerate(tasks):
        writer.writerow([taskID+1, task.arrival, task.executionTime, task.deadline, task.priority])
    print('Tasks was generated!')


main()
