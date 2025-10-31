return {
  "ok97465/ipybridge.nvim",
  config = function()
    require("ipybridge").setup({

      profile_name = "vim",           -- or nil to omit --profile
      startup_script = "import_in_console.py", -- looked up in CWD
      sleep_ms_after_open = 1000,      -- defer init to allow IPython to start
      set_default_keymaps = true,      -- applies by default (can set false)

      -- Matplotlib backend / ion
      matplotlib_backend = nil,        -- 'qt'|'tk'|'macosx'|'inline' or 'QtAgg'|'TkAgg'|'MacOSX'
      matplotlib_ion = true,           -- call plt.ion() on startup

      -- Spyder-like runcell support
      prefer_runcell_magic = false,    -- run cells via helper instead of raw text
      runcell_save_before_run = true,  -- save buffer before runcell to use up-to-date file
      runfile_save_before_run = true,  -- save buffer before runfile to use up-to-date file

      debugfile_save_before_run = true, -- save buffer before debugfile to use up-to-date file

      -- Variable explorer / preview (ZMQ backend)
      use_zmq = true,                  -- requires ipykernel + jupyter_client + pyzmq

      viewer_max_rows = 30,

      viewer_max_cols = 20,

      -- Autoreload: 1, 2, or 'disable' (default 2)
      autoreload = 2,
    })
  end,
}
