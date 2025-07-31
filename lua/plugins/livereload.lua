return {
    'barrett-ruth/live-server.nvim',
    build = 'npm install -g live-server',
ft = {"html","js","css","scss","md","tex"},
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = true
}
