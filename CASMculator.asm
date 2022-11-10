.model small
.stack 100h
.data

first_number_choice db 10,13,        'Addition (1)'
                    db 10,13,        'Subtraction (2)'
                    db 10,13,        'Multiplication (3)'
                    db 10,13,        'Division (4) '
                    db 10,13,        'Quit (5)'
           
           
                    db 13,10,13,10,  'First number : $'
           
input_2             db 13,10,        'Second number : $'



op_choose           db 13,10,        'Choose the operation : $'


addi                db 13,10,13,10,  ' Addition is equal to : $'
soustrac            db 13,10,13,10,  ' Subtraction is equal to : $'
multipli            db 13,10,13,10,  ' Multiplication is equal to : $'
divi                db 13,10,13,10,  ' Division is equal to : $'

.code

       
beginning:

        MOV AX, @DATA ; First LoC that is executed
        MOV DS, AX    ; Memory location
    
        LEA DX, first_number_choice
        MOV AH, 9H ; Fct 9 is used to print text to the screen
        INT 21H 
        MOV BX, 0 ; Reset the register
   
beginning:
    
        MOV AH, 1H
        INT 21H
        CMP AL, 0DH
        JE input1
    
        MOV AH, 0
        SUB AL, 30H  ; We subtract '0' to convert into decimal
        PUSH AX
        MOV AX, 10
        MUL BX 
        POP BX       ; Get the value stored in BX
        ADD BX, AX
        JMP beginning

input1:

        PUSH BX
        LEA  DX, input_2 
        MOV  AH, 9H
        INT  21H
        MOV  BX, 0
       
next:
    
        MOV AH, 1H
        INT 21H
        CMP AL, 0DH
        JE operation_sign
      
        MOV AH, 0
        SUB AL, 30H 
        PUSH AX
        MOV AX, 10
        MUL BX
        POP BX
        ADD BX, AX
        JMP next  
        
operation_sign: 
        
        LEA DX, op_choose
        MOV AH, 9H
        INT 21H
      
        MOV AH, 1H
        INT 21H
      

; Here we will compare our keyboard input with a string that represents the operation that we're gonna do
; If '5' is our input, program will end immediately.

        CMP AL, '1'
        JE addition 
      
        CMP AL, '2'
        JE subtraction
      
        CMP AL, '3'
        JE multiplication
      
        CMP AL, '4'
        JE division
      
        CMP AL, '5'
        MOV AH, 4CH
        INT 21H
           



addition:

        POP AX ; get the stack value
        ADD AX, BX ; sum up the two numbers
        PUSH AX
        LEA DX, addi ; print the res
        MOV AH, 9H
        INT 21H
        POP AX
        MOV CX, 0 ; reset the counter register
        MOV DX, 0 ; reset the data register
        MOV BX, 10
        JMP conv

      
subtraction: 

        POP AX
        SUB AX, BX
        PUSH AX
        LEA DX, soustrac
        MOV AH, 9H
        INT 21H
        POP AX
        MOV CX, 0
        MOV DX, 0
        MOV BX, 10 
        JMP conv     


multiplication:

        POP AX
        MUL BX
        PUSH AX
        LEA DX, multipli 
        MOV AH, 9H
        INT 21H
        POP AX
        MOV CX, 0
        MOV DX, 0
        MOV BX, 10
        JMP conv
                   
                   
division:

        POP AX
        MOV DX, 0
        DIV BX
        PUSH AX
        LEA DX, divi 
        MOV AH, 9H
        INT 21H
        POP AX
        MOV CX, 0
        MOV DX, 0
        MOV BX, 10
        JMP conv
      
conv:
        MOV DX, 0
        DIV BX
        PUSH DX
        MOV DX, 0
        INC CX
        OR AX, AX ; reset AX to 0
        JNE conv
      
            
      
show_res:

        POP DX
        ADD DL, 30H ; Add '0' to convert back to ascii (to print it out)
        MOV AH, 2H ; Fct 2 : Print to the screen 
        INT 21H
        LOOP show_res ; Loop through show_res until there's no numbers left to print
      
     
     
        JMP beginning
        end beginning
