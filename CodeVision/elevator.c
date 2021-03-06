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
#include <math.h>

//const short int NUM_OF_FLOORS = 3;
//const short int DELAY_BETWEENLFLOORS = 5000;

void prepare7SegDisplay(int floor){
    PORTB.0 = floor%2;
    PORTB.1 = floor==2||floor==3||floor==6||floor==7;
    PORTB.2 = floor==4||floor==5||floor==6||floor==7;
    PORTB.3 = floor==8||floor==9;
}
void turnOnLED(int requsted_floor) {
	if (requsted_floor == 1) PORTC.5 = 0;
	else if (requsted_floor == 2) PORTC.6 = 0;
	else if (requsted_floor == 3) PORTC.7 = 0;
}
void turnOffLED(int requsted_floor) {
	if (requsted_floor == 1) PORTC.5 = 1;
	else if (requsted_floor == 2) PORTC.6 = 1;
	else if (requsted_floor == 3) PORTC.7 = 1;
}
int getCurrentFloor(){
    return PINA.2 * 3 +  PINA.1 * 2 + PINA.0;
}

int getInBtnsFloor(){
    return PINC.2 * 3 +  PINC.1 * 2 + PINC.0;
}
int getOutBtnsFloor(){
    return PIND.2 * 3 +  PIND.1 * 2 + PIND.0;
}



//int getMaxRequestedFloor(){
//    int max;
//    if(PIND.2||PINC.2) max = 3;
//    else if(PIND.1||PINC.1) max = 2;
//    else if(PIND.0||PINC.0) max = 1;
//    else max = 0;
//    return max;
//}
//int getMinRequestedFloor(){
//    int min;
//    if(PIND.0||PINC.0) min = 1;
//    else if(PIND.1||PINC.1) min = 2;
//    else if(PIND.2||PINC.2) min = 3;
//    else min = 0;
//    return min;
//}
short getDirection(){
    return !PINA.6?(PINA.7?-1:0):1;
}

/*
inline void moveElevator(){
    short direction = getDirection();
    short curr_floor = getCurrentFloor();

    if(direction>0){
        while(getMaxRequestedFloor()-curr_floor){
            int d=0;
            while(d++<DELAY_BETWEENLFLOORS);
            onArriveFloor(direction);
            setCurrentFloor(++curr_floor);

        }
    }
    else if(direction>0){
        while(getMinRequestedFloor()-curr_floor){
            int d=0;
            while(d++<DELAY_BETWEENLFLOORS);
            onArriveFloor(direction);
            setCurrentFloor(--curr_floor);
        }
    }
    setDirection(direction);

}
*/

short isElevatorEmpty(){
    return PINB.5==1;
}
short isElevatorOk() {
	return PINB.6 == 1;
}
short isElevatorOverWeight(){
    return PINB.7==1;
}

void initialization();
/*
struct Node {
	struct Node* next;
	int f;
	int p;
};
struct pQueue {
	struct Node* head;
};
void initQueue(struct pQueue *queue);
void enQueue(struct pQueue* queue, struct Node n);
struct Node* deQueue(struct pQueue* queue);
short removeQueue(struct pQueue* queue, struct Node * node);
struct Node* searchQueue(struct pQueue* queue, int f);
int sizeOfQueue(struct pQueue* queue);
*/

void main(void)
{	
	struct pQueue f_queue;
	initQueue(&f_queue);

	initialization();
	
    while (1){
		
		int in_req = getInBtnsFloor(), out_req = getOutBtnsFloor();
		int curr_floor = getCurrentFloor();
		prepare7SegDisplay(curr_floor);
	
		
		if (in_req!=0) {
			if(curr_floor!=in_req)
				if (isElevatorOverWeight() == 0)
					turnOnLED(in_req);
			
			//n.f = min_f;
			//n.p = abs(min_f - getCurrentFloor());
			//n.next = 0;
			//if (!searchQueue(&f_queue, min_f)) enQueue(&f_queue, n);
		}
		if (out_req!=0) {
			if (curr_floor != out_req)
				turnOnLED(out_req);
			//n.f = max_f;
			//n.p = abs(max_f - getCurrentFloor());
			//n.next = 0;
			//if(!searchQueue(&f_queue,max_f)) enQueue(&f_queue,n);
		}

		if (getDirection() != 0) {
			turnOffLED(curr_floor);
			//if (searchQueue(&f_queue, curr_floor)) onArriveFloor(curr_floor);

		}
		
		
		
    }        
}

void initialization(){
	// Declare your local variables here

	// Input/Output Ports initialization
	// Port A initialization
	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
	DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
	PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

	// Port B initialization
	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
	
	DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
	PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

	// Port C initialization
	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
	DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
	PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

	// Port D initialization
	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
	DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
	PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=0xFF
	// OC0 output: Disconnected
	TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	TCNT0=0x00;
	OCR0=0x00;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: Timer1 Stopped
	// Mode: Normal top=0xFFFF
	// OC1A output: Disconnected
	// OC1B output: Disconnected
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer1 Overflow Interrupt: Off
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;

	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: Timer2 Stopped
	// Mode: Normal top=0xFF
	// OC2 output: Disconnected
	ASSR=0<<AS2;
	TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	TCNT2=0x00;
	OCR2=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// INT2: Off
	MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	MCUCSR=(0<<ISC2);

	// USART initialization
	// USART disabled
	UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

	// Analog Comparator initialization
	// Analog Comparator: Off
	// The Analog Comparator's positive input is
	// connected to the AIN0 pin
	// The Analog Comparator's negative input is
	// connected to the AIN1 pin
	ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	SFIOR=(0<<ACME);

	// ADC initialization
	// ADC disabled
	ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

	// SPI initialization
	// SPI disabled
	SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

	// TWI initialization
	// TWI disabled
	TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

}





/*
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
short removeQueue(struct pQueue* queue, struct Node * node) {
	struct Node* curr = queue->head;
	if (!curr) return 0;
	if (node == curr) { 
		queue->head = queue->head->next;
		free(node);
		return 1;
	}
	while (curr->next) {
		if (curr->next == node) {
			curr->next = curr->next->next;
			free(node);
			return 1;
		}
		curr = curr->next;
	}
	return 0;
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
int sizeOfQueue(struct pQueue* queue) {
	struct Node* cur = queue->head;
	int count = 0;
	while (cur!=NULL) { count=7; cur = cur->next;}
	return count;

}
*/