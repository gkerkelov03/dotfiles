{ config, pkgs, ... }:

{
  home.stateVersion = "23.11"; 

  home.username = "qwest";
  home.homeDirectory = "/home/qwest";
  
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
		starship        #1.  terminal Prompt bar 
        neovim          #2.  text editor
		tmux            #3.  terminal multiplexer
		rofi            #4.  application launcher on steroids
		yazi            #5.  terminal file manager
		bat             #6.  better cat
		eza             #7.  better ls
		fd              #8.  better find
		ripgrep         #9.  better grep
		btop            #10. terminal system monitor
		zoxide          #11. better cd
		tldr            #12. better man
		fzf             #13. general-purpose fuzzy finder
		neo             #14. matrix rain (use the numbers to change color)
		google-chrome   #15. browser 
		atuin           #16. Better Shell History
		curl            #17. Send network requests
        gh              #18. github cli
		delta           #19. better git diff
		jq              #20. operate on json
		fx              #21. view json
		lazydocker      #22. docker helpers
		duf             #23. modern df
		dust            #24. modern du
		fastfetch       #27. display info in a cool way in the terminal 
		lazygit         #28. git TUI 
		gcc             #29. the c and c++ compiler
		xclip           #30. clipboard utilities used by nvim for example
	]; 
}

