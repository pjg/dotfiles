----------------
-- [cmp.nvim] --
----------------

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'

cmp.setup({
  performance = {
    max_view_entries = 15, -- limit the number of items to display in the completion menu
  },

  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },

  -- setup keys for nvim-cmp
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})


----------------------
-- [nvim-lspconfig] --
----------------------

local lspconfig = require("lspconfig")

-- nvim-cmp almost supports LSP's capabilities so it should be advertised to LSP servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- configures/enables ruby diagnostics
lspconfig.ruby_ls.setup({
  capabilities = capabilities,
  cmd = { "ruby-lsp" },
})

-- starts rubocop in LSP mode for diagnostics and formatting
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rubocop
lspconfig.rubocop.setup({
  capabilities = capabilities,
  cmd = { "rubocop", "--lsp" },
})

-- make Ruby LSP diagnostics available
-- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#neovim-lsp
_timers = {}

local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)

    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end

      local diagnostic_items = {}

      if result then
        diagnostic_items = result.items
      end

      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end

      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,

    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

lspconfig.ruby_ls.setup({
  on_attach = function(client, buffer)
    setup_diagnostics(client, buffer)
  end,
})



--------------------
-- [conform.nvim] --
--------------------

require("conform").setup({
  formatters_by_ft = {
    ruby = { "rubyfmt" },
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
        return string.find(vim.fs.basename(ctx.filename), "%a_spec.rb") == nil
      end,
    },
  }
})



-------------------------------
-- [nvim-lspconfig]: rubocop --
-------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    -- enable on-save formatting via rubocop
    -- must be defined after conform.nvim's autocmd, so that rubocop formatting runs after rubyfmt
    vim.lsp.buf.format()
  end,
})
