local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- config.term = 'wezterm'
config.initial_cols = 115
config.initial_rows = 35
config.default_cursor_style = 'SteadyBlock'
config.enable_scroll_bar = true
-- config.font = wezterm.font 'MesloLGS NF'
config.font_size = 11
-- config.color_scheme = 'IR Black (base16)'
config.color_scheme = 'Moonfly (Gogh)'

config.keys = {
  { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
  { key = 'Home', mods = 'SHIFT', action = act.ScrollToTop },
  { key = 'End', mods = 'SHIFT', action = act.ScrollToBottom },
  { key = 'z', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(-1) },
  { key = 'X', mods = 'CTRL|SHIFT', action = act.ScrollToPrompt(1) },
  { key = 'X', mods = 'CTRL|SHIFT|ALT', action = act.ActivateCopyMode },
  { key = 'T', mods = 'CTRL|SHIFT|ALT', action = act.SpawnCommandInNewTab {
      cwd = wezterm.home_dir
    }
  },

  -- New tab SSH handler
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local info = pane:get_foreground_process_info()

      if info and info.argv then
        local cmd_args = {}
        -- Copy the original args (e.g., {"ssh", "-p", "2222", "user@host"})
        for _, v in ipairs(info.argv) do
          table.insert(cmd_args, v)
        end

        -- Check if the command is SSH
        if cmd_args[1]:match("^ssh$") then
          -- Get the current working directory from OSC 7
          local cwd_uri = pane:get_current_working_dir()

          local spawn_args = {
            args = cmd_args,
            cwd = wezterm.home_dir,
          }

          if cwd_uri.host ~= wezterm.hostname() then
            -- Construct the remote command: cd /path; exec $SHELL -l
            -- We use 'exec $SHELL -l' to replace the temporary shell with an interactive one
            local remote_cmd = string.format("cd %q ; exec $SHELL -l", cwd_uri.file_path)

            -- Append flags to force pseudo-terminal (-t) and run the command
            -- We insert "-t" after "ssh" to ensure the remote shell is interactive
            table.insert(cmd_args, 2, "-t")
            table.insert(cmd_args, remote_cmd)
          end

          -- Spawn the new tab with these args
          window:perform_action(act.SpawnCommandInNewTab(spawn_args), pane)
          return
        end
      end

      -- Fallback to just opening a normal tab
      window:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)
    end),
  },
  -- Rename current workspace
  {
    key = 'r',
    mods = 'CTRL|ALT',
    action = act.PromptInputLine {
      description = 'Enter new workspace name',
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end
      ),
    },
  },
  -- Prompt for a name to use for a new workspace and switch to it.
  {
    key = 'w',
    mods = 'CTRL|ALT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  -- Perplexity
  {
    key = 'a',
    mods = 'SUPER',
    action = act.PromptInputLine({
      description = "🤖 Enter AI prompt:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.ResetTerminal, pane)
          pane:inject_output("🤖 AI is thinking...")
          local ok, success, stdout, stderr = pcall(
            wezterm.run_child_process, { "pp", line }
          )
          window:perform_action(act.ResetTerminal, pane)

          if ok and success then
            local formatted_stdout = stdout:gsub("\n", "\r\n")
            pane:inject_output(formatted_stdout)
          else
            local error_msg = "❌ AI request failed: "
            local formatted_err = ""

            if ok then
              formatted_err = stderr:gsub("\n", "\r\n")
            else
              formatted_err = tostring(success):gsub("\n", "\r\n")
            end

            pane:inject_output("\r\n" .. error_msg .. formatted_err)
          end

          pane:inject_output("\r\n\r\n")
          pane:send_text("\r")
          window:perform_action(act.ScrollToTop, pane)
        end
      end),
    }),
  },
}

for i = 1, 8 do
  -- ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
end

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL|ALT',
    action = act.SelectTextAtMouseCursor 'Block',
  },
  {
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'CTRL|ALT',
    action = act.ExtendSelectionToMouseCursor 'Block',
  },
  {
    event = { Down = { streak = 2, button = 'Right' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'SemanticZone',
  },
}

--

local function is_shell(foreground_process_name)
  local shell_names = { 'bash', 'zsh', 'fish', 'sh', 'ksh', 'dash' }
  local process = string.match(foreground_process_name, '[^/\\]+$')
    or foreground_process_name
  for _, shell in ipairs(shell_names) do
    if process == shell then
      return true
    end
  end
  return false
end

wezterm.on('open-uri', function(window, pane, uri)
  local editor = 'vim'

  if uri:find '^file:' == 1 and not pane:is_alt_screen_active() then
    -- We're processing an hyperlink and the uri format should be: file://[HOSTNAME]/PATH[#linenr]
    -- Also the pane is not in an alternate screen (an editor, less, etc)
    local url = wezterm.url.parse(uri)
    if is_shell(pane:get_foreground_process_name()) then
      -- A shell has been detected. Wezterm can check the file type directly
      -- figure out what kind of file we're dealing with
      local success, stdout, _ = wezterm.run_child_process {
        'file',
        '--brief',
        '--mime-type',
        url.file_path,
      }
      if success then
        if stdout:find 'directory' then
          pane:send_text(
            wezterm.shell_join_args { 'cd', url.file_path } .. '\r'
          )
          -- pane:send_text(wezterm.shell_join_args {
          --   'ls',
          --   '-F',
          --   '--group-directories-first',
          -- } .. '\r')
          return false
        end

        if stdout:find 'text' then
          if url.fragment then
            pane:send_text(wezterm.shell_join_args {
              editor,
              '+' .. url.fragment,
              url.file_path,
            } .. '\r')
          else
            pane:send_text(
              wezterm.shell_join_args { editor, url.file_path } .. '\r'
            )
          end
          return false
        end
      end
    else
      -- No shell detected, we're probably connected with SSH, use fallback command
      local edit_cmd = url.fragment
          and editor .. ' +' .. url.fragment .. ' "$_f"'
        or editor .. ' "$_f"'
      local cmd = '_f="'
        .. url.file_path
        .. '"; { test -d "$_f" && { cd "$_f" ; ls -a -p --hyperlink --group-directories-first; }; } '
        .. '|| { test "$(file --brief --mime-type "$_f" | cut -d/ -f1 || true)" = "text" && '
        .. edit_cmd
        .. '; }; echo'
      pane:send_text(cmd .. '\r')
      return false
    end
  end

  -- without a return value, we allow default actions
end)

-- Plugins

local presentation = wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez")
local sessions = wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")

presentation.apply_to_config(config)
sessions.apply_to_config(config)

return config
