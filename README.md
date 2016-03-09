Config files/scripts kludged together from Richard Slindee

Currently, this contains the following:

- .vimrc with appropriate plugins for C development
- .mintty configuration with solarized theme
- .tmux configuration

INSTALLATION:

-Install Babun
-Install Menlo for Powerline font (https://github.com/abertsch/Menlo-for-Powerline)
-Install Vundle for Vim ("git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim")
-Install the_silver_searcher inside Babun:
    -Install libpcre-devel ("pact install libpcre-devel")
    -Install liblzma-devel ("pact install liblzma-devel")
    -Clone the_silver_searcher to your ~/ ("git clone https://github.com/ggreer/the_silver_searcher.git")
    -Install ("cd the_silver_searcher && ./build.sh && make install")
    -Test by running "ag" in command prompt, if it works, you can delete the_silver_searcher directory
-Clone my "configs" repo to your home directory and move all the files to your home
-Restart Babun if it is already running
-Run ":PluginInstall" inside Vim
-Restart Vim

TODO:

- Automatic install scripts
- .gitconfig
- ag installer
