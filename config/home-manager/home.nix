{ config, pkgs, ... }:

{
  home.stateVersion = "23.11"; 

  home.username = "qwest";
  home.homeDirectory = "/home/qwest";
  
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
        neovim          #text editor
		tmux            #terminal multiplexer
		fzf             #general-purpose fuzzy finder
		starship        #terminal Prompt bar
		atuin           #Better Shell History
		yazi            #terminal file manager
		btop            #terminal system monitor



		lazydocker      #docker TUI
		sheldon         #zsh plugin manager

		#GUI apps
		mpv
		obsidian

		#Git
		lazygit         #git TUI 
		gh              #github cli
		delta           #syntax-highlighting pager for GitHub-style terminal diffs

		#Modern CLI tools that replace the old ones
		bat             #better cat
		eza             #better ls
		fd              #better find
		ripgrep         #better grep
		zoxide          #better cd
		tldr            #better man
		duf             #better df
		dust            #better du
		dog             #better dig
		xh              #better curl
        
		#Terminal visualizers
		neo             #matrix rain (use the numbers to change color)
		fastfetch       #display system info 
		pipes

		#JSON
		jless           #view json
		jc              #turn text to json
		gron            #flatten json (mainly for grep/awk)
		jqp             #jq query builder
		jq              #operate on json

		#Utilities
		ouch            #archive & unarchive
		age		#encryption tool
		mpvpaper        #set videos as wallpaper
	];
}


