#include<stdio.h>
#include<stdlib.h>


typedef struct queue{
    struct node* head;
    int length;
} Queue;

typedef struct node {
    int priority;
    int burstTime;
    int timeLeft;
    struct node* next;
    struct node* prev;
} Node;

Node* push(Queue* queue, int priority, int burstTime){
    if(queue->head == NULL){
        Node* newNode = (Node*)malloc(sizeof(Node));
        newNode->burstTime = burstTime;
        newNode->timeLeft = burstTime;
        newNode->priority = priority;
        newNode->next = NULL;
        newNode->prev = NULL;
        queue->head = newNode;
        queue->length = 1;
        return newNode;
    }
    Node *node = queue->head;
    while (node != NULL){
        if (priority > node->priority && node->next != NULL) {
            node = node->next;
        } else {
            Node* newNode = (Node*)malloc(sizeof(Node));
            newNode->burstTime = burstTime;
            newNode->priority = priority;
            newNode->timeLeft = burstTime;
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
                node->prev = newNode;
                newNode->next = node;
                newNode->prev = prevNode;
                prevNode->next = newNode;
            }

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

void roundRobin(Queue *queue, int quantum) {
    Node *node = queue->head;
    while (queue->length != 0) {
        node->timeLeft = node->timeLeft - quantum;
        printf("Executed node with burstTime %d and priority: %d \n", node->burstTime, node->priority);
        if(node->timeLeft <= 0) {
            int round = ((node->burstTime % quantum) != 0) ? (node->burstTime / quantum)+1 : (node->burstTime / quantum);
            printf("\tNode with burstTime - %d and priority - %d, done after - %d rounds \n", node->burstTime, node->priority, round);
            Node* poppedNode = pop(queue, node);
            if (queue->length == 0) return;
            node = poppedNode->next == NULL ? queue->head : poppedNode->next;
        } else if (queue->length == 0){
            return;
        } else {
            node = node->next == NULL ? queue->head : node->next;
        }
        printf("\n");
    }

}

int main()
{
    Queue queue = {NULL};
    push(&queue, 1,1);
    push(&queue, 28,4);
    push(&queue, 13,2);
    push(&queue, 31,6);
    push(&queue, 7,8);
    push(&queue, 21,9);
    push(&queue, 9,3);
    push(&queue, 2,7);

    roundRobin(&queue, 3);
}