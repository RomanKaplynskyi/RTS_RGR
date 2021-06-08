import random
import csv


class Task:
    def __init__(self, ID, deadLine, executionTime) -> None:
        self.ID = ID
        self.deadLine = deadLine
        self.executionTime = executionTime

    def reduceDeadLine(self, number):
        self.deadLine -= number

    def __str__(self):
        return f"Task {{ ID: {self.ID}, executionTime: {self.executionTime}, deadLine: {self.deadLine} }}"

    def __repr__(self):
        return f"Task {{ ID: {self.ID}, executionTime: {self.executionTime}, deadLine: {self.deadLine} }}"


class Processor:
    def __init__(self) -> None:
        self.tasks = []  # Task array
        self.expiredDeadLine = []
        self.timeCounter = 0

    def addTask(self, task: Task) -> None:
        self.tasks.append(task)

    def addRange(self, tasks: list[Task]):
        self.tasks += tasks

    def execute(self):
        taskListLen = self.tasks.__len__()
        while self.tasks.__len__():
            earliestTask = self.findEarliestDeadLine()
            print(f"Execute task with id {earliestTask.ID}")
            self.tasks.remove(earliestTask)
            for task in self.tasks:
                task.reduceDeadLine(earliestTask.executionTime)
                self.timeCounter += earliestTask.executionTime
                if task.deadLine <= 0 and task not in self.expiredDeadLine:
                    self.expiredDeadLine.append(task)
        print(f"Avg waiting time: {self.timeCounter/taskListLen}")

    def findEarliestDeadLine(self) -> Task:
        closestToDeadLineTask = self.tasks[0]
        for task in self.tasks:
            if (task.deadLine < closestToDeadLineTask.deadLine): closestToDeadLineTask = task
        return closestToDeadLineTask


def appendTaskThread(processor):
    for i in range(6):
        processor.addTask(Task(i + 1, random.randint(0, 25), random.randint(0, 15)))


def readTasksFromFile(filename):
    # ID, Arrival, ExecTime, DeadLine, priority
    ID = 0
    EXEC_TIME = 2
    DEADLINE = 3
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        next(reader)
        return [Task(int(row[ID]), float(row[DEADLINE]), float(row[EXEC_TIME])) for row in reader]


def main():
    processor = Processor()
    # thread = threading.Thread(target=appendTaskThread, args=(processor,))
    # executor = threading.Thread(target=processor.execute)
    # thread.start()
    # executor.start()
    # thread.join()
    # executor.join()
    tasks = readTasksFromFile('../tasks.csv')
    processor.addRange(tasks)
    print("Tasks")
    print(processor.tasks)
    processor.execute()

    print(f"Expired tasks")
    print(f"Expired tasks count: {processor.expiredDeadLine.__len__()}")
    print(processor.expiredDeadLine)


if __name__ == '__main__':
    main()