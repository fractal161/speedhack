logging = true

startTime = os.date('%Y-%m-%d-%H%M%S')
path = '/home/justin/Tetris/nes/hacks/nes-tetris-infinity/log'
logFileName = string.format('%s/%s.txt', path, startTime)
f = io.open(logFileName, 'w')

f:write('INFINITY v0.3\n')
f:write('----\n')

emu.log(emu.getRomInfo().name)
if emu.getRomInfo().name == 'Tetris.nes' then
  playState = emu.getLabelAddress('player1_playState')
else
  playState = emu.getLabelAddress('playState')
end
poll = emu.getLabelAddress('pollController')
gameLoopStart = emu.getLabelAddress('shift_tetrimino')
gameModeState = emu.getLabelAddress('gameModeState')

unprocessedPolls = 1

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

-- Polling
function onPoll()
  if emu.read(playState, emu.memType.cpuDebug) == 1 and
    (emu.read(gameModeState, emu.memType.cpuDebug) == 2
    or emu.read(gameModeState, emu.memType.cpuDebug) == 4) then
    unprocessedPolls = unprocessedPolls + 1
    log('POLL', string.format('%d unprocessed', unprocessedPolls))
  end
end

-- Piece spawn/lock
function onGameStateChange(address, state)
  oldState = emu.read(playState, emu.memType.cpuDebug)
  if oldState ~= 1 and state == 1 then
    log('PIECE SPAWN')
  end
  if oldState == 1 and state ~= 1 then
    log('PIECE LOCK')
    unprocessedPolls = 0
  end
end

-- Processing polls
function onGameLoopStart(address, state)
  unprocessedPolls = unprocessedPolls - 1
  log('GAME CYCLE', string.format('%d unprocessed', unprocessedPolls))
end

-- setup callbacks
function createCallback()

end

function clean()
  f:close()
end

emu.addMemoryCallback(onPoll, emu.memCallbackType.cpuExec, poll)
emu.addMemoryCallback(onGameStateChange, emu.memCallbackType.cpuWrite, playState)
emu.addMemoryCallback(onGameLoopStart, emu.memCallbackType.cpuExec, gameLoopStart)

emu.addEventCallback(clean, emu.eventType.scriptEnded)