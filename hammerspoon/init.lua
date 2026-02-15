--[[
  Hammerspoon Configuration
  Window management via yabai
]]

-- =========================================================================
-- SYSTEM UTILITIES
-- =========================================================================

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
  hs.reload()
end)

hs.alert.show("Hammerspoon Config Loaded")

-- =========================================================================
-- YABAI CONTROL
-- =========================================================================

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "[", function()
  hs.execute("/opt/homebrew/bin/yabai --stop-service")
  hs.alert.show("Yabai (OFF)")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "]", function()
  hs.execute("/opt/homebrew/bin/yabai --start-service")
  hs.alert.show("Yabai (ON)")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "\\", function()
  hs.execute("/opt/homebrew/bin/yabai --restart-service")
  hs.alert.show("Yabai Restarted")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "0", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout stack")
  hs.execute("/opt/homebrew/bin/yabai -m space --layout bsp")
  hs.alert.show("Windows Reset")
end)

-- =========================================================================
-- WINDOW NAVIGATION
-- =========================================================================

hs.hotkey.bind({ "ctrl", "alt" }, "H", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --focus west")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "J", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --focus south")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "K", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --focus north")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "L", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --focus east")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "S", function()
  hs.execute("/opt/homebrew/bin/yabai -m display --focus west")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "G", function()
  hs.execute("/opt/homebrew/bin/yabai -m display --focus east")
end)

-- =========================================================================
-- WINDOW SWAPPING
-- =========================================================================

hs.hotkey.bind({ "ctrl", "alt", "shift" }, "H", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --swap west")
end)

hs.hotkey.bind({ "ctrl", "alt", "shift" }, "J", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --swap south")
end)

hs.hotkey.bind({ "ctrl", "alt", "shift" }, "K", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --swap north")
end)

hs.hotkey.bind({ "ctrl", "alt", "shift" }, "L", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --swap east")
end)

-- =========================================================================
-- LAYOUT SWITCHING
-- =========================================================================

local savedBSPLayouts = {}
local quickslotsFile = os.getenv("HOME") .. "/.hammerspoon/quickslots.json"
local quickslots = {}

