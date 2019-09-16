#!/bin/bash
set -e

echo "😍 Kickstarting new machine.."
echo
sleep 2

INITDIR=~/workspace/wormangel/init
ZINITDIR=~/workspace/lmedeirosdea/init

# OSX Tweaks
echo "🖱 Setting up OSX tweaks..."
echo
echo "This step will TRY to configure the following OSX settings:"
echo " * Trackpad: Enable clicking by tapping"
echo " * Finder: Show Path bar"
echo " * Finder: Show Hidden files"
echo
defaults write com.apple.AppleMultitouchTrackpad Clicking 1
defaults write com.apple.finder ShowPathbar 1
defaults write com.apple.finder AppleShowAllFiles YES

# Install dev tools
echo "🤓 Installing xcode CLI tools..."
echo
echo "This launches a GUI application and requires user confirmation."
xcode-select --install

read -n 1 -s -r -p "Press any key to continue..."
echo

# Install homebrew
echo "🔨 Installing homebrew..."
echo
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/cask-versions

# Install proper terminal - iterm2 and oh-my-zsh
echo "❤️ Installing iTerm2 and oh-my-zsh..."
echo
brew cask install iterm2
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# TODO This will change the shell to oh-my-zsh and stop executing the rest of the script :( Split the files?

# Generate SSH
echo "🔶 Generating new SSH key..."
echo
ssh-keygen -t rsa -b 4096 -C "lucas.medeiros.de.azevedo@zalando.de"
echo
echo "Adding newly-created key to ssh-agent. You will be prompted for the password."
eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa

# Manual instruction suggested
echo "🛑 Manual step before proceeding!"
echo
echo "To clone the init repositories the newly created SSH key needs to be uploaded to GitHub."
pbcopy < ~/.ssh/id_rsa.pub
echo "The public key (~/.ssh/id_rsa.pub) was copied to your clipboard."
echo
echo "  👾 Upload new SSH key to GH - https://github.com/settings/ssh/new"
echo "  🔶 Upload new SSH key to ZACK - https://access.zalando.net"
echo "  🔶 Approve the key in GHE - https://github.bus.zalan.do/settings/keys"
echo

read -n 1 -s -r -p "Press any key to continue..."
echo

# Clone repos with dotfiles
echo "🐛 Creating workspace and cloning general init project..."
echo
mkdir ~/workspace
git clone git@github.com:wormangel/init.git $INITDIR
cp $INITDIR/.ssh/config ~/.ssh/config

# Install all needed software
echo "⚙️ Installing all needed software..."
echo
echo "WARNING: java8 is not available anymore with Homebrew due tue Oracle licensing bullshit."
echo "Please manually download it and install from https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
echo
echo "🔶 Zalando note: google-chrome comes installed"
brew cask install spectacle atom telegram spotify google-chat intellij-idea postgres pgadmin4 postman docker istat-menus dropbox xquartz wine-devel tunnelblick gimp
brew install python3 go glide node jq z imagemagick hub maven awscli bash icdiff mono
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE # Disable swipe navigation

# Install Atom packages
echo "⚛️ Installing Atom packages..."
echo
apm install duplicate-removal plist-converter pretty-json sort-lines split-diff

# Setup dotfiles
echo "🎫 Copying dotfiles..."
echo
echo "This step will:"
echo " * Copy .vimrc to home"
echo " * Copy .zshrc to home"
echo " * Copy iStats settings to home"
echo " * Copy iTerm2 profiles to the appropriate place"
echo "   * NOTE: iTerm2 preferences need to be loaded manually, check the final instructions."
echo
cp $INITDIR/.zshrc ~/
cp $INITDIR/.vimrc ~/
cp $INITDIR/istats.ismp ~/
mkdir -p ~/Library/Application Support/iTerm2/DynamicProfiles
cp $INITDIR/iTerm2/profiles.json ~/Library/Application Support/iTerm2/DynamicProfiles

# Zalando - Install tooling
echo "🔶 Installing Zalando tooling..."
echo
sudo pip3 install --upgrade stups stups-berry zalando-kubectl zmon-cli scm-source mkdocs mkdocs-material pymdown-extensions

# Zalando - Configure tooling
echo "🔶 Configuring Zalando tooling..."
echo
echo "This step will:"
echo " * Create /meta/credentials and change its ownership to the current user"
echo " * Configure STUPS - should automatically use stups.zalan.do"
echo " * Configure ZMON - manually enter https://zmon.zalando.net when prompted"
echo " * Configure git globals and export GITHUB_TOKEN for hub"
echo
sudo mkdir -p /meta/credentials
sudo chown $(whoami) /meta/credentials
stups configure stups.zalan.do
zmon configure
git config --global user.name "Lucas Medeiros de Azevedo"
git config --global user.email "lucas.medeiros.de.azevedo@zalando.de"
git config --global --add hub.host github.bus.zalan.do
export GITHUB_TOKEN=REPLACE_ME_WITH_A_TOKEN

# Zalando - Setup dotfiles and istats settings
echo "🔶 Setting up Zalando dotfiles..."
echo
echo "This step will:"
echo " * Clone the internal lmedeirosdea/init repo"
echo " * Copy .m2 and .aws directories to home"
echo " * Copy .zalandorc, .zalando-stups and .zalandorc to home"
echo " * Copy the berry.yaml to home"
echo
git clone git@github.bus.zalan.do:lmedeirosdea/init.git $ZINITDIR
cp -a $ZINITDIR/.m2 ~/
cp -a $ZINITDIR/.aws ~/
cp $ZINITDIR/.zalandorc ~/
cp $ZINITDIR/.zalando-stups ~/
cp $ZINITDIR/.zalando-k8s ~/
cp $ZINITDIR/berry.yaml ~/

