			;		QuickSort Assembly
			;		R0 = Number Sort
			;		R1 = start
			;		R2 = stop
			;		R3 = i
			;		R4 = j
			;		R5 = number[i]
			;		R6 = number[j]
			;		R7 = TEMP
			;		R8 = j-1
			;		R9 = i+1
			;		R10 = countRECUR
			;		R11 = memoryRECUR, MIN
			;		R12 = MAX
			;		R13 = memoryRECUR
			
			ADR		R0, NUMBER					; array value (Numbers to sort)
			ADR		R13, STACK					; memory recursive (Prepare for memorizing variable)
			MOV		R1, #0						; R1 = start
			MOV		R2, #24						; R2 = stop
			
QuickSort ; QuickSort Funtion
			MOV		R3, R1						; R3 = start
			MOV		R4, R2						; R4 = stop
			CMP		R1, R2						; if (start<stop)
			BGE		FINISH						; else (One or No value) -> FINISH
			
WHILE ; (WHILE,CHECK1,CON0,CONIF1)
; Locate the data to the right (j) less than the left (i) and then swap the values
			LDR		R5, [R0, R3, LSL #2] 		; number[i] (Load Register R0 Position R3)
			LDR		R6, [R0, R4, LSL #2]		; number[j] (Load Register R0 Position R4)
			CMP		R5, R6						; Condition 1: number[i] <= number[j]
			BLE		CHECK1						; (<= Check the next condition)
			B		CONIF1
CHECK1
			CMP		R3, R4						; Condition 2: && i < j
			BLT		CON0
			B		CONIF1
CON0
			SUB		R4, R4, #1					; j--
			B		WHILE	
CONIF1
			LDR		R5, [R0, R3, LSL #2] 		; number[i]
			LDR		R6, [R0, R4, LSL #2]		; number[j]
			CMP		R5, R6						; if (number[i] > number[j])
			BLE		WHILE1
			MOV		R7, R5						; (swap) temp = number[i]
			MOV		R5, R6						; number[i] = number[j]
			MOV		R6, R7						; number[j] = temp
			STR		R5, [R0, R3, LSL #2]		; (Store Register to R0)
			STR		R6, [R0, R4, LSL #2]
			ADD		R3, R3, #1					; i++
			
WHILE1	;(WHILE1,CHECK2,CON1,CONIF2)
; Locate the data to the left (i) greater than the right (j) and then swap the values
			LDR		R5, [R0, R3, LSL #2] 		; number[i] (Load Register R0 Position R3)
			LDR		R6, [R0, R4, LSL #2]		; number[j] (Load Register R0 Position R4)
			CMP		R5, R6						; Condition 1: number[i] <= number[j]
			BLE		CHECK2						; (<= Check the next condition)
			B		CONIF2
CHECK2
			CMP		R3, R4						; Condition 2: && i < j
			BLT		CON1
			B		CONIF2
CON1
			ADD		R3, R3, #1					; i++
			B		WHILE1
CONIF2
			LDR		R5, [R0, R3, LSL #2] 		; number[i]
			LDR		R6, [R0, R4, LSL #2]		; number[j]
			CMP		R5, R6						; number[i] > number[j]
			BLE		CHECK
			MOV		R7, R5						; (swap) temp = number[i]
			MOV		R5, R6						; number[i] = number[j]
			MOV		R6, R7						; number[j] = temp
			STR		R5, [R0, R3, LSL #2]		; (Store Register to R0)
			STR		R6, [R0, R4, LSL #2]
			SUB		R4, R4, #1					; j--
			
CHECK ; Breaks out of the loop when i is less than j
			CMP		R3, R4						; while (i<j)
			BLT		WHILE
			
RECUR ; Recursive QuickSort if (start < j-1) and memorize the value in STACK
			SUB		R8, R4, #1					; j-1
			CMP		R1, R8						; if (start < j-1)
			BGE		RECUR1						; else -> RECUR1
			ADD		R10, R10, #1				; countRECUR (R10++)
			STR		R2, [R13, R10, LSL #2]		; memoryRECUR (R2) to STACK (R13)
			MOV		R2, R8						; stop = j-1 (Prepare parameters for next round)
			B		QuickSort					; Recursive QuickSort Funtions
			
RECUR1 ; Recursive QuickSort if (i+1 < stop) 
			ADD		R9, R3, #1					; i+1
			CMP		R9, R2						; if (i+1 < stop)
			BGE		CHECKRECUR					; else -> (Check the remaining STACK)
			MOV		R1, R9						; start = i+1 (Prepare parameters for next round)
			B		QuickSort					; Recursive QuickSort Funtions
			
CHECKRECUR ; Check recursive and called the memorized value in the stack.
			CMP		R10, #0						; if (countRECUR = 0)
			BLT		FINISH						; END Program
			LDR		R11, [R13, R10, LSL #2] 	; R11 = memoryRECUR(R2) from STACK (R13)
			MOV		R2, R11						; stop = R11 (Retrieve old value in STACK to recursive) 
			SUB		R10, R10, #1				; R10--
			B		RECUR1
			
FINISH ; end
			LDR		R11, [R0, #0]				; min
			LDR		R12, [R0, #96]				; max
			END
			
NUMBER		DCD		676, 457, 875, 987, 45, 12, 145, 341, 289, 379, 121, 7, 93, 589, 621, 712, 254, 914, 198, 834, 412, 552, 980, 324, 691
STACK		DCD		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
