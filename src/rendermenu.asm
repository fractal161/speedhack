; begin reading buffer. instructions are as follows:
; first byte is length of patch, x
; next two are start addr
; next x are the patch data
; repeat until $00 is read for the patch length
        ldx     #$00
@whileSizeNot00:
        lda     menuBuffer,x
        beq     @finish
        sta     generalCounter
        inx
        lda     menuBuffer,x
        sta     PPUADDR
        inx
        lda     menuBuffer,x
        sta     PPUADDR
        inx
@loop:
        lda     menuBuffer,x
        sta     PPUDATA
        inx
        dec     generalCounter
        bne     @loop
        jmp     @whileSizeNot00
@finish:
        lda     #$00
        sta     menuBuffer