# Zalando - Copy list of favorite Servers (Zalando SMB drives)
echo "🔶 Setting up Zalando shared drives as Favorite Servers..."
echo
cp $ZINITDIR/com.apple.LSSharedFileList.FavoriteServers.sfl2 ~/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.FavoriteServers.sfl2

# Zalando - Copy pgAdmin4 servers list
echo "🔶 Copying Team CAT DB servers to pgAdmin4..."
echo
cp -a $ZINITDIR/.pgadmin ~/

# Zalando - Clone all the projects (allthethings)
echo "🔶 Cloning Team CAT git repositories..."
echo
mkdir ~/workspace/team-cat
mkdir -p ~/workspace/go/src/github.bus.zalan.do/team-cat

projects=(backstage-media-service-k8s-deploy backstage-ui backstage-ui-k8s-deploy baywatch baywatch-k8s-deploy butterfly can-i-has-sku carticle carticle-k8s-deploy cat-bulk-ops-api cat-bulk-ops-api-k8s-deploy catabase-db-k8s-deploy cateye cateye-k8s-deploy catfix cathttpd catman catmium cattributes clarifications-api clarifications-api-k8s-deploy content-creation-k8s-resources continuous-delivery garfield garfield-k8s-deploy image-auto-upload-ui image-auto-upload-ui-k8s-deploy inbound-api inbound-api-k8s-deploy local-sync-client moma-backend moma-frontend orbit-dashboard-api orbit-ui orbit-ui-k8s-deploy outbound-api outbound-api-k8s-deploy polly polly-k8s-deploy production-comet supercat supplier-data-api tracking-api tracking-api-k8s-deploy)

for p in $projects; do
    git clone git@github.bus.zalan.do:team-cat/$p.git ~/workspace/team-cat/$p;
done

git clone git@github.bus.zalan.do:team-cat/backstage-media-service.git ~/workspace/go/src/github.bus.zalan.do/team-cat/backstage-media-service

echo "🎉 All done!"
echo
echo "OSX tweaks to do manually:"
echo " ⚙️  Displays > Resolution > More Space"
echo " ⚙️  Keyboard > Input Sources > add U.S. International - PC > remove others"
echo " ⚙️  Date & Time > uncheck Show date and time in the menubar"
echo " ⚙️  Energy Save > uncheck Show battery status in menubar"
echo " ⚙️  Accessibility > Zoom > Use scroll gesture with modifier keys to zoom > ^ Control"
echo " ⚙️  Security & Privacy > General > Require password immediately after sleep or screen saver begins"
echo " ⚙️  Keyboard > Text > disable Correct spelling automatically and Capitalize words automatically"
echo " ⚙️  Setup shortcut to lock screen with keyboard"
echo "   · Automator > Create new Quick action (no input, any app, launches Start Screen Saver) > Save as Lock Screen"
echo "   · System Preferences > Keyboard > Shortcuts > Services > Lock Screen > bind to ⌘⌥^L"
echo
echo "Application configuration to do manually:"
echo " 📅 Calendar:"
echo "  ⚙️  Add Google accounts, configure refreshing for every 5min"
echo
echo " 👓 Spectacle:"
echo "  ⚙️  Preferences > Launch Spectacle at Login"
echo
echo " 🌕 Google Chrome:"
echo "  ⚙️  Set as default browser"
echo "  ⚙️  Login to Chrome to synchronize extensions"
echo "    · LastPass > https://chrome.google.com/webstore/detail/lastpass-free-password-ma/hdokiejnpimakedhajhdlcegeplioahd"
echo "    · Cluster > https://chrome.google.com/webstore/detail/cluster-window-tab-manage/aadahadfdmiibmdhfmpbeeebejmjnkef"
echo "    · Session Buddy > https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko"
echo "    · uBlock Origin > https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm"
echo "    · EditThisCookie > https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg"
echo "    · Copy All URLs > https://chrome.google.com/webstore/detail/copy-all-urls/djdmadneanknadilpjiknlnanaolmbfk"
echo "    · React Dev Tools > https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi"
echo "    · Redux Dev Tools > https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd"
echo
echo " 💻 iTerm2:"
echo "  ⚙️  Options > Preferences > General > Load preferences from a custom folder or URL > $INITDIR/iTerm2"
echo
echo " 🌡  iStats Menus 6:"
echo "  ⚙️  iStats Menus - Registration - Key can be found on Gmail under 'istats order'"
echo "  ⚙️  File > Import Settings > ~/istats.ismp"
echo
echo " 📱 IntelliJ IDEA Ultimate:"
echo "  ⚙️  License Key: login with Zalando e-mail address"
echo
echo " 📦 Dropbox:"
echo "  ⚙️  Selective Sync: configure to sync /docs"
echo
echo "Zalando steps to do manually:"
echo " 🔶 Upload new SSH key to ZACK - https://access.zalando.net"
echo " 🔶 Revoke old SSH key from GitHub"
echo " 🔶 Request VPN access again (using ZACK)"
echo " 🔶 Set the Maven (LDAP) password in ~/.m2/settings.xml"
echo

# Source .zshrc
echo "Don't forget to source .zshrc now!"
echo
echo "🌈 HAVE FUN! 🦄"
