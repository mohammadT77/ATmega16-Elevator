
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
;    /*
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
;#include <math.h>
;
;const short int NUM_OF_FLOORS = 3;

	.DSEG
;//const short int DELAY_BETWEENLFLOORS = 5000;
;
;void prepare7SegDisplay(int floor){
; 0000 0011 void prepare7SegDisplay(int floor){

	.CSEG
_prepare7SegDisplay:
; .FSTART _prepare7SegDisplay
; 0000 0012     PORTB.0 = floor%2;
	ST   -Y,R27
	ST   -Y,R26
;	floor -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	BRNE _0x4
	CBI  0x18,0
	RJMP _0x5
_0x4:
	SBI  0x18,0
_0x5:
; 0000 0013     PORTB.1 = floor==2||floor==3||floor==6||floor==7;
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BREQ _0x6
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BREQ _0x6
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BREQ _0x6
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BREQ _0x6
	LDI  R30,0
	RJMP _0x7
_0x6:
	LDI  R30,1
_0x7:
	CPI  R30,0
	BRNE _0x8
	CBI  0x18,1
	RJMP _0x9
_0x8:
	SBI  0x18,1
_0x9:
; 0000 0014     PORTB.2 = floor==4||floor==5||floor==6||floor==7;
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BREQ _0xA
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BREQ _0xA
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BREQ _0xA
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BREQ _0xA
	LDI  R30,0
	RJMP _0xB
_0xA:
	LDI  R30,1
_0xB:
	CPI  R30,0
	BRNE _0xC
	CBI  0x18,2
	RJMP _0xD
_0xC:
	SBI  0x18,2
_0xD:
; 0000 0015     PORTB.3 = floor==8||floor==9;
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BREQ _0xE
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BREQ _0xE
	LDI  R30,0
	RJMP _0xF
_0xE:
	LDI  R30,1
_0xF:
	CPI  R30,0
	BRNE _0x10
	CBI  0x18,3
	RJMP _0x11
_0x10:
	SBI  0x18,3
_0x11:
; 0000 0016 }
	RJMP _0x2080001
; .FEND
;void turnOnLED(int requsted_floor) {
; 0000 0017 void turnOnLED(int requsted_floor) {
_turnOnLED:
; .FSTART _turnOnLED
; 0000 0018 	if (requsted_floor == 1) PORTC.5 = 0;
	ST   -Y,R27
	ST   -Y,R26
;	requsted_floor -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x12
	CBI  0x15,5
; 0000 0019 	else if (requsted_floor == 2) PORTC.6 = 0;
	RJMP _0x15
_0x12:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x16
	CBI  0x15,6
; 0000 001A 	else if (requsted_floor == 3) PORTC.7 = 0;
	RJMP _0x19
_0x16:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x1A
	CBI  0x15,7
; 0000 001B }
_0x1A:
_0x19:
_0x15:
	RJMP _0x2080001
; .FEND
;void turnOffLED(int requsted_floor) {
; 0000 001C void turnOffLED(int requsted_floor) {
_turnOffLED:
; .FSTART _turnOffLED
; 0000 001D 	if (requsted_floor == 1) PORTC.5 = 1;
	ST   -Y,R27
	ST   -Y,R26
;	requsted_floor -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x1D
	SBI  0x15,5
; 0000 001E 	else if (requsted_floor == 2) PORTC.6 = 1;
	RJMP _0x20
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x21
	SBI  0x15,6
; 0000 001F 	else if (requsted_floor == 3) PORTC.7 = 1;
	RJMP _0x24
_0x21:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x25
	SBI  0x15,7
; 0000 0020 }
_0x25:
_0x24:
_0x20:
	RJMP _0x2080001
; .FEND
;int getCurrentFloor(){
; 0000 0021 int getCurrentFloor(){
_getCurrentFloor:
; .FSTART _getCurrentFloor
; 0000 0022     return PINA.2 * 3 +  PINA.1 * 2 + PINA.0;
	LDI  R26,0
	SBIC 0x19,2
	LDI  R26,1
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOV  R22,R0
	LDI  R26,0
	SBIC 0x19,1
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R30,0
	SBIC 0x19,0
	LDI  R30,1
	ADD  R30,R26
	RJMP _0x2080002
; 0000 0023 }
; .FEND
;
;int getInBtnsFloor(){
; 0000 0025 int getInBtnsFloor(){
_getInBtnsFloor:
; .FSTART _getInBtnsFloor
; 0000 0026     return PINC.2 * 3 +  PINC.1 * 2 + PINC.0;
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOV  R22,R0
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ADD  R30,R26
	RJMP _0x2080002
; 0000 0027 }
; .FEND
;int getOutBtnsFloor(){
; 0000 0028 int getOutBtnsFloor(){
_getOutBtnsFloor:
; .FSTART _getOutBtnsFloor
; 0000 0029     return PIND.2 * 3 +  PIND.1 * 2 + PIND.0;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	LDI  R30,LOW(3)
	MUL  R30,R26
	MOV  R22,R0
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	CALL SUBOPT_0x0
	LDI  R30,0
	SBIC 0x10,0
	LDI  R30,1
	ADD  R30,R26
	RJMP _0x2080002
; 0000 002A }
; .FEND
;
;
;
;int getMaxRequestedFloor(){
; 0000 002E int getMaxRequestedFloor(){
; 0000 002F     int max;
; 0000 0030     if(PIND.2||PINC.2) max = 3;
;	max -> R16,R17
; 0000 0031     else if(PIND.1||PINC.1) max = 2;
; 0000 0032     else if(PIND.0||PINC.0) max = 1;
; 0000 0033     else max = 0;
; 0000 0034     return max;
; 0000 0035 }
;int getMinRequestedFloor(){
; 0000 0036 int getMinRequestedFloor(){
; 0000 0037     int min;
; 0000 0038     if(PIND.0||PINC.0) min = 1;
;	min -> R16,R17
; 0000 0039     else if(PIND.1||PINC.1) min = 2;
; 0000 003A     else if(PIND.2||PINC.2) min = 3;
; 0000 003B     else min = 0;
; 0000 003C     return min;
; 0000 003D }
;void onArriveFloor(int floor){
; 0000 003E void onArriveFloor(int floor){
; 0000 003F 	if (floor == 1) { PIND.0 = 0; PINC.0 = 0; };
;	floor -> Y+0
; 0000 0040 	if (floor == 2) { PIND.1 = 0; PINC.1 = 0; }
; 0000 0041 	if (floor == 3) { PIND.2 = 0; PINC.2 = 0; }
; 0000 0042 }
;
;short getDirection(){
; 0000 0044 short getDirection(){
_getDirection:
; .FSTART _getDirection
; 0000 0045     return !PINA.6?(PINA.7?-1:0):1;
	SBIC 0x19,6
	RJMP _0x4F
	SBIS 0x19,7
	RJMP _0x50
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x51
_0x50:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x51:
	RJMP _0x53
_0x4F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x53:
	RET
; 0000 0046 }
; .FEND
;
;/*
;inline void moveElevator(){
;    short direction = getDirection();
;    short curr_floor = getCurrentFloor();
;
;    if(direction>0){
;        while(getMaxRequestedFloor()-curr_floor){
;            int d=0;
;            while(d++<DELAY_BETWEENLFLOORS);
;            onArriveFloor(direction);
;            setCurrentFloor(++curr_floor);
;
;        }
;    }
;    else if(direction>0){
;        while(getMinRequestedFloor()-curr_floor){
;            int d=0;
;            while(d++<DELAY_BETWEENLFLOORS);
;            onArriveFloor(direction);
;            setCurrentFloor(--curr_floor);
;        }
;    }
;    setDirection(direction);
;
;}
;*/
;
;short isElevatorEmpty(){
; 0000 0063 short isElevatorEmpty(){
; 0000 0064     return PINB.5==1;
; 0000 0065 }
;short isElevatorOk() {
; 0000 0066 short isElevatorOk() {
; 0000 0067 	return PINB.6 == 1;
; 0000 0068 }
;short isElevatorOverWeight(){
; 0000 0069 short isElevatorOverWeight(){
_isElevatorOverWeight:
; .FSTART _isElevatorOverWeight
; 0000 006A     return PINB.7==1;
	LDI  R26,0
	SBIC 0x16,7
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
_0x2080002:
	LDI  R31,0
	RET
; 0000 006B }
; .FEND
;
;void initialization();
;struct Node {
;	struct Node* next;
;	int f;
;	int p;
;};
;struct pQueue {
;	struct Node* head;
;};
;void initQueue(struct pQueue *queue);
;void enQueue(struct pQueue* queue, struct Node n);
;struct Node* deQueue(struct pQueue* queue);
;short removeQueue(struct pQueue* queue, struct Node * node);
;struct Node* searchQueue(struct pQueue* queue, int f);
;int sizeOfQueue(struct pQueue* queue);
;
;void main(void)
; 0000 007E {
_main:
; .FSTART _main
; 0000 007F 	struct pQueue f_queue;
; 0000 0080 	initQueue(&f_queue);
	SBIW R28,2
;	f_queue -> Y+0
	MOVW R26,R28
	RCALL _initQueue
; 0000 0081 
; 0000 0082 	initialization();
	RCALL _initialization
; 0000 0083 
; 0000 0084     while (1){
_0x55:
; 0000 0085 
; 0000 0086 		int in_req = getInBtnsFloor(), out_req = getOutBtnsFloor();
; 0000 0087 		int curr_floor = getCurrentFloor();
; 0000 0088 		prepare7SegDisplay(curr_floor);
	SBIW R28,6
;	f_queue -> Y+6
;	in_req -> Y+4
;	out_req -> Y+2
;	curr_floor -> Y+0
	RCALL _getInBtnsFloor
	STD  Y+4,R30
	STD  Y+4+1,R31
	RCALL _getOutBtnsFloor
	STD  Y+2,R30
	STD  Y+2+1,R31
	RCALL _getCurrentFloor
	ST   Y,R30
	STD  Y+1,R31
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _prepare7SegDisplay
; 0000 0089 
; 0000 008A 
; 0000 008B 		if (in_req!=0) {
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BREQ _0x58
; 0000 008C 			if(curr_floor!=in_req)
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x59
; 0000 008D 				if (isElevatorOverWeight() == 0)
	RCALL _isElevatorOverWeight
	SBIW R30,0
	BRNE _0x5A
; 0000 008E 					turnOnLED(in_req);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _turnOnLED
; 0000 008F 
; 0000 0090 			//n.f = min_f;
; 0000 0091 			//n.p = abs(min_f - getCurrentFloor());
; 0000 0092 			//n.next = 0;
; 0000 0093 			//if (!searchQueue(&f_queue, min_f)) enQueue(&f_queue, n);
; 0000 0094 		}
_0x5A:
_0x59:
; 0000 0095 		if (out_req!=0) {
_0x58:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BREQ _0x5B
; 0000 0096 			if (curr_floor != out_req)
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x5C
; 0000 0097 				turnOnLED(out_req);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _turnOnLED
; 0000 0098 			//n.f = max_f;
; 0000 0099 			//n.p = abs(max_f - getCurrentFloor());
; 0000 009A 			//n.next = 0;
; 0000 009B 			//if(!searchQueue(&f_queue,max_f)) enQueue(&f_queue,n);
; 0000 009C 		}
_0x5C:
; 0000 009D 
; 0000 009E 		if (getDirection() != 0) {
_0x5B:
	RCALL _getDirection
	SBIW R30,0
	BREQ _0x5D
; 0000 009F 			turnOffLED(curr_floor);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _turnOffLED
; 0000 00A0 			//if (searchQueue(&f_queue, curr_floor)) onArriveFloor(curr_floor);
; 0000 00A1 
; 0000 00A2 		}
; 0000 00A3 
; 0000 00A4 
; 0000 00A5 
; 0000 00A6     }
_0x5D:
	ADIW R28,6
	RJMP _0x55
; 0000 00A7 }
_0x5E:
	RJMP _0x5E
; .FEND
;
;void initialization(){
; 0000 00A9 void initialization(){
_initialization:
; .FSTART _initialization
; 0000 00AA 	// Declare your local variables here
; 0000 00AB 
; 0000 00AC 	// Input/Output Ports initialization
; 0000 00AD 	// Port A initialization
; 0000 00AE 	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00AF 	DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00B0 	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B1 	PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00B2 
; 0000 00B3 	// Port B initialization
; 0000 00B4 	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B5 
; 0000 00B6 	DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 00B7 	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B8 	PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00B9 
; 0000 00BA 	// Port C initialization
; 0000 00BB 	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BC 	DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(224)
	OUT  0x14,R30
; 0000 00BD 	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BE 	PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00BF 
; 0000 00C0 	// Port D initialization
; 0000 00C1 	// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C2 	DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00C3 	// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C4 	PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00C5 
; 0000 00C6 	// Timer/Counter 0 initialization
; 0000 00C7 	// Clock source: System Clock
; 0000 00C8 	// Clock value: Timer 0 Stopped
; 0000 00C9 	// Mode: Normal top=0xFF
; 0000 00CA 	// OC0 output: Disconnected
; 0000 00CB 	TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00CC 	TCNT0=0x00;
	OUT  0x32,R30
; 0000 00CD 	OCR0=0x00;
	OUT  0x3C,R30
; 0000 00CE 
; 0000 00CF 	// Timer/Counter 1 initialization
; 0000 00D0 	// Clock source: System Clock
; 0000 00D1 	// Clock value: Timer1 Stopped
; 0000 00D2 	// Mode: Normal top=0xFFFF
; 0000 00D3 	// OC1A output: Disconnected
; 0000 00D4 	// OC1B output: Disconnected
; 0000 00D5 	// Noise Canceler: Off
; 0000 00D6 	// Input Capture on Falling Edge
; 0000 00D7 	// Timer1 Overflow Interrupt: Off
; 0000 00D8 	// Input Capture Interrupt: Off
; 0000 00D9 	// Compare A Match Interrupt: Off
; 0000 00DA 	// Compare B Match Interrupt: Off
; 0000 00DB 	TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00DC 	TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00DD 	TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00DE 	TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DF 	ICR1H=0x00;
	OUT  0x27,R30
; 0000 00E0 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E1 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E2 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E3 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E4 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E5 
; 0000 00E6 	// Timer/Counter 2 initialization
; 0000 00E7 	// Clock source: System Clock
; 0000 00E8 	// Clock value: Timer2 Stopped
; 0000 00E9 	// Mode: Normal top=0xFF
; 0000 00EA 	// OC2 output: Disconnected
; 0000 00EB 	ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00EC 	TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00ED 	TCNT2=0x00;
	OUT  0x24,R30
; 0000 00EE 	OCR2=0x00;
	OUT  0x23,R30
; 0000 00EF 
; 0000 00F0 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00F1 	TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00F2 
; 0000 00F3 	// External Interrupt(s) initialization
; 0000 00F4 	// INT0: Off
; 0000 00F5 	// INT1: Off
; 0000 00F6 	// INT2: Off
; 0000 00F7 	MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00F8 	MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00F9 
; 0000 00FA 	// USART initialization
; 0000 00FB 	// USART disabled
; 0000 00FC 	UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00FD 
; 0000 00FE 	// Analog Comparator initialization
; 0000 00FF 	// Analog Comparator: Off
; 0000 0100 	// The Analog Comparator's positive input is
; 0000 0101 	// connected to the AIN0 pin
; 0000 0102 	// The Analog Comparator's negative input is
; 0000 0103 	// connected to the AIN1 pin
; 0000 0104 	ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0105 	SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0106 
; 0000 0107 	// ADC initialization
; 0000 0108 	// ADC disabled
; 0000 0109 	ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 010A 
; 0000 010B 	// SPI initialization
; 0000 010C 	// SPI disabled
; 0000 010D 	SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 010E 
; 0000 010F 	// TWI initialization
; 0000 0110 	// TWI disabled
; 0000 0111 	TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0112 
; 0000 0113 }
	RET
; .FEND
;
;
;
;
;
;
;void initQueue(struct pQueue *queue){
; 0000 011A void initQueue(struct pQueue *queue){
_initQueue:
; .FSTART _initQueue
; 0000 011B     queue->head = 0;
	ST   -Y,R27
	ST   -Y,R26
;	*queue -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 011C }
_0x2080001:
	ADIW R28,2
	RET
; .FEND
;
;void enQueue(struct pQueue* queue, struct Node n){
; 0000 011E void enQueue(struct pQueue* queue, struct Node n){
; 0000 011F     struct Node* curr = queue->head;
; 0000 0120     struct Node* node = (struct Node*)malloc(sizeof(n));
; 0000 0121     node->f = n.f;
;	*queue -> Y+10
;	n -> Y+4
;	*curr -> R16,R17
;	*node -> R18,R19
; 0000 0122     node->p = n.p;
; 0000 0123     node->next = 0;
; 0000 0124     if(!queue->head){
; 0000 0125         queue->head = node;
; 0000 0126         return;
; 0000 0127     }
; 0000 0128     if(node->p < queue->head->p){
; 0000 0129         node->next = queue->head;
; 0000 012A         queue->head = node;
; 0000 012B         return;
; 0000 012C     }
; 0000 012D     if(!queue->head->next){
; 0000 012E         queue->head->next = node;
; 0000 012F         return;
; 0000 0130     }
; 0000 0131     while (curr->next->next){
; 0000 0132         if(node->p < curr->next->p){
; 0000 0133             node->next = curr->next;
; 0000 0134             curr->next = node;
; 0000 0135             return;
; 0000 0136         }
; 0000 0137         curr = curr->next;
; 0000 0138     }
; 0000 0139     curr->next->next = node;
; 0000 013A 
; 0000 013B }
;short removeQueue(struct pQueue* queue, struct Node * node) {
; 0000 013C short removeQueue(struct pQueue* queue, struct Node * node) {
; 0000 013D 	struct Node* curr = queue->head;
; 0000 013E 	if (!curr) return 0;
;	*queue -> Y+4
;	*node -> Y+2
;	*curr -> R16,R17
; 0000 013F 	if (node == curr) {
; 0000 0140 		queue->head = queue->head->next;
; 0000 0141 		free(node);
; 0000 0142 		return 1;
; 0000 0143 	}
; 0000 0144 	while (curr->next) {
; 0000 0145 		if (curr->next == node) {
; 0000 0146 			curr->next = curr->next->next;
; 0000 0147 			free(node);
; 0000 0148 			return 1;
; 0000 0149 		}
; 0000 014A 		curr = curr->next;
; 0000 014B 	}
; 0000 014C 	return 0;
; 0000 014D }
;struct Node* deQueue(struct pQueue* queue){
; 0000 014E struct Node* deQueue(struct pQueue* queue){
; 0000 014F     struct Node* temp = queue->head;
; 0000 0150     if(!temp) return 0;
;	*queue -> Y+2
;	*temp -> R16,R17
; 0000 0151     queue->head = queue->head->next;
; 0000 0152     return temp;
; 0000 0153 }
;
;struct Node* searchQueue(struct pQueue* queue,int f){
; 0000 0155 struct Node* searchQueue(struct pQueue* queue,int f){
; 0000 0156     struct Node* curr = queue->head;
; 0000 0157     if(!curr) return 0;
;	*queue -> Y+4
;	f -> Y+2
;	*curr -> R16,R17
; 0000 0158     while(curr->next && curr->f != f) curr = curr->next;
; 0000 0159 return (curr->f==f)?curr:0;
; 0000 015A 
; 0000 015B }
;int sizeOfQueue(struct pQueue* queue) {
; 0000 015C int sizeOfQueue(struct pQueue* queue) {
; 0000 015D 	struct Node* cur = queue->head;
; 0000 015E 	int count = 0;
; 0000 015F 	while (cur!=NULL) { count=7; cur = cur->next;}
;	*queue -> Y+4
;	*cur -> R16,R17
;	count -> R18,R19
; 0000 0160 	return count;
; 0000 0161 
; 0000 0162 }

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R26,R22
	ADD  R26,R30
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

;END OF CODE MARKER
__END_OF_CODE:
