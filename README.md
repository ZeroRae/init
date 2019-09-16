# init
This kickstart script automates all the boring work of setting up a new Zalando machine by installing all software I use and pre-configuring (with the help of dotfiles and OSX hacks) otherwise tedious manual settings. Initial script comes from [lmedeirosdea/init](https://github.bus.zalan.do/lmedeirosdea/init), so Kudos to him!

The script is supposed to run standalone and it's gonna take care of cloning this repo and [my general init repo](https://github.com/wormangel/init).

## Known Issues
The script has a shebang to run with bash, but part of it is written for bash and part for zsh:
* The read commands to wait for input doesn't work in zsh
* The for loop for cloning the repos doesn't work on bash
* oh-my-zsh runs `env zsh` to immediatelly switch to zsh, aborting the rest of the commands

Solution to come:
* Check the shell running. The first half of the script only executes if it's bash, the rest if it's zsh. So essentially the user will run `./kickstart.sh` twice, once in bash, and after it switches to zsh, again to proceed :D

**or...**
* Make it completely bash-able
* Cancel the `eval zsh` step from the oh-my-zsh setup so it doesnt switch into zsh
* Final step would launch iTerm, which will open already with zsh and auto-source zshrc! Way better

## Pre-requisites
You need admin rights on the machine.

## Instructions
* Download the `kickstart.sh` and make it executable with `chmod +x kickstart.sh`
* Replace the `REPLACE_ME_WITH_A_TOKEN` placeholder with a [GHE personal access token](https://github.bus.zalan.do/settings/tokens)
* Run `./kickstart.sh`

## Features
The script kickstarts the machine by installing/configuring:

* Shell (iTerm2 + zsh + oh-my-zsh)
* XCode command-line tools (mostly because of git)
* Generation of new SSH key (using Zalando e-mail)
* Homebrew (and all software from them on using formulas and casks for a tidy managed system 😍)
* Essential desktop apps: `google-chrome java8 spectacle atom telegram spotify google-chat intellij-idea postgres pgadmin4 postman docker istat-menus dropbox wine-devel`
* Essential shell apps: `python3 go glide node jq z imagemagick hub maven awscli bash icdiff mono`
* Essential Zalando tooling (with automatic configuration): `zalando-kubectl stups stups-berry zmon-cli`
* Atom packages
* Automatic copying of `berry.yaml` to the home folder
* Automatic copying of software dotfiles `.vimrc .m2 .aws`
* Automatic copying and sourcing of my custom dotfiles `.zalandorc .zalando-k8s .zalando-stups .zshrc`
* Automatic setup of iStats Menus 6
* Setup of `CREDENTIALS_DIR`
* Setup of 'Favorite servers' in Finder with all Zalando SMB servers (e.g. `N:`, `transfer`, etc)
* Setup of git globals
* Setup of workspace folder **with cloning of every project from [Team CAT](https://github.bus.zalan.do/team-cat)** 😻
* Setup of CAT databases in pgAdmin4

Check the script to know exactly what it does.

## What's missing
There are a bunch of steps which were not automatized yet. They are mostly related to OSX settings I'm still figuring out how to change using the CLI (in general it's about changing 'defaults').

**CHECK THE TERMINAL OUTPUT FOR FINAL STEPS!!**
