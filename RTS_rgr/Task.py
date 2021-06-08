from dataclasses import dataclass


@dataclass
class Task:
    arrival: float
    executionTime: float
    deadline: float
    priority: int
