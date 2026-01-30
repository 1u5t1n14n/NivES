{ config, pkgs,  ... }:

{

	programs.nixvim.plugins = {
		hardtime.enable = false;
		lualine.enable = true;
		which-key.enable = true;

		web-devicons.enable = config.programs.nixvim.plugins.telescope.enable;
		telescope = {
			enable = true;
			extensions.ui-select.enable = true;
		};

		treesitter = {
			enable = true;
			settings = {
				ensureInstalled = [ "latex" "nix" "c" "bash" "html" "markdown" "lua" ];
				indent.enable = true;
				highlight = {
					enable = true;
					additional_vim_regex_highlighting = true;
				};
			};
		};

		vimtex = {
			enable = true;
			texlivePackage = pkgs.texliveFull;
			settings = {
				compiler_method = "latexrun";
				view_method = "mupdf";
			};
		};
	};


}
