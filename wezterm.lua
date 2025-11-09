local wezterm = require 'wezterm'

local NORMAL = {
  window_background_opacity = 0.30,
}
-- 省电：二选一
local POWERSAVE_TRANSPARENT = {
  window_background_opacity = 0.0,
  background = nil,
}
local POWERSAVE_BLACK = {
  window_background_opacity = 1.0,
  background = { { source = { Color = "#000000" }, opacity = 1.0 } },
}

local POWERSAVE = POWERSAVE_BLACK

-- 当前模式
local current_mode = nil  -- 'NORMAL' or 'PSAVE'

local function apply_mode(window, which)
  if current_mode == which then return end
  current_mode = which
  local T = (which == 'PSAVE') and POWERSAVE or NORMAL
  local o = window:get_config_overrides() or {}

  o.window_background_opacity = T.window_background_opacity
  if T.background ~= nil then
    o.background = T.background
  else
    o.background = nil
  end

  window:set_config_overrides(o)
  window:toast_notification("WezTerm", (which == 'PSAVE') and "Powersave" or "Normal", 1800)
end

wezterm.on("toggle-powersave", function(window, _)
  apply_mode(window, (current_mode == 'PSAVE') and 'NORMAL' or 'PSAVE')
end)

local function best_effort_auto(window)
  local bat = wezterm.battery_info()
  if not bat or #bat == 0 then
    apply_mode(window, 'NORMAL'); return
  end
  local on_batt = false
  for _, b in ipairs(bat) do
    if b.state == "Discharging" or b.state == "Unknown" then on_batt = true; break end
  end
  apply_mode(window, on_batt and 'PSAVE' or 'NORMAL')
end
wezterm.on("window-config-reloaded", function(w, _) best_effort_auto(w) end)
wezterm.on("window-focus-changed",   function(w, _) best_effort_auto(w) end)

return {
  launch_menu = {
    { label = "Fedora 40", args = { "wsl.exe", "-d", "Fedora" } },
    { label = "NixOS",     args = { "wsl.exe", "-d", "NixOS"  } },
  },
  default_prog = { "wsl.exe", "-d", "Fedora", "--cd", "~"},

  font = wezterm.font_with_fallback({
    "Zneva",
    "Noto Sans Mono CJK SC",
  }),
  font_size = 14,

  win32_system_backdrop = "Acrylic",
  window_background_opacity = NORMAL.window_background_opacity,
  macos_window_background_blur = 20,  -- 仅 macOS 有效

  window_decorations = "RESIZE",
  enable_tab_bar = false,

  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  show_new_tab_button_in_tab_bar = false,
  window_padding = { left = 8, right = 8, top = 4, bottom = 4 },

  adjust_window_size_when_changing_font_size = false,
  inactive_pane_hsb = { saturation = 0.8, brightness = 0.8 },

  keys = {
    { key = "N", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
    -- 手动切换省电：Ctrl+Shift+P
    { key = "P", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent('toggle-powersave') },
  },
  mouse_bindings = {
    { event = { Down = { streak = 1, button = "Left" } }, mods = "ALT", action = wezterm.action.StartWindowDrag },
  },

  max_fps = 60,
  webgpu_power_preference = "HighPerformance",
}
