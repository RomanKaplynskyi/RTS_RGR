#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define QUANTUM 0.05



typedef struct queue{
    struct node* head;
    int length;
    int lastID;
    int processed;
    long double waitTimeSum;
} Queue;

typedef struct node {
    int priority;
    float burstTime;
    float timeLeft;
    float deadline;
    int id;
    long double avgWaitTimeOnAppend;
    struct node* next;
    struct node* prev;
} Node;

long double getWaitTime (Node* node) {
    long double res = 0;
    while (node != NULL){
        res += node->timeLeft;
        node = node->prev;
        if (node == NULL) return res;
    }
    return res;
}

Node* push(Queue* queue, int priority, float burstTime, float deadline){
    if(queue->head == NULL){

        Node* newNode = (Node*)malloc(sizeof(Node));
        newNode->burstTime = burstTime;
        newNode->timeLeft = burstTime;
        newNode->deadline = deadline;
        newNode->priority = priority;
        newNode->next = NULL;
        newNode->prev = NULL;
        newNode->id = 1;
        newNode->avgWaitTimeOnAppend = 0;

        queue->head = newNode;
        queue->length = 1;
        queue->lastID = 1;
        queue->waitTimeSum = 0;
        queue->processed = 0;

        return newNode;
    }
    Node *node = queue->head;
    while (node != NULL){
        if (priority > node->priority && node->next != NULL) {
            node = node->next;
        } else {
            Node* newNode = (Node*)malloc(sizeof(Node));
            newNode->burstTime = burstTime;
            newNode->deadline = deadline;
            newNode->priority = priority;
            newNode->timeLeft = burstTime;
            newNode->id = queue->lastID + 1;

            queue->lastID = queue->lastID + 1;
            queue->waitTimeSum += burstTime;

            if (node->prev == NULL && node->priority > priority) {
                newNode->next = node;
                node->prev = newNode;
                newNode->prev = NULL;
                queue->head = newNode;
            } else if (node->next == NULL && node->priority < priority) {
                newNode->prev = node;
                node->next = newNode;
                newNode->next = NULL;
            } else {
                Node* prevNode = node->prev;
                if (prevNode == NULL) {
                    prevNode = (Node*) malloc(sizeof(Node));
                    prevNode->burstTime = burstTime;
                    prevNode->priority = priority;
                    prevNode->deadline = deadline;
                    prevNode->prev = NULL;
                }
                node->prev = newNode;
                newNode->next = node;
                newNode->prev = prevNode;
                prevNode->next = newNode;
            }
            newNode->avgWaitTimeOnAppend = getWaitTime(node) / queue->lastID;

            queue->length++;
            return newNode;
        }
    }
    return NULL;
}

Node* pop (Queue* queue,Node* node) {
    if (node->next == NULL && node->prev == NULL) {
        queue->length = 0;
        queue->head = NULL;
        return NULL;
    }
    Node* nextNode = node->next;
    Node* prevNode = node->prev;

    if (prevNode == NULL) {
        queue->head = nextNode;
        nextNode->prev = NULL;
        queue->length--;
        return node;
    }

    if (nextNode == NULL) {
        prevNode->next = NULL;
        queue->length--;
        return node;
    }

    prevNode->next = nextNode;

    if (nextNode != NULL)
        nextNode->prev = prevNode;
    queue->length--;
    return node;
}

void roundRobin(Queue *queue, float quantum, FILE* file) {
    int counterTask = 0;
    float counterTime = 0;

    Node *node = queue->head;
    while (queue->length != 0) {
        counterTime++;
        node->timeLeft = node->timeLeft - quantum;
        if(node->timeLeft <= 0) {
            printf("\tTask with ID - %d and burstTime - %f and priority - %d and deadline - %f was done after %f\n", node->id ,node->burstTime, node->priority, node->deadline, counterTime*quantum); //, round);
            if (node->deadline < counterTime*quantum) {
                counterTask++;
             }
            Node* poppedNode = pop(queue, node);
            if (queue->length == 0) return;
            node = poppedNode->next == NULL ? queue->head : poppedNode->next;
        } else if (queue->length == 0){
            return;
        } else {
            node = node->next == NULL ? queue->head : node->next;
        }
        if (queue->length <= 1 ) {
            printf("Task was expired - %d\n", counterTask);
        }


    }

}

const char* getfield(char* line, int num)
{
    const char* tok;
    for (tok = strtok(line, ",");
         tok && *tok;
         tok = strtok(NULL, ",\n"))
    {
        if (!--num)
            return tok;
    }
    return NULL;
}

void getTasks(char* fileName, struct node *nodes) {
    FILE* stream = fopen(fileName, "r");
    int BURST_TIME = 3;
    int PRIORITY = 5;
    int DEADLINE = 4;
    char line[200];
    int counter = 0;
    fgets(line, 200, stream);
    while (fgets(line, 200, stream))
    {
        char* tmp = strdup(line);
        char* tmp1 = strdup(line);
        char* tmp2 = strdup(line);
        const char *burstTime = getfield(tmp, BURST_TIME);
        const char *priority = getfield(tmp1, PRIORITY);
        const char *deadline = getfield(tmp2, DEADLINE);
        nodes[counter].priority = atoi(priority);
        nodes[counter].burstTime = atof(burstTime);
        nodes[counter].deadline = atof(deadline);
        free(tmp);
        counter++;
    }
}

int main()
{
    Queue queue = {NULL};
    struct node nodes[2000];
    getTasks("tasks.csv", nodes);
    for (int i = 0; i < 1001; ++i) {
        push(&queue, nodes[i].priority, nodes[i].burstTime, nodes[i].deadline);
    }
    roundRobin(&queue, QUANTUM, NULL);

}