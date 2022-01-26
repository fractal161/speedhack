pollAddress = emu.getLabelAddress("pollController")
pollValue = emu.getLabelAddress("pollsPerFrame")
totalCycles = 29780
maxCycleCount = 0
minCycleCount = 999999999
lastCycleCount = 0
cycleDiffs = {0,0}
index = 1

function main()
  if lastCycleCount == 0 then
    lastCycleCount = emu.getState().cpu.cycleCount
    return
  end
  local cycleDiff = emu.getState().cpu.cycleCount - lastCycleCount
  maxCycleCount = math.max(maxCycleCount, cycleDiff)
  minCycleCount = math.min(minCycleCount, cycleDiff)
  lastCycleCount = emu.getState().cpu.cycleCount
  cycleDiffs[index] = cycleDiff
  if index == 1 then index = 2 else index = 1 end
end

function draw()
  emu.drawString(9,9,minCycleCount,0xFFFFFF,0x000000)
  emu.drawString(9,18,maxCycleCount,0xFFFFFF,0x000000)
  emu.drawString(9,27,cycleDiffs[1],0xFFFFFF,0x000000)
  emu.drawString(50,27,cycleDiffs[2],0xFFFFFF,0x000000)
end

emu.addMemoryCallback(main, emu.memCallbackType.cpuExec, pollAddress)
emu.addEventCallback(draw, emu.eventType.endFrame)