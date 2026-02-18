-- Clawmarchy Neovim AMOLED Overrides
-- Static override -- must be manually updated when palette changes
-- Update: Manual -- accent changes do NOT affect this file (only background overrides)
return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            style = "night",
            on_colors = function(colors)
                colors.bg = "#000000"          -- colors.toml: background
                colors.bg_dark = "#000000"     -- colors.toml: background
                colors.bg_float = "#0a0a12"    -- UNMAPPED: tokyonight-specific dark surface (intentional, not in colors.toml)
                colors.bg_sidebar = "#0a0a12"  -- UNMAPPED: tokyonight-specific dark surface (intentional, not in colors.toml)
            end,
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-night",
        },
    },
}
