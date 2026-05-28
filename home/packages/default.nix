{pkgs, inputs, system, ...}: builtins.concatLists [
	(import ./CCPP.nix pkgs)
	(import ./apps.nix pkgs)
	(import ./cli.nix pkgs)
	(import ./custom.nix pkgs)
	(import ./tex.nix pkgs)
	(import ./viewers.nix pkgs)
	(import ./wayland.nix pkgs)
	(import ./neovim.nix {inherit inputs system;})
]
