{ pkgs, ... }:
{
#	programs.nixvim = {
#		enable = true;
#		imports = [./nixvim.nix];
#		extraPackages = with pkgs; [
#			tree-sitter
#			alejandra
#			tex-fmt
#			stylua
#			nil
#			lua-language-server
#			texlab
#			clang-tools
#		];
#		extraPython3Packages =
#			ps: with ps; [
#			pynvim
#			];
#	};
 programs.neovim = {
   enable = true;
   defaultEditor = true;
   # whatever other neovim configuration you have
   extraPackages = with pkgs; [
     tree-sitter

     # formatters
     alejandra
     tex-fmt

     # lsp
     stylua
     nil
     lua-language-server
     texlab
     clang-tools
     omnisharp-roslyn

     imagemagick # for image rendering
   ];
   extraLuaPackages =
     ps: with ps; [
       # ... other lua packages
       magick # for image rendering
     ];
   extraPython3Packages =
     ps: with ps; [
       pynvim
       nbformat
       jupyter-client
       ipykernel
       cairosvg # for image rendering
       pnglatex # for image rendering
       plotly # for image rendering
       pyperclip
     ];
 };
}
