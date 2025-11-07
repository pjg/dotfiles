------------
-- [nvim] --
------------

-- native nvim LSP support
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})



-- [substitute.nvim]

require('substitute').setup()

-- substitute operator
vim.keymap.set('n', 's', require('substitute').operator, { noremap = true })
vim.keymap.set('n', 'ss', require('substitute').line, { noremap = true })
vim.keymap.set('n', 'S', require('substitute').eol, { noremap = true })
vim.keymap.set('x', 's', require('substitute').visual, { noremap = true })

-- exchange operator
vim.keymap.set('n', 'sx', require('substitute.exchange').operator, { noremap = true })
vim.keymap.set('n', 'sxx', require('substitute.exchange').line, { noremap = true })
vim.keymap.set('x', 'X', require('substitute.exchange').visual, { noremap = true })
vim.keymap.set('n', 'sxc', require('substitute.exchange').cancel, { noremap = true })



-- [nvim-treesitter]

require('nvim-treesitter.configs').setup {
  -- list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { 'lua', 'vim', 'vimdoc', 'ruby', 'javascript', 'markdown', 'markdown_inline' },

  -- install parsers synchronously (applies to `ensure_installed`)
  sync_install = true,

  -- automatically install missing parsers when entering buffer
  auto_install = true,

  -- syntax highlighting
  highlight = {
    -- disable syntax highlighting; it is inferior to regular vim syntax highlighting
    enable = false,

    -- setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- using this option may slow down your editor, and you may see some duplicate highlights.
    -- instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn', -- set to `false` to disable one of the mappings
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },

  -- enables vim-matchup integration
  matchup = {
    enable = true,
  },
}



-- [copilot.lua]

require('copilot').setup({
  filetypes = {
    sh = function ()
      if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
        -- disable for .env files
        return false
      end
      return true
    end,
  },
  suggestion= {
    enabled = true,
    auto_trigger = true, -- automatically/always request copilot completion when in insert mode

    keymap = {
      accept = '<C-p>',
      next = '<C-n>',
      prev = '<C-N>',
      dismiss = '<C-]>',
    },
  },

  panel = {
    enabled = false,
  },
})

local copilotSuggestion = require('copilot.suggestion')



-- [CopilotChat.nvim]

local chat = require('CopilotChat')

-- disable default <tab> complete mapping for copilot chat when doing this
chat.setup({
  model = 'claude-sonnet-4.5',
  mappings = {
    complete = {
      insert = '',
    },
  },
})

-- code related commands
vim.keymap.set({ 'n', 'x' }, '<leader>ae', '<cmd>CopilotChatExplain<cr>', { desc = 'CopilotChat - Explain code', noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<leader>at', '<cmd>CopilotChatTests<cr>', { desc = 'CopilotChat - Generate tests', noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<leader>ar', '<cmd>CopilotChatReview<cr>', { desc = 'CopilotChat - Review code', noremap = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<leader>ao', '<cmd>CopilotChatOptimize<cr>', { desc = 'CopilotChat - Refactor code', noremap = true, silent = true })

-- reset chat
vim.keymap.set({ 'n', 'x' }, '<leader>al', '<cmd>CopilotChatReset<cr>', { desc = 'CopilotChat - Clear buffer and chat history', noremap = true, silent = true })

-- toggle Copilot Chat Vsplit
vim.keymap.set({ 'n', 'x' }, '<leader>av', '<cmd>CopilotChatToggle<cr>', { desc = 'CopilotChat - Toggle', noremap = true, silent = true })

-- generate commit message for all changes
vim.keymap.set({ 'n', 'x' }, '<leader>am', '<cmd>CopilotChatCommit<cr>', { desc = 'CopilotChat - Generate commit message for all changes', noremap = true, silent = true })

-- inline chat
vim.keymap.set({ 'n', 'x' }, '<leader>ai', function()
  local input = vim.fn.input("Quick Copilot chat: ")

  if input ~= "" then
    chat.ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, { desc = "CopilotChat - Quick chat", noremap = true, silent = true })

-- registers copilot-chat as cmp source and enables it for copilot-chat filetype (copilot chat window)
chat.config.chat_autocomplete = true



-- [cmp.nvim]

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')

cmp.setup({
  performance = {
    max_view_entries = 15, -- limit the number of items to display in the completion menu
    debounce = 0, -- default is 60ms
    throttle = 0, -- default is 30ms
  },

  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  -- setup keys for nvim-cmp
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- let copilot.vim handle the <C-p> and <C-n> mapppings
    ['<C-p>'] = cmp.mapping(function(fallback)
      -- check if Copilot suggestion is visible and then accept it; otherwise do nothing
      if copilotSuggestion.is_visible() then
        copilotSuggestion.accept()
      end
    end, { 'i', 's' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      -- next suggestion
      if copilotSuggestion.is_visible() then
        copilotSuggestion.next()
      end
    end, { 'i', 's' }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- automaticaly inserts highlighted item into buffer
        cmp.select_next_item()
        cmp.mapping.confirm({ select = false })
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        -- fallback function sends an already mapped key
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      else
        -- fallback function sends an already mapped key
        fallback()
      end
    end, { 'i', 's' }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- configuration for specific filetypes
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
})



-- [nvim-lspconfig]

-- nvim-cmp almost supports LSP's capabilities so it should be advertised to LSP servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- configures/enables ruby diagnostics and formatting via rubocop/ruby-lsp
vim.lsp.config['ruby_lsp'] = {
  cmd = { 'ruby-lsp' },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable semantic tokens (syntax highlighting via LSP)
    client.server_capabilities.semanticTokensProvider = nil

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  end,
  settings = {
    rubocop = {
      enabled = true,
      -- automatically apply RuboCop autocorrections on save
      autocorrect = true,
    }
  }
}

-- start per Ruby buffer
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ruby', 'eruby', 'rake', 'rbs' },
  callback = function()
    vim.lsp.start(vim.lsp.config['ruby_lsp'])
  end,
})



-- [conform.nvim] prettier formatting for javascript

require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
  },

  -- enable sync formatting
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },
})



-- [nvim-lspconfig]: rubocop

-- before save formatting via rubocop
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- loads ESLint LSP server config from lspconfig
vim.lsp.enable('eslint')

-- prettier and then eslint on prettier's output
-- must be defined after conform.nvim's autocmd, so that eslint formatting runs after prettier
local base_on_attach = vim.lsp.config.eslint.on_attach

vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    if not base_on_attach then return end

    base_on_attach(client, bufnr)

    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        -- schedule eslint to run after prettier
        vim.schedule(function()
          vim.cmd('LspEslintFixAll')

          -- schedule, so eslint can run after file has been saved already
          -- check if modified, and save (again)
          if vim.bo.modified then
            vim.cmd('write')
          end
        end)
      end,
    })
  end,
})
