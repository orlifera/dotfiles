# Setup Guide for New Machine

This guide covers all the steps needed to set up your development environment on a new machine using your dotfiles.

## 📁 Understanding Configuration Folder Structure

**Important:** Brew-installed packages (like oh-my-zsh, nvm, etc.) create their own configuration folders automatically:

- `~/.oh-my-zsh/` - Created by Oh My Zsh installation
- `~/.nvm/` - Created by NVM installation
- `~/.ssh/` - Created when first SSH key is generated
- Package-specific configs are created automatically when needed

**Your dotfiles** (user-specific configurations) are in `~/dotfiles/` root:

- `.zshrc` - Your zsh configuration (symlinked to `~/.zshrc`)
- `.p10k.zsh` - Powerlevel10k theme config (symlinked to `~/.p10k.zsh`)
- `.config/` - Application configs (should be symlinked to `~/.config/`)

---

## 🚀 Initial Setup

### 1. Clone Your Dotfiles Repository

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles
```

### 2. Run the Installation Script

The `install.sh` script will:

- Install Xcode Command Line Tools
- Install Homebrew
- Install all packages from `Brewfile` (formulas, casks, VS Code extensions)
- Install Oh My Zsh
- Set up symlinks for `.zshrc` and `.p10k.zsh`
- Install Powerlevel10k theme
- Install fzf-git.sh
- Install NVM

```bash
chmod +x install.sh
./install.sh
```

**Note:** After running `install.sh`, restart your terminal to apply changes.

---

## 🔧 Post-Installation Configuration

### 3. Set Up Symlink for `.config` Directory

The `.config` directory contains configurations for:

- SketchyBar
- btop
- Raycast
- TheFuck
- Bat themes

Symlink it to your home directory:

```bash
ln -sf ~/dotfiles/.config ~/.config
```

### 4. Update Hardcoded Paths in `.zshrc`

The `.zshrc` file has a hardcoded path that needs to be updated to use `$HOME`:

**Current (line 126):**

```bash
export PATH=$PATH:/Users/orli/.spicetify
```

**Update to:**

```bash
export PATH=$PATH:$HOME/.spicetify
```

**If you use Spicetify:**

- Install Spicetify if needed: https://spicetify.app/docs/getting-started/basic-installation
- The path will be automatically set once Spicetify is installed

### 5. Configure Git Global Settings

Set up your Git identity:

```bash
git config --global user.name "orlifera"
git config --global user.email "oferazzani125@gmail.com"
```

Your existing Git config preferences (already in dotfiles via git-delta):

- `core.pager=delta`
- `interactive.difffilter=delta --color-only`
- `delta.navigate=true`
- `delta.side-by-side=true`
- `delta.dark=true`
- `merge.conflictstyle=diff3`
- `diff.colormoved=default`
- `pull.rebase=false`
- `pull.autosetupremote=true`
- `push.autosetupremote=true`

---

## 🔐 GitHub Setup

### 6. Generate SSH Key for GitHub

If you don't already have an SSH key:

```bash
# Generate a new Ed25519 SSH key (recommended)
ssh-keygen -t ed25519 -C "oferazzani125@gmail.com"

# When prompted:
# - Press Enter to accept default file location (~/.ssh/id_ed25519)
# - Enter a passphrase (recommended) or press Enter for no passphrase
```

**If you're copying your existing SSH key from your old machine:**

```bash
# Copy the private key to ~/.ssh/
cp ~/dotfiles/.ssh/id_ed25519 ~/.ssh/id_ed25519
cp ~/dotfiles/.ssh/id_ed25519.pub ~/.ssh/id_ed25519.pub

# Set correct permissions (important!)
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### 7. Add SSH Key to SSH Agent

```bash
# Start the ssh-agent
eval "$(ssh-agent -s)"

# Add your SSH private key to the ssh-agent
ssh-add ~/.ssh/id_ed25519

# If you set a passphrase, enter it when prompted
```

**To make SSH key persistent across reboots**, add this to your `~/.zshrc` (or it may already be there):

```bash
# Add SSH key to agent if not already added
if [ -z "$SSH_AUTH_SOCK" ]; then
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
```

### 8. Add SSH Public Key to GitHub

1. **Copy your public key:**

   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy
   ```

   Or manually copy the output of:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. **Add to GitHub:**

   - Go to GitHub.com → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Title: Give it a name (e.g., "MacBook Pro M1")
   - Key: Paste your public key
   - Click "Add SSH key"

3. **Test SSH connection:**
   ```bash
   ssh -T git@github.com
   ```
   You should see: `Hi orlifera! You've successfully authenticated...`

### 9. Configure SSH Config (Optional)

If you have a custom SSH config, copy it:

```bash
# If you have an SSH config in your dotfiles
cp ~/dotfiles/.ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config
```

Or create a minimal one:

```bash
cat > ~/.ssh/config << 'EOF'
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
EOF
```

### 10. Authenticate GitHub CLI

