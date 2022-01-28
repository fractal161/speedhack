.zeropage
tmp1:	.res 1	; $0000
tmp2:	.res 1	; $0001
tmp3:	.res 1	; $0002
pollsPerFrame: .res 1 ; $0003
pollsThisFrame: .res 1 ; $0004
tmpBulkCopyToPpuReturnAddr: .res 2
pollTmp: .res 1
.res 15
rng_seed:	.res 2	; $0017
spawnID:	.res 1	; $0019
spawnCount:	.res 1	; $001A
.res 24
verticalBlankingInterval:	.res 1	; $0033
unused_0E: .res 1 ; $0034
.res 11
tetriminoX:	.res 1	; $0040
tetriminoY:	.res 1	; $0041
currentPiece:	.res 1	; $0042
.res 1
levelNumber:	.res 1	; $0044
fallTimer:	.res 1	; $0045
autorepeatX:	.res 1	; $0046
startLevel:	.res 1	; $0047
playState:	.res 1	; $0048
vramRow:	.res 1	; $0049
completedRow:	.res 4	; $004A
autorepeatY:	.res 1	; $004E
holdDownPoints:	.res 1	; $004F
lines:	.res 2	; $0050
rowY:	.res 1	; $0052
score:	.res 3	; $0053
completedLines:	.res 1	; $0056
lineIndex:	.res 1	; $0057
curtainRow:	.res 1	; $0058
startHeight:	.res 1	; $0059
garbageHole:	.res 1	; $005A
.res $45
spriteXOffset:	.res 1	; $00A0
spriteYOffset:	.res 1	; $00A1
spriteIndexInOamContentLookup:	.res 1	; $00A2
outOfDateRenderFlags:	.res 1	; $00A3
.res 2
nextPiece_2player:	.res 1	; $00A6
gameModeState:	.res 1	; $00A7
generalCounter:	.res 1	; $00A8
generalCounter2:	.res 1	; $00A9
generalCounter3:	.res 1	; $00AA
generalCounter4:	.res 1	; $00AB
generalCounter5:	.res 1	; $00AC
selectingLevelOrHeight:	.res 1	; $00AD
originalY:	.res 1	; $00AE
dropSpeed:	.res 1	; $00AF
.res 1
frameCounter:	.res 2	; $00B1
oamStagingLength:	.res 1	; $00B3
.res 1
newlyPressedButtons:	.res 1	; $00B5
heldButtons:	.res 1	; $00B6
activePlayer:	.res 1	; $00B7
playfieldAddr:	.res 2	; $00B8
.res 1
totalGarbageInactivePlayer:	.res 1	; $00BB
totalGarbage:	.res 1	; $00BC
renderMode:	.res 1	; $00BD
.res 1	; $00BE
nextPiece:	.res 1	; $00BF
gameMode:	.res 1	; $00C0
gameType:	.res 1	; $00C1
musicType:	.res 1	; $00C2
sleepCounter:	.res 1	; $00C3
ending:	.res 1	; $00C4
.res 9
demo_heldButtons:	.res 1	; $00CE
repeats:	.res 1	; $00CF
.res 1
demoButtonsTable_index:	.res 1	; $00D1
demoButtonsTable_indexOverflowed:	.res 1	; $00D2
demoIndex:	.res 1	; $00D3
highScoreEntryNameOffsetForLetter:	.res 1	; $00D4
highScoreEntryRawPos:	.res 1	; $00D5
highScoreEntryNameOffsetForRow:	.res 1	; $00D6
highScoreEntryCurrentLetter:	.res 1	; $00D7
.res 7
displayNextPiece:	.res 1	; $00DF
AUDIOTMP1:	.res 1	; $00E0
AUDIOTMP2:	.res 1	; $00E1
AUDIOTMP3:	.res 1	; $00E2
AUDIOTMP4:	.res 1	; $00E3
AUDIOTMP5:	.res 1	; $00E4
.res 1
musicChanTmpAddr:	.res 2	; $00E6
.res 2
music_unused2: .res 1  ; $00EA
soundRngSeed: .res 2  ; $00EB
currentSoundEffectSlot:	.res 1	; $00ED
musicChannelOffset:	.res 1	; $00EE
currentAudioSlot:	.res 1	; $00EF
.res 11
joy1Location:	.res 1	; $00FB
.res 2
currentPpuMask:	.res 1	; $00FE
currentPpuCtrl:	.res 1	; $00FF

