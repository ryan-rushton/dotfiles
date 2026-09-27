-- WezTerm Configuration
-- Cross-platform terminal configuration for Windows, macOS, and Linux
local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ============================================================================
-- Appearance & Fonts
-- ============================================================================
config.font = wezterm.font_with_fallback({
  'FiraCode Nerd Font',
  'Fira Code',
  'JetBrains Mono',
  'Cascadia Code',
  'Consolas',
})
config.font_size = 11.5

-- Window appearance & title bar
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}
-- Show integrated window management buttons (minimize, maximize, close) in the header
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- Tab bar / Header
-- Keep the header always visible so close buttons, tabs, and the launcher '+' are always accessible
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

-- Native (Fancy) Tab Bar appearance settings
-- (https://wezterm.org/config/appearance.html#native-fancy-tab-bar-appearance)
config.window_frame = {
  font = wezterm.font_with_fallback({
    'FiraCode Nerd Font',
    'Fira Code',
    'Segoe UI',
  }),
  font_size = 10.5,

  -- Title bar / tab bar background colors
  active_titlebar_bg = '#181818',
  inactive_titlebar_bg = '#181818',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_fg = '#969696',

  -- Window controls (minimize, maximize, close) colors in the fancy tab bar
  button_bg = '#181818',
  button_fg = '#cccccc',
  button_hover_bg = '#333333',
  button_hover_fg = '#ffffff',

  -- Border styling
  border_left_color = '#181818',
  border_right_color = '#181818',
  border_bottom_color = '#252526',
  border_top_color = '#181818',
}

-- VSCode-matching dark color theme
config.colors = {
  foreground = '#d4d4d4',
  background = '#1e1e1e',
  cursor_bg = '#d4d4d4',
  cursor_fg = '#1e1e1e',
  cursor_border = '#d4d4d4',
  selection_fg = '#ffffff',
  selection_bg = '#264f78',
  scrollbar_thumb = '#424242',
  split = '#333333',
  ansi = {
    '#1e1e1e',
    '#f44747',
    '#4ec9b0',
    '#ffcc02',
    '#0078d4',
    '#bc05bc',
    '#0598bc',
    '#e5e5e5',
  },
  brights = {
    '#666666',
    '#f44747',
    '#4ec9b0',
    '#ffcc02',
    '#0078d4',
    '#bc05bc',
    '#0598bc',
    '#e5e5e5',
  },
  tab_bar = {
    background = '#181818',
    active_tab = {
      bg_color = '#1e1e1e',
      fg_color = '#ffffff',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#252526',
      fg_color = '#969696',
    },
    inactive_tab_hover = {
      bg_color = '#2d2d2d',
      fg_color = '#cccccc',
    },
    new_tab = {
      bg_color = '#181818',
      fg_color = '#969696',
    },
    new_tab_hover = {
      bg_color = '#2d2d2d',
      fg_color = '#ffffff',
    },
  },
}

-- ============================================================================
-- Default Shell / Launch Menu
-- ============================================================================
local is_windows = wezterm.target_triple:find('windows') ~= nil

if is_windows then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
  config.launch_menu = {
    {
      label = 'PowerShell 7',
      args = { 'pwsh.exe', '-NoLogo' },
    },
    {
      label = 'Windows PowerShell',
      args = { 'powershell.exe', '-NoLogo' },
    },
    {
      label = 'Command Prompt',
      args = { 'cmd.exe' },
    },
    {
      label = 'WSL',
      args = { 'wsl.exe' },
    },
  }
else
  config.default_prog = { '/bin/zsh', '-l' }
end

-- ============================================================================
-- Keybindings
-- ============================================================================
config.keys = {
  -- Clipboard (cross-platform shortcuts)
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },
  { key = 'c', mods = 'CMD', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'CMD', action = act.PasteFrom('Clipboard') },

  -- Split Panes (Alt+Shift+D matches Windows Terminal, Ctrl+Shift+D for vertical)
  {
    key = 'd',
    mods = 'ALT|SHIFT',
    action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
  },
  {
    key = 'x',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentPane({ confirm = false }),
  },

  -- Pane Navigation
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection('Right') },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection('Up') },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection('Down') },

  -- Tabs
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 't', mods = 'CMD', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab({ confirm = false }) },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab({ confirm = false }) },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Search & Command Palette
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search({ CaseSensitiveString = '' }) },
  { key = 'f', mods = 'CMD', action = act.Search({ CaseSensitiveString = '' }) },
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },

  -- Launcher, Config & Debug
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowLauncher },
  { key = 'l', mods = 'CMD|SHIFT', action = act.ShowLauncher },
  { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
  { key = 'r', mods = 'CMD|SHIFT', action = act.ReloadConfiguration },
  { key = 'F12', action = act.ShowDebugOverlay },

  -- Font Size
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

-- On Windows, also support Ctrl+V for quick paste (matches Windows Terminal behaviour)
if is_windows then
  table.insert(config.keys, { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') })
end

return config
