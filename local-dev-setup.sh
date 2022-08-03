brew_install() {
    if brew list $1 &>/dev/null; then
        echo "${1} is already installed"
    else
        echo "Installing $1..."
        brew install $1
    fi
}

# Install Homebrew
NONINTERACTIVE=1

which -s brew

if [[ $? != 0 ]] ; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homewbrew..."
    brew update
fi

# Download the GitHub repo
brew_install gh

GITHUB_STATUS=$(gh auth status)
UNAUTHENTICATED_MESSAGE="You are not logged into any GitHub hosts."

if [[ $GITHUB_STATUS == *$UNAUTHENTICATED_MESSAGE* ]]; then
    echo "Logging in to GitHub..."
    gh auth login
else
    echo "Already logged in to GitHub."
fi

# Install or update the repo

BASE_DIRECTORY=~/Code/teleatherapy
REPO_DIRECTORY=$BASE_DIRECTORY/teleatherapy
SETUP_DIRECTORY=$REPO_DIRECTORY/packages/setup

echo $REPO_DIRECTORY

mkdir -p $BASE_DIRECTORY
cd $BASE_DIRECTORY

if [ ! -d $REPO_DIRECTORY ]; then
    echo "Downloading teleatherapy/teleatherapy repo..."
    gh repo clone teleatherapy/teleatherapy
else
    echo "Syncing teleatherapy/teleatherapy repo..."
    cd $REPO_DIRECTORY
    gh repo sync
fi

echo "Done. Now run these commands:"
echo ""
echo "    cd $SETUP_DIRECTORY"
echo "    ./01-command.sh"
echo ""