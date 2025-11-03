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

# --- Symlinks ---
echo "🔗 Linking dotfiles..."
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/.p10k.zsh" "$HOME/.p10k.zsh"

# --- Powerlevel10k (if not installed via Brew) ---
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# --- Fonts (for Powerlevel10k) ---
echo "🔤 Installing Nerd Fonts..."
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# --- zsh plugins ---
echo "⚙️ Installing Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] &&
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] &&
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# --- NVM ---
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing NVM..."
  mkdir ~/.nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

# --- Finalize ---
echo "✅ Setup complete! Restart your terminal to apply all changes."
