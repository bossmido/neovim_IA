return {
  'Adarsh-Roy/gthr.nvim',
  version = 'v0.1.0',
  cmd = { 'Gthr', 'GthrBuffersInteractive', 'GthrBuffersDirect' },
  keys = {
    { '<leader>Go', '<cmd>Gthr<cr>', desc = 'Open gthr in floating window' },
    { '<leader>Gbi', '<cmd>GthrBuffersInteractive<cr>', desc = 'Open gthr floating window with all open buffers pre-included' },
    { '<leader>Gbd', '<cmd>GthrBuffersDirect<cr>', desc = 'Copy context for all open buffers directly' },
  },
  opts = {},
}