local function loadQuickslots()
  local file = io.open(quickslotsFile, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local success, decoded = pcall(hs.json.decode, content)
    if success then
      quickslots = decoded
      hs.alert.show("Quickslots loaded")
    end
  end
end

local function saveQuickslotsToFile()
  local file = io.open(quickslotsFile, "w")
  if file then
    file:write(hs.json.encode(quickslots))
    file:close()
  end
end

local function saveBSPLayoutToSlot(slot)
  local displayData = hs.execute("/opt/homebrew/bin/yabai -m query --displays --display | jq -c '.frame' 2>/dev/null")
  local windows = hs.execute("/opt/homebrew/bin/yabai -m query --windows --space 2>/dev/null")

  displayData = displayData:gsub("Now using node[^\n]*\n", ""):gsub("^%s+", ""):gsub("%s+$", "")
  windows = windows:gsub("Now using node[^\n]*\n", ""):gsub("^%s+", ""):gsub("%s+$", "")

  if not windows or windows == "" then
    hs.alert.show("Error: No windows found")
    return
  end

  if not displayData or displayData == "" then
    hs.alert.show("Error: No display data")
    return
  end

  local success, displayFrame = pcall(hs.json.decode, displayData)
  if not success then
    hs.alert.show("Error decoding display data")
    return
  end

  local success2, windowList = pcall(hs.json.decode, windows)
  if not success2 then
    hs.alert.show("Error decoding windows")
    return
  end

  local spaceWidth = displayFrame.w
  local spaceHeight = displayFrame.h

  local ratioWindows = {}
  for _, win in ipairs(windowList) do
    table.insert(ratioWindows, {
      id = win.id,
      w_ratio = win.frame.w / spaceWidth,
      h_ratio = win.frame.h / spaceHeight,
      x_ratio = win.frame.x / spaceWidth,
      y_ratio = win.frame.y / spaceHeight
    })
  end

  quickslots[tostring(slot)] = hs.json.encode(ratioWindows)
  saveQuickslotsToFile()
  hs.alert.show("Layout saved to slot " .. slot)
end

local function saveBSPLayout()
  local yabai = "/opt/homebrew/bin/yabai"
  local spaceIndex = hs.execute(yabai .. " -m query --spaces --space | jq -r '.index'"):gsub("%s+", "")
  local windows = hs.execute(yabai .. " -m query --windows --space | jq -c 'map({id, frame})'")

  if windows and spaceIndex then
    savedBSPLayouts[spaceIndex] = windows
  end
end

local function restoreBSPLayoutFromSlot(slot)
  if not quickslots[tostring(slot)] then
    hs.alert.show("No layout saved in slot " .. slot)
    return
  end

  hs.alert.show("Restoring slot " .. slot)

  local displayData = hs.execute("/opt/homebrew/bin/yabai -m query --displays --display | jq -c '.frame' 2>/dev/null")
  displayData = displayData:gsub("Now using node[^\n]*\n", ""):gsub("^%s+", ""):gsub("%s+$", "")

  local success, displayFrame = pcall(hs.json.decode, displayData)
  if not success then
    hs.alert.show("Error reading display data")
    return
  end

  local spaceWidth = displayFrame.w
  local spaceHeight = displayFrame.h

  local success2, savedWindows = pcall(hs.json.decode, quickslots[tostring(slot)])
  if not success2 then
    hs.alert.show("Error decoding saved layout")
    return
  end

  local windowsData = hs.execute("/opt/homebrew/bin/yabai -m query --windows --space 2>/dev/null")
  windowsData = windowsData:gsub("Now using node[^\n]*\n", ""):gsub("^%s+", ""):gsub("%s+$", "")

  local success3, currentWindows = pcall(hs.json.decode, windowsData)
  if not success3 then
    hs.alert.show("Error reading windows")
    return
  end

  if #currentWindows == 0 then
    hs.alert.show("No windows to resize")
    return
  end

  local targetSizes = {}
  for i, saved in ipairs(savedWindows) do
    if currentWindows[i] then
      targetSizes[currentWindows[i].id] = {
        w = math.floor(saved.w_ratio * spaceWidth),
        h = math.floor(saved.h_ratio * spaceHeight)
      }
    end
  end

  if next(targetSizes) == nil then
    hs.alert.show("No matching windows found")
    return
  end

  local tempFile = os.tmpname()
  local file = io.open(tempFile, "w")
  file:write(hs.json.encode(targetSizes))
  file:close()

  local script = string.format([[
    targets=$(cat %s)

    for attempt in {1..3}; do
      echo "$targets" | jq -r 'to_entries | .[] | "\(.key) \(.value.w) \(.value.h)"' | while read id target_w target_h; do
        current_window=$(/opt/homebrew/bin/yabai -m query --windows --window $id 2>/dev/null)
        if [ -z "$current_window" ]; then continue; fi

        current_w=$(echo "$current_window" | jq -r '.frame.w')
        current_h=$(echo "$current_window" | jq -r '.frame.h')

        w_diff=$(echo "$target_w - $current_w" | bc)
        h_diff=$(echo "$target_h - $current_h" | bc)

        w_diff_abs=$(echo "$w_diff" | tr -d '-')
        h_diff_abs=$(echo "$h_diff" | tr -d '-')

        if [ $(echo "$w_diff_abs > 5" | bc) -eq 1 ]; then
          if [ $(echo "$w_diff > 0" | bc) -eq 1 ]; then
            /opt/homebrew/bin/yabai -m window $id --resize right:${w_diff}:0 2>/dev/null
            /opt/homebrew/bin/yabai -m window $id --resize left:-${w_diff}:0 2>/dev/null
          else
            w_diff_abs=$(echo "$w_diff * -1" | bc)
            /opt/homebrew/bin/yabai -m window $id --resize right:-${w_diff_abs}:0 2>/dev/null
            /opt/homebrew/bin/yabai -m window $id --resize left:${w_diff_abs}:0 2>/dev/null
          fi
        fi

        if [ $(echo "$h_diff_abs > 5" | bc) -eq 1 ]; then
          if [ $(echo "$h_diff > 0" | bc) -eq 1 ]; then
            /opt/homebrew/bin/yabai -m window $id --resize bottom:0:${h_diff} 2>/dev/null
            /opt/homebrew/bin/yabai -m window $id --resize top:0:-${h_diff} 2>/dev/null
          else
            h_diff_abs=$(echo "$h_diff * -1" | bc)
            /opt/homebrew/bin/yabai -m window $id --resize bottom:0:-${h_diff_abs} 2>/dev/null
            /opt/homebrew/bin/yabai -m window $id --resize top:0:${h_diff_abs} 2>/dev/null
          fi
        fi
      done
      sleep 0.05
    done
  ]], tempFile)

  hs.execute(script)
  os.remove(tempFile)
  hs.alert.show("Layout restored from slot " .. slot)
end

local function restoreBSPLayout()
  local yabai = "/opt/homebrew/bin/yabai"
  local spaceIndex = hs.execute(yabai .. " -m query --spaces --space | jq -r '.index'"):gsub("%s+", "")

  if not savedBSPLayouts[spaceIndex] then
    hs.execute(yabai .. " -m space --balance")
    return
  end

  local tempFile = os.tmpname()
  local file = io.open(tempFile, "w")
  file:write(savedBSPLayouts[spaceIndex])
  file:close()

  local script = string.format([[
    saved=$(cat %s)

    saved_sorted=$(echo "$saved" | jq -c 'sort_by(.frame.x, .frame.y)')
    current=$(%s -m query --windows --space | jq -c 'sort_by(.frame.x, .frame.y)')

    saved_ids=$(echo "$saved_sorted" | jq -r 'map(.id) | .[]')
    current_ids=$(echo "$current" | jq -r 'map(.id) | .[]')

    saved_array=($saved_ids)
    current_array=($current_ids)

    for i in "${!saved_array[@]}"; do
      saved_id=${saved_array[$i]}
      current_id=${current_array[$i]}

      if [ "$saved_id" != "$current_id" ]; then
        for j in "${!current_array[@]}"; do
          if [ "${current_array[$j]}" = "$saved_id" ]; then
            %s -m window ${current_array[$i]} --swap ${current_array[$j]} 2>/dev/null
            temp=${current_array[$i]}
            current_array[$i]=${current_array[$j]}
            current_array[$j]=$temp
            break
          fi
        done
      fi
    done

    sleep 0.1

    for attempt in {1..3}; do
      echo "$saved" | jq -r '.[] | "\(.id) \(.frame.w) \(.frame.h)"' | while read id target_w target_h; do
        current_window=$(%s -m query --windows --window $id 2>/dev/null)
        if [ -z "$current_window" ]; then continue; fi

        current_w=$(echo "$current_window" | jq -r '.frame.w')
        current_h=$(echo "$current_window" | jq -r '.frame.h')

        w_diff=$(echo "$target_w - $current_w" | bc)
        h_diff=$(echo "$target_h - $current_h" | bc)

        w_diff_abs=$(echo "$w_diff" | tr -d '-')
        h_diff_abs=$(echo "$h_diff" | tr -d '-')

        if [ $(echo "$w_diff_abs > 5" | bc) -eq 1 ]; then
          if [ $(echo "$w_diff > 0" | bc) -eq 1 ]; then
            %s -m window $id --resize right:${w_diff}:0 2>/dev/null
            %s -m window $id --resize left:-${w_diff}:0 2>/dev/null
          else
            w_diff_abs=$(echo "$w_diff * -1" | bc)
            %s -m window $id --resize right:-${w_diff_abs}:0 2>/dev/null
            %s -m window $id --resize left:${w_diff_abs}:0 2>/dev/null
          fi
        fi

        if [ $(echo "$h_diff_abs > 5" | bc) -eq 1 ]; then
          if [ $(echo "$h_diff > 0" | bc) -eq 1 ]; then
            %s -m window $id --resize bottom:0:${h_diff} 2>/dev/null
            %s -m window $id --resize top:0:-${h_diff} 2>/dev/null
          else
            h_diff_abs=$(echo "$h_diff * -1" | bc)
            %s -m window $id --resize bottom:0:-${h_diff_abs} 2>/dev/null
            %s -m window $id --resize top:0:${h_diff_abs} 2>/dev/null
          fi
        fi
      done
      sleep 0.05
    done
  ]], tempFile, yabai, yabai, yabai, yabai, yabai, yabai, yabai, yabai, yabai, yabai, yabai, yabai)

  hs.execute(script)
  os.remove(tempFile)
end

hs.hotkey.bind({ "ctrl", "alt" }, "1", function()
  saveBSPLayout()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout stack")
  hs.alert.show("Stack Layout")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "2", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout bsp")
  hs.timer.doAfter(0.2, restoreBSPLayout)
  hs.alert.show("BSP Layout")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "3", function()
  saveBSPLayout()
  hs.execute("/opt/homebrew/bin/yabai -m space --layout float")
  hs.alert.show("Float Layout")
end)

-- =========================================================================
-- LAYOUT QUICKSLOTS
-- =========================================================================

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "4", function()
  saveBSPLayoutToSlot(1)
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "5", function()
  saveBSPLayoutToSlot(2)
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "6", function()
  saveBSPLayoutToSlot(3)
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "7", function()
  saveBSPLayoutToSlot(4)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "4", function()
  restoreBSPLayoutFromSlot(1)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "5", function()
  restoreBSPLayoutFromSlot(2)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "6", function()
  restoreBSPLayoutFromSlot(3)
end)

hs.hotkey.bind({ "ctrl", "alt" }, "7", function()
  restoreBSPLayoutFromSlot(4)
end)

-- =========================================================================
-- WINDOW MANAGEMENT
-- =========================================================================

hs.hotkey.bind({ "ctrl", "alt" }, "E", function()
  hs.execute("/opt/homebrew/bin/yabai -m space --balance")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "=", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --ratio rel:+0.05")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "-", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --ratio rel:-0.05")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "F", function()
  hs.execute("/opt/homebrew/bin/yabai -m window --toggle float")
end)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "M", function()
  local yabai = "/opt/homebrew/bin/yabai"
  local script = string.format([[
    WIN_ID=$(%s -m query --windows --window | jq '.id') && \
    %s -m window --display recent && \
    %s -m window --focus $WIN_ID
  ]], yabai, yabai, yabai)

  local output, status = hs.execute(script)
  if not status then
    hs.alert.show("Error moving window")
  end
end)

loadQuickslots()
