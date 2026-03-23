let pkgs = import <nixpkgs> {config.allowUnfree = true;}; in pkgs.buildEnv {
	name = "qwest-env";
	paths = with pkgs; [
		starship        #1. terminal Prompt bar 
		neovim     	#2. text editor
		tmux       	#3. terminal multiplexer
		rofi       	#4. application launcher on steroids
		yazi       	#5. terminal file manager
		bat        	#6. better cat
		eza        	#7. better ls
		fd         	#8. better find
		ripgrep    	#9. better grep
		btop       	#10. terminal system monitor
		zoxide    	#11. better cd
		tldr       	#12. better man
		fzf        	#13. general-purpose fuzzy finder
		neo        	#14. matrix rain (use the numbers to change color)
		brave		#15. browser
		atuin           #16. Better Shell History
	]; 
}

