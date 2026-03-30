{ config, pkgs, ... }:

{
  home.stateVersion = "23.11"; 

  home.username = "qwest";
  home.homeDirectory = "/home/qwest";
  
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
		starship        #terminal Prompt bar
		tmux            #terminal multiplexer
		yazi            #terminal file manager
		btop            #terminal system monitor
		fzf             #general-purpose fuzzy finder
		neo             #matrix rain (use the numbers to change color)
		atuin           #Better Shell History
        gh              #github cli
		delta           #better git diff
		lazydocker      #docker helpers
		fastfetch       #display info in a cool way in the terminal 
		lazygit         #git TUI 

        #JSON
		jless           #view json
		jc              #turn text to json
		gron            #flatten json (mainly for grep/awk)
		jqp             #jq query builder
		jq              #operate on json

        #GUI apps
        neovim          #text editor
		google-chrome   #browser
		rofi            #application launcher 

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

        #Utilities
		gcc             #the c & c++ compiler
        xclip           #clipboard utilities

        #Fonts
        nerd-fonts.jetbrains-mono 
	];
}


