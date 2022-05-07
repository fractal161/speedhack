irq:
; Acknowledge interrupt
        sta     $E000
        pha
        txa
        pha
        tya
        pha
; Make next scanline request
        ldx     pollsPerFrame
        lda     scanlineIndexTable,x
        clc
        adc     pollsThisFrame
        tax
        lda     scanlineLengthTable,x
        sta     $C000
        sta     $C001
        sta     $E000
        sta     $E001
; Wait for some number of cycles
; What we actually care about
        jsr     pollController
        inc     pollsThisFrame
        jsr     generateNextPseudorandomNumber
; Disable irq if this is the last one
        lda     pollsThisFrame
        cmp     pollsPerFrame
        bne     @finish
        sta     $E000
@finish:
        pla
        tay
        pla
        tax
        pla
        rti

; http://bobrost.com/nes/files/mmc3irqs.txt
; When you want to set up the IRQ: (do this in your NMI/vblank routine)
  ; 1. Write to $E000 to acknowledge any currently pending interrupts
  ; 2. Write the number of scanlines you want to wait to $C000 and then $C001
  ; 3. Write to $E000 again to latch in the countdown value
  ; 4. Write to $E001 to enable the IRQ counter
; Index into table is y, table address should be in pollAddr1/pollAddr2
; a probably contains current scanline for subtraction
; very likely mod 241 issues
scheduleNextIrq:
        eor     #$80 ; probably negate number?
        clc
        adc     (pollAddr),y ; potentially off by some constant
        sta     $C000
        sta     $C001
        sta     $E000
        sta     $E001
        rts
