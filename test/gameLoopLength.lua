totalCycles = 29780
gameLogicCycleStart = 0
elapsedCycles = 0
maxElapsedCycles = 0

function start()
  gameLogicCycleStart = emu.getState().cpu.cycleCount
end

function finish()
  elapsedCycles = emu.getState().cpu.cycleCount - gameLogicCycleStart
  if elapsedCycles > maxElapsedCycles then
    maxElapsedCycles = elapsedCycles
  end
end

function draw()
  emu.drawString(9,9,maxElapsedCycles,0xFFFFFF,0x000000)
end

emu.addMemoryCallback(start, emu.memCallbackType.cpuExec, 0x81F9)
emu.addMemoryCallback(finish, emu.memCallbackType.cpuExec, 0x8202)
emu.addEventCallback(draw, emu.eventType.endFrame)