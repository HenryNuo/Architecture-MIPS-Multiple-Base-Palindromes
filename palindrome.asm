.data

prompt_massage: .asciiz "Enter value of n (in base 10): "

output_massage: .asciiz "Pairs of palindromic numbers from 1 through XX:\n\n"





.text

.globl main



main:

    # Prompt the user to enter n

    la $a0 prompt_massage

    li $v0 4

    syscall



    # Read n

    li $v0 5

    syscall



    move $s0 $v0



    la $a0 output_massage

    li $v0 4

    syscall



    li $s1 1

    mainLoopStart:

        bgt $s1 $s0 mainLoopEnd

        move $a0 $s1

        li $a1 10

        jal isPalidrome

        beq $v0 $zero mainCheckPalindromEnd



        move $a0 $s1

        li $a1 2

        jal isPalidrome

        beq $v0 $zero mainCheckPalindromEnd



        # Print current value in decimal

        move $a0 $s1

        li $v0 1

        syscall



        move $a0 $s1

        li $a1 10

        jal numDigits

        li $t0 16

        sub $t0 $t0 $v0 # Number of spaces to print

        mainPrintSpacesLoop:

            beq $t0 $zero mainPrintSpacesLoopEnd

            # Print one space

            li $a0 32

            li $v0 11

            syscall

            addi $t0 $t0 -1

            j mainPrintSpacesLoop

        mainPrintSpacesLoopEnd:



        # Print current value in binary

        move $a0 $s1

        jal printBinary



        # Print a newline

        li $a0 10

        li $v0 11

        syscall



        mainCheckPalindromEnd:

            addi $s1 $s1 1

            j mainLoopStart



    mainLoopEnd:

    li $v0 10

    syscall



isPalidrome:

    move $t0 $a0

    li $t1 1

    isPalidromeMSBLoopStart:

        blt $t0 $a1 isPalidromeMSBLoopEnd

        div $t0 $t0 $a1

        mul $t1 $t1 $a1

        j isPalidromeMSBLoopStart

    isPalidromeMSBLoopEnd:



    li $t0 1

    isPalidromeLoopStart:

        ble $t1 $t0 isPalidromeLoopEnd

        

        div $t2 $a0 $t1

        div $t2 $a1

        mfhi $t2

        div $t3 $a0 $t0

        div $t3 $a1

        mfhi $t3



        bne $t2 $t3 isPalidromeFalse



        div $t1 $t1 $a1

        mul $t0 $t0 $a1

        j isPalidromeLoopStart

    isPalidromeLoopEnd:



    li $v0 1

    jr $ra

    isPalidromeFalse:

        li $v0 0

        jr $ra



numDigits:

    # numDigits(n, k) returns the number of digits of n in base k

    li $v0 1

    numDigitsLoopStart:

        blt $a0 $a1 numDigitsLoopEnd

        div $a0 $a0 $a1

        addi $v0 $v0 1

        j numDigitsLoopStart

    numDigitsLoopEnd:

    jr $ra



printBinary:

    move $t0 $a0

    li $t1 1

    li $t2 2

    printBinaryCountDigitsStart:

        blt $t0 $t2 printBinaryCountDigitsEnd

        div $t0 $t0 $t2

        mul $t1 $t1 $t2

        j printBinaryCountDigitsStart

    printBinaryCountDigitsEnd:



    move $t0 $a0

    printBinaryLoopStart:

        beq $t1 $zero printBinaryLoopEnd

        div $a0 $t0 $t1

        andi $a0 $a0 1



        li $v0 1

        syscall



        div $t1 $t1 $t2

        j printBinaryLoopStart

    printBinaryLoopEnd:

    jr $ra

