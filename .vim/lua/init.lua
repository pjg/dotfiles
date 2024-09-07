------------
-- [nvim] --
------------

-- [copilot.lua]

require('copilot').setup({
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
require('CopilotChat.integrations.cmp').setup()



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
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
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

local lspconfig = require('lspconfig')

-- nvim-cmp almost supports LSP's capabilities so it should be advertised to LSP servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- configures/enables ruby diagnostics and formatting via rubocop/ruby-lsp
lspconfig.ruby_lsp.setup({
  capabilities = capabilities,
  cmd = { 'ruby-lsp' },
  settings = {
    rubocop = {
      enabled = true,
      -- automatically apply RuboCop autocorrections on save
      autocorrect = true,
    }
  }
})



-- [conform.nvim]

require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    -- ruby = { 'rubyfmt' }, -- temporarily disabled
  },

  -- enable sync formatting
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = false,
  },

  -- tweak formatter's configuration
  formatters = {
    -- disable rubyfmt for spec files
    -- https://github.com/fables-tales/rubyfmt/pull/410#issuecomment-1849027463
    rubyfmt ={
      condition = function(ctx)
        return string.find(vim.fs.basename(ctx.filename), '%a_spec.rb') == nil
      end,
    },
  }
})



-- [nvim-lspconfig]: rubocop

-- rubyfmt and then rubocop on rubyfmt's output
-- must be defined after conform.nvim, so that rubocop formatting runs after rubyfmt
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.rb',
  callback = function()
    -- on-save formatting via rubocop
    vim.lsp.buf.format()
  end,
})

-- prettier and then eslint on prettier's output
-- must be defined after conform.nvim's autocmd, so that eslint formatting runs after prettier
lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'EslintFixAll',
    })
  end,
})
