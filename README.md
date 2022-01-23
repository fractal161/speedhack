# NES Tetris Infinity

Romhack of NES Tetris that implements consistent subframe controller polling, intended to facilitate faster yet fair killscreen gameplay. The main idea is that the pieces fall in a predictable way, so not refreshing the display isn't a huge detriment.

In making this, a large portion of unnecessary/unused code has been stripped from the original ROM. A lightweight game on its own, it only used about 30% of each frame to run actual gameplay on average. Through optimization, this time has been cut down to less than 10%. We expect that the max polling rate can exceed 780hz in most conditions, and can likely go up to 1000hz.

Based on some crude testing, the main game loop (shift, rotate, drop tetrimino) never takes more than 1500 cycles to execute, while the input polling routine is 268 cycles. Waiting for NMI is at least 24000 cycles, so this is already room for 13 game frames, or 780hz polling. In practice, game frames will be much smaller due to a limit on the number of inputs.

## Acknowledgements

CelestialAmber for creating the disassembly that this is based off of, who in turned used the work of ejona86.

Kirjava for answering my endless well of questions.