```bash
# Authenticate with GitHub
gh auth login

# Follow the prompts:
# - Choose "GitHub.com"
# - Choose "HTTPS" or "SSH" (SSH is recommended)
# - Authenticate via web browser or token
```

**Verify authentication:**

```bash
gh auth status
```

---

## 🌍 Environment Variables & Paths

### 11. Java Home Configuration

Your `.zshrc` already includes Java configuration, but verify OpenJDK 17 is installed:

```bash
# Check if Java 17 is installed
/usr/libexec/java_home -V

# The JAVA_HOME should already be set in .zshrc:
# export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### 12. Node Version Manager (NVM)

NVM is installed by `install.sh`. After restarting your terminal:

```bash
# Verify NVM is loaded
nvm --version

# Install Node.js LTS
nvm install --lts
nvm use --default --lts
```

### 13. Python Configuration

Python 3.12 is installed via Homebrew. The PATH should already be configured in `.zshrc`:

- `/opt/homebrew/bin:$PATH` - Homebrew binaries
- `/usr/local/opt/python/libexec/bin:$PATH` - Python executables

**Verify:**

```bash
python3 --version
which python3
```

---

## 📦 Application-Specific Setup

### 14. SketchyBar (Menu Bar Customization)

If you use SketchyBar:

```bash
# The config is in ~/.config/sketchybar/ (symlinked from dotfiles)
# Start SketchyBar
brew services start sketchybar

# Or run manually
sketchybar
```

### 15. Powerlevel10k Theme

After installing, configure the theme:

```bash
p10k configure
```

Or if the prompt looks good, it should already work from your existing `.p10k.zsh` config.

### 16. Configure Additional Tools

**TheFuck** - Command correction tool (already installed):

```bash
# Already aliased in .zshrc as 'fuck' and 'fk'
# First run will prompt for configuration location
fuck
```

**FZF** - Fuzzy finder (already configured in `.zshrc`):

- Should work automatically after terminal restart
- Uses `fd` for searching (already installed)

**Zoxide** - Better `cd` (already configured):

- Use `z` instead of `cd` (aliased in `.zshrc`)
- Or just use `cd` normally - zoxide learns automatically

---

## ✅ Verification Checklist

After completing all steps, verify everything works:

- [ ] Terminal opens with Powerlevel10k theme
- [ ] `git --version` works
- [ ] `gh auth status` shows authenticated
- [ ] `ssh -T git@github.com` authenticates successfully
- [ ] `nvm --version` works
- [ ] `node --version` shows installed version
- [ ] `java -version` shows Java 17
- [ ] `python3 --version` works
- [ ] FZF works (`Ctrl+T` in terminal)
- [ ] Zoxide works (`z <directory>`)
- [ ] Git operations work (push/pull from GitHub)

---

## 🔄 Updates & Maintenance

### Update Homebrew Packages

```bash
brew update
brew upgrade
```

### Update Oh My Zsh

```bash
omz update
```

### Update NVM

```bash
# Update NVM itself
cd ~/.nvm && git pull
```

### Export Current Brewfile (if you install new packages)

```bash
brew bundle dump --force --file=~/dotfiles/Brewfile
```

---

## 📝 Notes

- **Home directory path:** If your username differs from `orli`, update hardcoded paths in `.zshrc`:

  - Line 126: `export PATH=$PATH:$HOME/.spicetify` (already uses `$HOME`)
  - Check for any other hardcoded `/Users/orli/` paths

- **VS Code Extensions:** Installed automatically via `brew bundle` from the `Brewfile`

- **Cursor Extensions:** The VS Code extensions in Brewfile will also work with Cursor (which you have installed via cask)

- **Shell history:** History is configured to be shared and stored in `~/.zhistory` (configured in `.zshrc`)

---

## 🆘 Troubleshooting

**Issue: Powerlevel10k not showing**

- Check that `.p10k.zsh` symlink exists: `ls -la ~/.p10k.zsh`
- Restart terminal
- Run `p10k configure` if needed

**Issue: NVM not found**

- Restart terminal after running `install.sh`
- Check that NVM_DIR is set: `echo $NVM_DIR`
- Source NVM manually: `source ~/.nvm/nvm.sh`

**Issue: SSH key not working**

- Verify permissions: `ls -la ~/.ssh/`
- Private key should be `600`: `chmod 600 ~/.ssh/id_ed25519`
- Check SSH agent: `ssh-add -l`
- Add key to agent: `ssh-add ~/.ssh/id_ed25519`

**Issue: Git operations ask for password**

- Make sure SSH key is added to GitHub
- Test SSH: `ssh -T git@github.com`
- Use SSH URLs for repos: `git remote set-url origin git@github.com:user/repo.git`

---

## 📚 Additional Resources

- [GitHub SSH Setup Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Homebrew Documentation](https://docs.brew.sh/)
- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Powerlevel10k Documentation](https://github.com/romkatv/powerlevel10k)
