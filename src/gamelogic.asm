; Do this whenever gameCycleCount < pollsThisFrame
playState_playerControlsActiveTetrimino:
        inc     fallTimer
        jsr     shift_tetrimino
        jsr     rotate_tetrimino
        jsr     drop_tetrimino
        inc     gameCycleCount
        lda     playState
        cmp     #$02
        beq     @retAndClear ; Exit if piece has locked
        lda     gameCycleCount
        cmp     pollsThisFrame
; If gameCycleCount < pollsThisFrame then we run another cycle
        bcc     playState_playerControlsActiveTetrimino
        lda     framesToWait
        bne     @ret ; if framesToWait == 0 then more polls will happen later in the frame
; idle when gameCycleCount >= pollsThisFrame
@waitForNextPoll:
        cmp     pollsThisFrame
        bcs     @waitForNextPoll
        jmp     playState_playerControlsActiveTetrimino
@retAndClear:
        sei ; so no interrupts are called during lock/line clear delay
@ret:
        rts