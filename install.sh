#!/usr/bin/env bash
set -e

echo "🔧 Starting environment setup..."

# --- Xcode ---
if ! xcode-select -p &>/dev/null; then
  echo "📦 Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🔁 Updating Homebrew..."
brew update

echo "📦 Installing all formulas and casks from Brewfile..."
brew bundle --file="$HOME/dotfiles/Brewfile" || true

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Powerlevel10k (if not installed via Brew) ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# --- fzf-git.sh ---
if [ ! -d "$HOME/fzf-git.sh" ]; then
  echo "🔍 Installing fzf-git.sh..."
  git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/fzf-git.sh"
fi

# --- NVM ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing NVM..."
  mkdir ~/.nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

# --- Finalize ---
echo "✅ Setup complete! Restart your terminal to apply all changes."
