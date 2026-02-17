return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        opts = {
            style = "night",
            on_colors = function(colors)
                colors.bg = "#000000"
                colors.bg_dark = "#000000"
                colors.bg_float = "#0a0a12"
                colors.bg_sidebar = "#0a0a12"
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
