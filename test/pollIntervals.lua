pollAddress = emu.getLabelAddress("pollController")
pollValue = emu.getLabelAddress("pollsPerFrame")
pollsPerFrame = emu.read(pollValue, emu.memType.cpuDebug)
totalCycles = 29780
maxCycleCount = 0
minCycleCount = 999999999
lastCycleCount = 0
cycleDiffs = {0,0}
index = 1

barStart = 88
barEnd = 256 - 72

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
  local x = barStart + (barEnd - barStart) * cycleDiff / totalCycles
  emu.drawRectangle(x - 1, 224, 2, 8, 0x00FF00, true)
end

function draw()
  emu.drawString(9,9,minCycleCount,0xFFFFFF,0x000000)
  emu.drawString(9,18,maxCycleCount,0xFFFFFF,0x000000)
  emu.drawString(9,27,cycleDiffs[1],0xFFFFFF,0x000000)
  emu.drawString(50,27,cycleDiffs[2],0xFFFFFF,0x000000)
  emu.drawRectangle(barStart, 227, barEnd - barStart, 2, 0x000000, true)
  for i = 0,pollsPerFrame do
    local x = barStart + (barEnd - barStart) * i / pollsPerFrame
    emu.drawRectangle(x - 2, 222, 4, 12, 0x000000, true)
  end
  -- lastCycleCount = emu.getState().cpu.cycleCount
end

emu.addMemoryCallback(main, emu.memCallbackType.cpuExec, pollAddress)
emu.addEventCallback(draw, emu.eventType.startFrame)