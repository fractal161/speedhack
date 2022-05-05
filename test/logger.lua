logging = true

playState = emu.getLabelAddress('playState')
poll = emu.getLabelAddress('pollControllerButtons')

startTime = os.date('%Y-%m-%d-%H%M%S')
path = '/home/justin/Tetris/NES/Romhacking/nes-tetris-infinity/log'
logFileName = string.format('%s/%s.txt', path, startTime)
f = assert(io.open(logFileName, 'w'))

f:write('VANILLA ROM')
f:write('----')

function log(action, data)
  state = emu.getState()
  scanline = (state.ppu.scanline - 240) % 241
  if scanline < 0 then
    scanline = scanline + 241
  end
  subframe = state.ppu.frameCount + scanline / 241
  logMsg = string.format('[%09.3f] %s', subframe, action)
  if data ~= nil then
    logMsg = string.format('%s - %s', logMsg, data)
  end
  if logging then
    emu.log(logMsg)
    f:write(logMsg, '\n')
  end
end

function onPoll()
  if emu.read(playState, emu.memType.cpuDebug) == 1 then
    log('POLL')
  end
end

function onGameStateChange(address, state)
  oldState = emu.read(playState, emu.memType.cpuDebug)
  if oldState ~= 1 and state == 1 then
    log('PIECE SPAWN')
  end
  if oldState == 1 and state ~= 1 then
    log('PIECE LOCK')
  end
end

-- setup callbacks
function createCallback()

end

function clean()
  f:close()
end

emu.addMemoryCallback(onPoll, emu.memCallbackType.cpuExec, poll)
emu.addMemoryCallback(onGameStateChange, emu.memCallbackType.cpuWrite, playState)
emu.addEventCallback(clean, emu.eventType.scriptEnded)