.bss
stack:	.res $FF	; $0100
.res 1
oamStaging:	.res $100	; $0200
.res 240
statsByType:	.res $0E	; $03F0
.res 2
playfield:	.res $C8	; $0400
.res 56
.res $C8	; $0500
.res 184
musicStagingSq1Lo:	.res 1	; $0680
musicStagingSq1Hi:	.res 1	; $0681
audioInitialized:	.res 1	; $0682
musicPauseSoundEffectLengthCounter: .res 1 ; $0683
musicStagingSq2Lo:	.res 1	; $0684
musicStagingSq2Hi:	.res 1	; $0685
.res 2
musicStagingTriLo:	.res 1	; $0688
musicStagingTriHi:	.res 1	; $0689
resetSq12ForMusic:	.res 1	; $068A
musicPauseSoundEffectCounter: .res 1 ; $068B
musicStagingNoiseLo:	.res 1	; $068C
musicStagingNoiseHi:	.res 1	; $068D
.res 2
musicDataNoteTableOffset:	.res 1	; $0690
musicDataDurationTableOffset:	.res 1	; $0691
musicDataChanPtr:	.res $08	; $0692
musicChanControl:	.res $03	; $069A
musicChanVolume:	.res $03	; $069D
musicDataChanPtrDeref:	.res $08	; $06A0
musicDataChanPtrOff:	.res $04	; $06A8
musicDataChanInstructionOffset:	.res $04	; $06AC
musicDataChanInstructionOffsetBackup:	.res $04	; $06B0
musicChanNoteDurationRemaining:	.res $04	; $06B4
musicChanNoteDuration:	.res $04	; $06B8
musicChanProgLoopCounter:	.res $04	; $06BC
musicStagingSq1Sweep:	.res $02	; $06C0
.res 1
musicChanNote:  .res 4  ; $06C3
.res 1
musicChanInhibit:	.res $03	; $06C8
.res 1
musicTrack_dec:	.res 1	; $06CC
musicChanVolFrameCounter:	.res $04	; $06CD
musicChanLoFrameCounter:	.res $04	; $06D1
soundEffectSlot0FrameCount:	.res 5	; $06D5
soundEffectSlot0FrameCounter:	.res 5	; $06DA
soundEffectSlot0SecondaryCounter:	.res 1	; $06DF
soundEffectSlot1SecondaryCounter:	.res 1	; $06E0
soundEffectSlot2SecondaryCounter:	.res 1	; $06E1
soundEffectSlot3SecondaryCounter:	.res 1	; $06E2
soundEffectSlot0TertiaryCounter:	.res 1	; $06E3
soundEffectSlot1TertiaryCounter:	.res 1	; $06E4
soundEffectSlot2TertiaryCounter:	.res 1	; $06E5
soundEffectSlot3TertiaryCounter:	.res 1	; $06E6
soundEffectSlot0Tmp:	.res 1	; $06E7
soundEffectSlot1Tmp:	.res 1	; $06E8
soundEffectSlot2Tmp:	.res 1	; $06E9
soundEffectSlot3Tmp:	.res 1	; $06EA
.res 5
soundEffectSlot0Init:	.res 1	; $06F0
soundEffectSlot1Init:	.res 1	; $06F1
soundEffectSlot2Init:	.res 1	; $06F2
soundEffectSlot3Init:	.res 1	; $06F3
soundEffectSlot4Init:	.res 1	; $06F4
musicTrack:	.res 1	; $06F5
.res 2
soundEffectSlot0Playing:	.res 1	; $06F8
soundEffectSlot1Playing:	.res 1	; $06F9
soundEffectSlot2Playing:	.res 1	; $06FA
soundEffectSlot3Playing:	.res 1	; $06FB
soundEffectSlot4Playing:	.res 1	; $06FC
currentlyPlayingMusicTrack:	.res 1	; $06FD
.res 2
highScoreNames:	.res $30	; $0700
highScoreScoresA:	.res $C	; $0730
highScoreScoresB:	.res $C	; $073C
highScoreLevels:	.res $08	; $0748
initMagic:	.res $05	; $0750
