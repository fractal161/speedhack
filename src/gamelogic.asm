; Do this whenever gameCycleCount < pollsThisFrame
playState_playerControlsActiveTetrimino:
        lda     pollsThisFrame ; if there's been a poll already go to nmi
        beq     @checkIfAnotherPollThisFrame
@waitForNextPoll:
        lda     gameCycleCount
        cmp     pollsThisFrame
        bcs     @waitForNextPoll
@gameLogic:
        inc     fallTimer
        jsr     shift_tetrimino
        jsr     rotate_tetrimino
        jsr     drop_tetrimino
        inc     gameCycleCount
        lda     playState
        cmp     #$02
        beq     @retAndClear ; Exit if piece has locked
@checkIfAnotherPollThisFrame:
        lda     framesToWait
        bne     @ret ; if framesToWait == 0 then more polls will happen later in the frame
        ; idle when gameCycleCount >= pollsThisFrame
        jmp     @waitForNextPoll
@retAndClear:
        ; adjust pollIndex so entry delay works
        jsr     rewindPollIndex
        sta     $E000 ; disable irq generation
        sei ; so no interrupts are called during lock/line clear delay
@ret:
        rts

rewindPollIndex:
        lda     pollIndex
        sec
        sbc     subFrameTop
@while:
        cmp     #$00
        bpl     @ret
        clc
        adc     pollsPerFrame
        jmp     @while
@ret:
        sta     pollIndex
        rts