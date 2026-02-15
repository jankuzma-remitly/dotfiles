--[[
  Yabai Hotkey Configuration File (init.lua)
  
  This configuration uses Hammerspoon to intercept hotkeys and executes
  the yabai commands by hardcoding the full binary path directly into 
  each hs.execute call, eliminating shell environment and path concerns.
  
  Assumes yabai is installed via Homebrew at /opt/homebrew/bin/yabai.
]]

-- =========================================================================
-- SYSTEM UTILITIES
-- =========================================================================

-- Reload Hammerspoon Config (Cmd + Alt + Ctrl + R)
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	hs.reload()
end)
-- float a window
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "F", function()
	hs.execute("/opt/homebrew/bin/yabai -m window --toggle float")
end)

-- Initial alert to confirm the configuration loaded successfully
hs.alert.show("Hammerspoon (Yabai) Config Loaded")

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "[", function()
	hs.execute("/opt/homebrew/bin/yabai --stop-service")
	hs.alert.show("Yabai (OFF)")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "]", function()
	hs.execute("/opt/homebrew/bin/yabai --start-service")
	hs.alert.show("Yabai (ON)")
end)
-- =========================================================================
-- WINDOW NAVIGATION (alt - h/j/k/l)
-- =========================================================================

-- Focus windows with Ctrl+Alt+H/J/K/L
hs.hotkey.bind({ "ctrl", "alt" }, "H", function() hs.execute("/opt/homebrew/bin/yabai -m window --focus west") end)
hs.hotkey.bind({ "ctrl", "alt" }, "J", function() hs.execute("/opt/homebrew/bin/yabai -m window --focus south") end)
hs.hotkey.bind({ "ctrl", "alt" }, "K", function() hs.execute("/opt/homebrew/bin/yabai -m window --focus north") end)
hs.hotkey.bind({ "ctrl", "alt" }, "L", function() hs.execute("/opt/homebrew/bin/yabai -m window --focus east") end)
hs.hotkey.bind({ "ctrl", "alt" }, "S", function() hs.execute("/opt/homebrew/bin/yabai -m display --focus west") end)
hs.hotkey.bind({ "ctrl", "alt" }, "G", function() hs.execute("/opt/homebrew/bin/yabai -m display --focus east") end)

-- Rebalance all tiled windows on the current space (Ctrl+Alt+E)
hs.hotkey.bind({ "ctrl", "alt" }, "E", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --balance")
end)

-- Resize focused window (grow/shrink) with Ctrl+Alt+= / Ctrl+Alt+-
hs.hotkey.bind({ "ctrl", "alt" }, "=", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --ratio rel:+0.05")
end)
hs.hotkey.bind({ "ctrl", "alt" }, "-", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --ratio rel:-0.05")
end)
-- Switch space layout (Ctrl+Alt+1/2/3)
hs.hotkey.bind({ "ctrl", "alt" }, "1", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout bsp")
end)
hs.hotkey.bind({ "ctrl", "alt" }, "2", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout stack")
end)
hs.hotkey.bind({ "ctrl", "alt" }, "3", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout float")
end)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function()
  -- Get the full paths from user's shell
  local yabaiPath = hs.execute("echo $HOME/.local/bin/yabai"):gsub("%s+", "")
  
  -- Try common locations
  local possiblePaths = {
    "/opt/homebrew/bin/yabai",
    "/usr/local/bin/yabai",
    yabaiPath
  }
  
  local yabai = nil
  for _, path in ipairs(possiblePaths) do
    if hs.fs.attributes(path) then
      yabai = path
      break
    end
  end
  
  if not yabai then
    hs.alert.show("Cannot find yabai")
    return
  end
  
  local script = string.format([[
    WIN_ID=$(%s -m query --windows --window | jq '.id') && \
    %s -m window --display recent && \
    %s -m window --focus $WIN_ID
  ]], yabai, yabai, yabai)
  
  local output, status = hs.execute(script)
  if not status then
    hs.alert.show("Error: " .. (output or "unknown"))
  end
end)