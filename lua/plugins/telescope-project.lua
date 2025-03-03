return {
	'nvim-telescope/telescope-project.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    vim.api.nvim_set_keymap( 'n', '<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})

  local project_actions = require("telescope._extensions.project.actions")
    require('telescope').setup {
  extensions = {
    project = {
      base_dirs = {
        {'~/Documents/zmn', max_depth = 3},
        {'~/Documents/Projects', max_depth = 3},
        {'~/Documents/LEARNING', max_depth = 3},
      },
      hidden_files = true, -- default: false
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      sync_with_nvim_tree = true, -- default false
      -- default for on_project_selected = find project files
      on_project_selected = function(prompt_bufnr)
        -- Do anything you want in here. For example:
        project_actions.change_working_directory(prompt_bufnr, false)
      end,
      mappings = {
        n = {
          ['d'] = project_actions.delete_project,
          ['r'] = project_actions.rename_project,
          ['c'] = project_actions.add_project,
          ['C'] = project_actions.add_project_cwd,
          ['f'] = project_actions.find_project_files,
          ['b'] = project_actions.browse_project_files,
          ['s'] = project_actions.search_in_project_files,
          ['R'] = project_actions.recent_project_files,
          ['w'] = project_actions.change_working_directory,
          ['o'] = project_actions.next_cd_scope,
        },
        i = {
          ['<c-d>'] = project_actions.delete_project,
          ['<c-v>'] = project_actions.rename_project,
          ['<c-a>'] = project_actions.add_project,
          ['<c-A>'] = project_actions.add_project_cwd,
          ['<c-f>'] = project_actions.find_project_files,
          ['<c-b>'] = project_actions.browse_project_files,
          ['<c-s>'] = project_actions.search_in_project_files,
          ['<c-r>'] = project_actions.recent_project_files,
          ['<c-l>'] = project_actions.change_working_directory,
          ['<c-o>'] = project_actions.next_cd_scope,
          ['<c-w>'] = project_actions.change_workspace,
        }
      }
    }
  }
}
  end,
}
