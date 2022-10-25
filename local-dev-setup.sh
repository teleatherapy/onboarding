brew_install() {
    if brew list $1 &>/dev/null; then
        echo "$1 is already installed"
    else
        echo "Installing $1..."
        brew install $1
    fi
}

# Install or update Homebrew
NONINTERACTIVE=1

which -s brew

if [[ $? != 0 ]] ; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating Homebrew..."
    brew update
fi

# Add Homebrew binaries to the PATH
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/davecalnan/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/davecalnan/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Download the GitHub repo
brew_install gh

echo "Logging in to GitHub..."
gh auth login

# Install or update the repo

BASE_DIRECTORY=~/Code/teleatherapy
REPO_DIRECTORY=$BASE_DIRECTORY/teleatherapy
SETUP_DIRECTORY=$REPO_DIRECTORY/packages/setup

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
echo "    ./01-prerequisites.sh"
echo ""
