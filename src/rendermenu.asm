        lda     menuBufferAddr+1
        sta     PPUADDR
        lda     menuBufferAddr
        sta     PPUADDR
        ldx     #$00
@loop:
        cpx     menuBufferSize
        beq     @finish
        lda     menuBuffer,x
        sta     PPUDATA
        inx
        jmp     @loop
@finish:
        lda     #$00
        sta     menuBufferSize