signs = {
  Error = "",

  Warn = "",
  Hint = "",
  Info = "",
  GitAdded = "",
  GitModified = "",
  GitRemoved = "",
  GitRenamed = "",
  Running = "",
  PassCheck = "",
  CheckAlt = " ",
  Forbidden = "",
  FolderClosed = "",
  FolderOpen = "",
  FolderEmpty = "",
  FolderEmptyOpen = "",
  LightBulb = "",
  Config = "",
  Branch = "",

  Code = " ",
  Package = " ",
  Keyboard = " ",
  File = " ",
  Vim = " ",

  QuestionMark = " ",
  Loading = " ",

  Cmd = " ",
  Event = " ",
  Init = " ",
  Expanded = "",
  Collapsed = "",
  Bookmark = "",
  PendingSave = "",
  Left = "",

  Right = "",
}



return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
  },
  opts = {
      ensure_installed = { "cpptools" },
    ui = {
      icons = {
        package_installed = signs.PassCheck,
        package_pending = signs.Running,
        package_uninstalled = signs.GitRemoved,
      },
    },
  },
}
