local M = {}

M.dap = {
    plugin = true,
    n = {
      ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "Add Breakpoint at line"},
      ["<leader>dr"] = {"<cmd> DapContinue <CR>", "Start or continue the debugger"}
    }
}

M.dap_python = {
    plugin = true,
    n = {
        ["<leader>dpr"] = {
            function()
                require('dap-python').test_method()
            end
        }
    }
}


M.rust = {
    n = { 
        ["<leader>rrr"] = { "<cmd>RustRunnables<Cr>", "Runnables" },
        ["<leader>rre"] = { "<cmd>RustExpandMacro<Cr>", "Expand Macro" },
        ["<leader>rrc"] = { "<cmd>RustOpenCargo<Cr>", "Open Cargo" },
        ["<leader>rrp"] = { "<cmd>RustParentModule<Cr>", "Parent Module" },
        ["<leader>rrd"] = { "<cmd>RustDebuggables<Cr>", "Debuggables" },
        ["<leader>rrg"] = { "<cmd>RustViewCrateGraph<Cr>", "View Crate Graph" },
        ["<leader>rrj"] = { function() require('rust-tools').join_lines.join_lines() end, "Join Lines" },
        ["<leader>rrt"] = { function() require('rust-tools')._CARGO_TEST() end, "Cargo Test" },
        ["<leader>rrR"] = { function() require('rust-tools/workspace_refresh')._reload_workspace_from_cargo_toml() end, "Reload Workspace" },
        ["<leader>rra"] = { require('custom.configs.rust-tools').hover_actions, "Hover Actions" },
    }
}

M.general = {
    i = {
      ["<C-s>"] = {"<ESC>:w<CR>", "Save in insert mode", opts = { nowait = true }},
    }
}

M.crates = {
    n = {
        ["<leader>rcp"] = {
            function () 
                require('crates').show_popup() 
            end,
            "Show popup" 
        },
        ["<leader>rcr"] = {
            function () require('crates').reload() end, "Reload" },
       
       ["<leader>rcv"] = {
            function () require('crates').show_versions_popup() end, "Show Versions" },
       
       ["<leader>rcf"] = {
            function () require('crates').show_features_popup() end, "Show Features" },
       
       ["<leader>rcd"] = {
            function () require('crates').show_dependencies_popup() end, "Show Dependencies Popup" },
       
       ["<leader>rcu"] = {
            function () require('crates').update_crate() end, "Update Crate" },
       
       ["<leader>rca"] = {
           function () require('crates').update_all_crates() end, "Update All Crates" },
       
       ["<leader>rcU"] = {
           function () require('crates').upgrade_crate() end, "Upgrade Crate" },
       
       ["<leader>rcA"] = {
           function () require('crates').upgrade_all_crates(true) end, "Upgrade All Crates" },
       
       ["<leader>rcH"] = {
           function () require('crates').open_homepage() end, "Open Homepage" },
       
       ["<leader>rcR"] = {
           function () require('crates').open_repository() end, "Open Repository" },
       
       ["<leader>rcD"] = {
           function () require('crates').open_documentation() end, "Open Documentation" },
       
       ["<leader>rcC"] = {
           function () require('crates').open_crates_io() end, "Open Crate.io" },
    },    
}



return M
