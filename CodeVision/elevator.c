/*
 * test1.c
 *
 * Created: 3/8/2019 11:24:16 AM
 * Author: Mohammad Amin
 */

#include <io.h>
#include <mega16.h>
#include <delay.h>
#include <stdlib.h>

const short int NUM_OF_FLOORS = 3;
const short int DELAY_BETWEENLFLOORS = 5000;
const short int MAX_QUEUE_SIZE = 100;

void prepare7SegDisplay(unsigned char* bcd[],unsigned char* f[]){
    *bcd[0] = *f[0] || *f[2];
    *bcd[1] = *f[1] || *f[2];
    *bcd[2] = 0;
    *bcd[3] = 0;
}
int getFloor(unsigned char* f[]){
    return *f[2] * 3 + *f[1] * 2 + *f[0] * 1;
}
void setFloor(int floor,unsigned char* f[]){
    *f[0]=*f[1]=*f[2] = 0;
    *f[0] = floor==1;
    *f[1] = floor==2;
    *f[2] = floor==3;
}
void moveElevator(int target_floor,unsigned char* up_state,unsigned char* down_state,unsigned char* curr_floor[],unsigned char* bcd[]){
    int curr_flr_int = getFloor(curr_floor);
    if(target_floor==curr_flr_int) return;

    if(target_floor>curr_flr_int){*up_state=1,*down_state=0;}
    else {*up_state=0,*down_state=1;}
    delay_ms(DELAY_BETWEENLFLOORS);
    setFloor(target_floor,curr_floor);
    prepare7SegDisplay(bcd,curr_floor);

}

struct Node {
    struct Node* next;
    int f;
    int p;
};
struct pQueue{
    struct Node* head;
};
void initQueue(struct pQueue *queue){
    queue->head = 0;
}

void enQueue(struct pQueue* queue, struct Node n){
    struct Node* curr = queue->head;
    struct Node* node = (struct Node*)malloc(sizeof(n));
    node->f = n.f;
    node->p = n.p;
    node->next = 0;
    if(!queue->head){
        queue->head = node;
        return;
    }
    if(node->p < queue->head->p){
        node->next = queue->head;
        queue->head = node;
        return;
    }
    if(!queue->head->next){
        queue->head->next = node;
        return;
    }
    while (curr->next->next){
        if(node->p < curr->next->p){
            node->next = curr->next;
            curr->next = node;
            return;
        }
        curr = curr->next;
    }
    curr->next->next = node;

}
struct Node* deQueue(struct pQueue* queue){
    struct Node* temp = queue->head;
    if(!temp) return 0;
    queue->head = queue->head->next;
    return temp;
}

struct Node* searchQueue(struct pQueue* queue,int f){
    struct Node* curr = queue->head;
    if(!curr) return 0;
    while(curr->next && curr->f != f) curr = curr->next;
    return (curr->f==f)?curr:0;

}


void main(void)
{
    struct pQueue queue;
    unsigned char* is_up;
    unsigned char* is_down;
    unsigned char* is_empty;    
    unsigned char* is_notempty;
    unsigned char* is_overweight;
    unsigned char* elev_floors[NUM_OF_FLOORS];
    unsigned char* in_btns[NUM_OF_FLOORS];
    unsigned char* out_btns[NUM_OF_FLOORS];
    unsigned char* bcd_7seg_ins[4];

    initQueue(&queue);

    DDRA = 0b11110011;
    DDRB = 0b00000111;
    DDRC = 0b00000000;
    DDRD = 0b00000000;
    
    is_up = &PINA.0;
    is_down = &PINA.1;

    bcd_7seg_ins[0] = &PORTA.4;
    bcd_7seg_ins[1] = &PORTA.5;
    bcd_7seg_ins[2] = &PORTA.6;
    bcd_7seg_ins[3] = &PORTA.7;

    is_empty = &PINB.5;
    is_notempty = &PINB.6;
    is_overweight = &PINB.7;
    
//    elev_floors[0] = &PINB.0;
//    elev_floors[1] = &PINB.1;
//    elev_floors[2] = &PINB.2;
    elev_floors[0] = &PORTB.0;
    elev_floors[1] = &PORTB.1;
    elev_floors[2] = &PORTB.2;
    
    in_btns[0] = &PINC.0;
    in_btns[1] = &PINC.1;
    in_btns[2] = &PINC.2;
    
    out_btns[0] = &PIND.0;
    out_btns[1] = &PIND.1;
    out_btns[2] = &PIND.2;


    //Initial state:
    *is_down = 0;
    *is_up = 0;
    *is_empty = 1;
    *is_notempty = 0;
    *is_overweight = 0;
    *elev_floors[0] = 1;
    *elev_floors[1] = 0;
    *elev_floors[2] = 0;


    
    while (1)
    {             
        int cur_floor = getFloor(elev_floors);
        int i,o;
        prepare7SegDisplay(bcd_7seg_ins,elev_floors);
        if(!(i=getFloor(in_btns))||!(o=getFloor(out_btns))){
            if(i!=cur_floor){
                struct Node n;
                n.f = i;
                n.p = abs(i-cur_floor);
                if(!searchQueue(&queue,i)) enQueue(&queue,n);
            }
            if(o!=cur_floor){
                struct Node n;
                n.f = o;
                n.p = abs(o-cur_floor);
                if(!searchQueue(&queue,o)) enQueue(&queue,n);
            }
        }
        if(queue.head){
            moveElevator(deQueue(&queue)->f,is_up,is_down,elev_floors,bcd_7seg_ins);

        }
    }        
}
