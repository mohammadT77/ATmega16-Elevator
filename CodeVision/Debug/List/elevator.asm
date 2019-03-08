
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x3
_0x4:
	.DB  0x88,0x13
_0x5:
	.DB  0x64
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*
; * test1.c
; *
; * Created: 3/8/2019 11:24:16 AM
; * Author: Mohammad Amin
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <mega16.h>
;#include <delay.h>
;#include <stdlib.h>
;
;const short int NUM_OF_FLOORS = 3;

	.DSEG
;const short int DELAY_BETWEENLFLOORS = 5000;
;const short int MAX_QUEUE_SIZE = 100;
;
;void prepare7SegDisplay(unsigned char* bcd[],unsigned char* f[]){
; 0000 0011 void prepare7SegDisplay(unsigned char* bcd[],unsigned char* f[]){

	.CSEG
_prepare7SegDisplay:
; .FSTART _prepare7SegDisplay
; 0000 0012     *bcd[0] = *f[0] || *f[2];
	ST   -Y,R27
	ST   -Y,R26
;	bcd -> Y+2
;	f -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R0,X+
	LD   R1,X
	CALL SUBOPT_0x0
	LD   R30,Z
	CPI  R30,0
	BRNE _0x6
	CALL SUBOPT_0x1
	BRNE _0x6
	LDI  R30,0
	RJMP _0x7
_0x6:
	LDI  R30,1
_0x7:
	MOVW R26,R0
	ST   X,R30
; 0000 0013     *bcd[1] = *f[1] || *f[2];
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	__GETWRZ 0,1,2
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	CALL __GETW1P
	LD   R30,Z
	CPI  R30,0
	BRNE _0x8
	CALL SUBOPT_0x1
	BRNE _0x8
	LDI  R30,0
	RJMP _0x9
_0x8:
	LDI  R30,1
_0x9:
	MOVW R26,R0
	ST   X,R30
; 0000 0014     *bcd[2] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0015     *bcd[3] = 0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,6
	CALL __GETW1P
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0016 }
	RJMP _0x2080004
; .FEND
;int getFloor(unsigned char* f[]){
; 0000 0017 int getFloor(unsigned char* f[]){
_getFloor:
; .FSTART _getFloor
; 0000 0018     return *f[2] * 3 + *f[1] * 2 + *f[0] * 1;
	ST   -Y,R27
	ST   -Y,R26
;	f -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	CALL __GETW1P
	LD   R26,Z
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOVW R22,R0
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	CALL __GETW1P
	LD   R26,Z
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	CALL SUBOPT_0x0
	LD   R26,Z
	LDI  R30,LOW(1)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
	RJMP _0x2080001
; 0000 0019 }
; .FEND
;void setFloor(int floor,unsigned char* f[]){
; 0000 001A void setFloor(int floor,unsigned char* f[]){
_setFloor:
; .FSTART _setFloor
; 0000 001B     *f[0]=*f[1]=*f[2] = 0;
	ST   -Y,R27
	ST   -Y,R26
;	floor -> Y+2
;	f -> Y+0
	CALL SUBOPT_0x0
	PUSH R31
	PUSH R30
	LD   R30,Y
	LDD  R31,Y+1
	__GETWRZ 0,1,2
	LDD  R26,Z+4
	LDD  R27,Z+5
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R26,R0
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
; 0000 001C     *f[0] = floor==1;
	LD   R26,Y
	LDD  R27,Y+1
	LD   R0,X+
	LD   R1,X
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2
; 0000 001D     *f[1] = floor==2;
	__GETWRZ 0,1,2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2
; 0000 001E     *f[2] = floor==3;
	__GETWRZ 0,1,4
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOVW R26,R0
	ST   X,R30
; 0000 001F }
	RJMP _0x2080004
; .FEND
;void moveElevator(int target_floor,unsigned char* up_state,unsigned char* down_state,unsigned char* curr_floor[],unsigne ...
; 0000 0020 void moveElevator(int target_floor,unsigned char* up_state,unsigned char* down_state,unsigned char* curr_floor[],unsigned char* bcd[]){
_moveElevator:
; .FSTART _moveElevator
; 0000 0021     int curr_flr_int = getFloor(curr_floor);
; 0000 0022     if(target_floor==curr_flr_int) return;
	CALL SUBOPT_0x3
;	target_floor -> Y+10
;	*up_state -> Y+8
;	*down_state -> Y+6
;	curr_floor -> Y+4
;	bcd -> Y+2
;	curr_flr_int -> R16,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _getFloor
	MOVW R16,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R16,R26
	CPC  R17,R27
	BRNE _0xA
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080007
; 0000 0023 
; 0000 0024     if(target_floor>curr_flr_int){*up_state=1,*down_state=0;}
_0xA:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R16,R26
	CPC  R17,R27
	BRGE _0xB
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(1)
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	RJMP _0x2A
; 0000 0025     else {*up_state=0,*down_state=1;}
_0xB:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1)
_0x2A:
	ST   X,R30
; 0000 0026     delay_ms(DELAY_BETWEENLFLOORS);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0027     setFloor(target_floor,curr_floor);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _setFloor
; 0000 0028     prepare7SegDisplay(bcd,curr_floor);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL _prepare7SegDisplay
; 0000 0029 
; 0000 002A }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2080007
; .FEND
;
;struct Node {
;    struct Node* next;
;    int f;
;    int p;
;};
;struct pQueue{
;    struct Node* head;
;};
;void initQueue(struct pQueue *queue){
; 0000 0034 void initQueue(struct pQueue *queue){
_initQueue:
; .FSTART _initQueue
; 0000 0035     queue->head = 0;
	ST   -Y,R27
	ST   -Y,R26
;	*queue -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0036 }
	RJMP _0x2080001
; .FEND
;
;void enQueue(struct pQueue* queue, struct Node n){
; 0000 0038 void enQueue(struct pQueue* queue, struct Node n){
_enQueue:
; .FSTART _enQueue
; 0000 0039     struct Node* curr = queue->head;
; 0000 003A     struct Node* node = (struct Node*)malloc(sizeof(n));
; 0000 003B     node->f = n.f;
	CALL __SAVELOCR4
;	*queue -> Y+10
;	n -> Y+4
;	*curr -> R16,R17
;	*node -> R18,R19
	CALL SUBOPT_0x4
	MOVW R16,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	CALL _malloc
	MOVW R18,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	__PUTW1RNS 18,2
; 0000 003C     node->p = n.p;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__PUTW1RNS 18,4
; 0000 003D     node->next = 0;
	MOVW R26,R18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 003E     if(!queue->head){
	CALL SUBOPT_0x4
	SBIW R30,0
	BRNE _0xD
; 0000 003F         queue->head = node;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X+,R18
	ST   X,R19
; 0000 0040         return;
	RJMP _0x2080005
; 0000 0041     }
; 0000 0042     if(node->p < queue->head->p){
_0xD:
	MOVW R30,R18
	__GETWRZ 0,1,4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRGE _0xE
; 0000 0043         node->next = queue->head;
	CALL SUBOPT_0x4
	MOVW R26,R18
	ST   X+,R30
	ST   X,R31
; 0000 0044         queue->head = node;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X+,R18
	ST   X,R19
; 0000 0045         return;
	RJMP _0x2080005
; 0000 0046     }
; 0000 0047     if(!queue->head->next){
_0xE:
	CALL SUBOPT_0x4
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BRNE _0xF
; 0000 0048         queue->head->next = node;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP _0x2080006
; 0000 0049         return;
; 0000 004A     }
; 0000 004B     while (curr->next->next){
_0xF:
_0x10:
	MOVW R26,R16
	CALL __GETW1P
	MOVW R26,R30
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x12
; 0000 004C         if(node->p < curr->next->p){
	MOVW R30,R18
	__GETWRZ 0,1,4
	MOVW R26,R16
	CALL __GETW1P
	CALL SUBOPT_0x5
	BRGE _0x13
; 0000 004D             node->next = curr->next;
	MOVW R26,R16
	CALL __GETW1P
	MOVW R26,R18
	ST   X+,R30
	ST   X,R31
; 0000 004E             curr->next = node;
	MOVW R30,R18
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
; 0000 004F             return;
	RJMP _0x2080005
; 0000 0050         }
; 0000 0051         curr = curr->next;
_0x13:
	MOVW R26,R16
	LD   R16,X+
	LD   R17,X
; 0000 0052     }
	RJMP _0x10
_0x12:
; 0000 0053     curr->next->next = node;
	MOVW R26,R16
_0x2080006:
	CALL __GETW1P
	ST   Z,R18
	STD  Z+1,R19
; 0000 0054 
; 0000 0055 }
_0x2080005:
	CALL __LOADLOCR4
_0x2080007:
	ADIW R28,12
	RET
; .FEND
;struct Node* deQueue(struct pQueue* queue){
; 0000 0056 struct Node* deQueue(struct pQueue* queue){
_deQueue:
; .FSTART _deQueue
; 0000 0057     struct Node* temp = queue->head;
; 0000 0058     if(!temp) return 0;
	CALL SUBOPT_0x3
;	*queue -> Y+2
;	*temp -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x14
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080003
; 0000 0059     queue->head = queue->head->next;
_0x14:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R26,R30
	CALL __GETW1P
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X+,R30
	ST   X,R31
; 0000 005A     return temp;
	MOVW R30,R16
_0x2080003:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2080004:
	ADIW R28,4
	RET
; 0000 005B }
; .FEND
;
;struct Node* searchQueue(struct pQueue* queue,int f){
; 0000 005D struct Node* searchQueue(struct pQueue* queue,int f){
_searchQueue:
; .FSTART _searchQueue
; 0000 005E     struct Node* curr = queue->head;
; 0000 005F     if(!curr) return 0;
	CALL SUBOPT_0x3
;	*queue -> Y+4
;	f -> Y+2
;	*curr -> R16,R17
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x15
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2080002
; 0000 0060     while(curr->next && curr->f != f) curr = curr->next;
_0x15:
_0x16:
	MOVW R26,R16
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x19
	CALL SUBOPT_0x6
	BRNE _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	MOVW R26,R16
	LD   R16,X+
	LD   R17,X
	RJMP _0x16
_0x18:
; 0000 0061 return (curr->f==f)?curr:0;
	CALL SUBOPT_0x6
	BRNE _0x1B
	MOVW R30,R16
	RJMP _0x1C
_0x1B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x1C:
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0000 0062 
; 0000 0063 }
; .FEND
;
;
;void main(void)
; 0000 0067 {
_main:
; .FSTART _main
; 0000 0068     struct pQueue queue;
; 0000 0069     unsigned char* is_up;
; 0000 006A     unsigned char* is_down;
; 0000 006B     unsigned char* is_empty;
; 0000 006C     unsigned char* is_notempty;
; 0000 006D     unsigned char* is_overweight;
; 0000 006E     unsigned char* elev_floors[NUM_OF_FLOORS];
; 0000 006F     unsigned char* in_btns[NUM_OF_FLOORS];
; 0000 0070     unsigned char* out_btns[NUM_OF_FLOORS];
; 0000 0071     unsigned char* bcd_7seg_ins[4];
; 0000 0072 
; 0000 0073     initQueue(&queue);
	SBIW R28,32
;	queue -> Y+30
;	*is_up -> R16,R17
;	*is_down -> R18,R19
;	*is_empty -> R20,R21
;	*is_notempty -> Y+28
;	*is_overweight -> Y+26
;	elev_floors -> Y+20
;	in_btns -> Y+14
;	out_btns -> Y+8
;	bcd_7seg_ins -> Y+0
	MOVW R26,R28
	ADIW R26,30
	RCALL _initQueue
; 0000 0074 
; 0000 0075     DDRA = 0b11110011;
	LDI  R30,LOW(243)
	OUT  0x1A,R30
; 0000 0076     DDRB = 0b00000111;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0077     DDRC = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0078     DDRD = 0b00000000;
	OUT  0x11,R30
; 0000 0079 
; 0000 007A     is_up = &PINA.0;
	__GETWRN 16,17,57
; 0000 007B     is_down = &PINA.1;
	__GETWRN 18,19,57
; 0000 007C 
; 0000 007D     bcd_7seg_ins[0] = &PORTA.4;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   Y,R30
	STD  Y+1,R31
; 0000 007E     bcd_7seg_ins[1] = &PORTA.5;
	MOVW R30,R28
	ADIW R30,2
	CALL SUBOPT_0x7
; 0000 007F     bcd_7seg_ins[2] = &PORTA.6;
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x7
; 0000 0080     bcd_7seg_ins[3] = &PORTA.7;
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x7
; 0000 0081 
; 0000 0082     is_empty = &PINB.5;
	__GETWRN 20,21,54
; 0000 0083     is_notempty = &PINB.6;
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0000 0084     is_overweight = &PINB.7;
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0000 0085 
; 0000 0086 //    elev_floors[0] = &PINB.0;
; 0000 0087 //    elev_floors[1] = &PINB.1;
; 0000 0088 //    elev_floors[2] = &PINB.2;
; 0000 0089     elev_floors[0] = &PORTB.0;
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 008A     elev_floors[1] = &PORTB.1;
	MOVW R30,R28
	ADIW R30,22
	LDI  R26,LOW(56)
	LDI  R27,HIGH(56)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 008B     elev_floors[2] = &PORTB.2;
	MOVW R30,R28
	ADIW R30,24
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 008C 
; 0000 008D     in_btns[0] = &PINC.0;
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 008E     in_btns[1] = &PINC.1;
	MOVW R30,R28
	ADIW R30,16
	LDI  R26,LOW(51)
	LDI  R27,HIGH(51)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 008F     in_btns[2] = &PINC.2;
	MOVW R30,R28
	ADIW R30,18
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0090 
; 0000 0091     out_btns[0] = &PIND.0;
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0092     out_btns[1] = &PIND.1;
	MOVW R30,R28
	ADIW R30,10
	LDI  R26,LOW(48)
	LDI  R27,HIGH(48)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0093     out_btns[2] = &PIND.2;
	MOVW R30,R28
	ADIW R30,12
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0094 
; 0000 0095 
; 0000 0096     //Initial state:
; 0000 0097     *is_down = 0;
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0098     *is_up = 0;
	MOVW R26,R16
	ST   X,R30
; 0000 0099     *is_empty = 1;
	MOVW R26,R20
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 009A     *is_notempty = 0;
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 009B     *is_overweight = 0;
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	ST   X,R30
; 0000 009C     *elev_floors[0] = 1;
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDI  R30,LOW(1)
	ST   X,R30
; 0000 009D     *elev_floors[1] = 0;
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 009E     *elev_floors[2] = 0;
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	ST   X,R30
; 0000 009F 
; 0000 00A0 
; 0000 00A1 
; 0000 00A2     while (1)
_0x1E:
; 0000 00A3     {
; 0000 00A4         int cur_floor = getFloor(elev_floors);
; 0000 00A5         int i,o;
; 0000 00A6         prepare7SegDisplay(bcd_7seg_ins,elev_floors);
	SBIW R28,6
;	queue -> Y+36
;	*is_notempty -> Y+34
;	*is_overweight -> Y+32
;	elev_floors -> Y+26
;	in_btns -> Y+20
;	out_btns -> Y+14
;	bcd_7seg_ins -> Y+6
;	cur_floor -> Y+4
;	i -> Y+2
;	o -> Y+0
	MOVW R26,R28
	ADIW R26,26
	RCALL _getFloor
	STD  Y+4,R30
	STD  Y+4+1,R31
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,28
	RCALL _prepare7SegDisplay
; 0000 00A7         if(!(i=getFloor(in_btns))||!(o=getFloor(out_btns))){
	MOVW R26,R28
	ADIW R26,20
	RCALL _getFloor
	STD  Y+2,R30
	STD  Y+2+1,R31
	SBIW R30,0
	BREQ _0x22
	MOVW R26,R28
	ADIW R26,14
	RCALL _getFloor
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,0
	BRNE _0x21
_0x22:
; 0000 00A8             if(i!=cur_floor){
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x24
; 0000 00A9                 struct Node n;
; 0000 00AA                 n.f = i;
	SBIW R28,6
;	queue -> Y+42
;	*is_notempty -> Y+40
;	*is_overweight -> Y+38
;	elev_floors -> Y+32
;	in_btns -> Y+26
;	out_btns -> Y+20
;	bcd_7seg_ins -> Y+12
;	cur_floor -> Y+10
;	i -> Y+8
;	o -> Y+6
;	n -> Y+0
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00AB                 n.p = abs(i-cur_floor);
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x8
; 0000 00AC                 if(!searchQueue(&queue,i)) enQueue(&queue,n);
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL _searchQueue
	SBIW R30,0
	BRNE _0x25
	CALL SUBOPT_0x9
; 0000 00AD             }
_0x25:
	ADIW R28,6
; 0000 00AE             if(o!=cur_floor){
_0x24:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x26
; 0000 00AF                 struct Node n;
; 0000 00B0                 n.f = o;
	SBIW R28,6
;	queue -> Y+42
;	*is_notempty -> Y+40
;	*is_overweight -> Y+38
;	elev_floors -> Y+32
;	in_btns -> Y+26
;	out_btns -> Y+20
;	bcd_7seg_ins -> Y+12
;	cur_floor -> Y+10
;	i -> Y+8
;	o -> Y+6
;	n -> Y+0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00B1                 n.p = abs(o-cur_floor);
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x8
; 0000 00B2                 if(!searchQueue(&queue,o)) enQueue(&queue,n);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL _searchQueue
	SBIW R30,0
	BRNE _0x27
	CALL SUBOPT_0x9
; 0000 00B3             }
_0x27:
	ADIW R28,6
; 0000 00B4         }
_0x26:
; 0000 00B5         if(queue.head){
_0x21:
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	SBIW R30,0
	BREQ _0x28
; 0000 00B6             moveElevator(deQueue(&queue)->f,is_up,is_down,elev_floors,bcd_7seg_ins);
	MOVW R26,R28
	ADIW R26,36
	RCALL _deQueue
	ADIW R30,2
	MOVW R26,R30
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R28
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,14
	RCALL _moveElevator
; 0000 00B7 
; 0000 00B8         }
; 0000 00B9     }
_0x28:
	ADIW R28,6
	RJMP _0x1E
; 0000 00BA }
_0x29:
	RJMP _0x29
; .FEND

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

	.DSEG

	.CSEG
_malloc:
; .FSTART _malloc
	ST   -Y,R27
	ST   -Y,R26
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2080001:
	ADIW R28,2
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	CALL __GETW1P
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CALL __EQW12
	MOVW R26,R0
	ST   X,R30
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ADIW R30,4
	MOVW R26,R30
	CALL __GETW1P
	CP   R0,R30
	CPC  R1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	MOVW R30,R16
	LDD  R26,Z+2
	LDD  R27,Z+3
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(59)
	LDI  R27,HIGH(59)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	CALL _abs
	STD  Y+4,R30
	STD  Y+4+1,R31
	MOVW R30,R28
	ADIW R30,42
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	MOVW R30,R28
	ADIW R30,42
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	LDI  R26,6
	CALL __PUTPARL
	JMP  _enQueue


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
