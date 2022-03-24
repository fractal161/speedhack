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
        cmp     pollsPerFrame
        beq     @ret
; idle when gameCycleCount >= pollsThisFrame
@waitForNextPoll:
        cmp     pollsThisFrame
        bcs     @waitForNextPoll
        jmp     playState_playerControlsActiveTetrimino
@retAndClear:
        sei
@ret:
        rts