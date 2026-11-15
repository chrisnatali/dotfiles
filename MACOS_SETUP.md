# MacBook Air Setup (minimal, "get productive today")

Goal: GitHub, `pass` + password repo, Neovim (LazyVim), VS Code, and SSH to DigitalOcean,
with zsh in emacs mode. **No AeroSpace, no tiling WM, no bash switch.**

Linked from the `MacOS` section of `README.md`. The older AeroSpace, bash,
9-desktop, and `brew bundle` steps are intentionally skipped.

Assumes: `brew`, `git`, and Chrome are already installed on the Mac.

Keys on the Linux laptop:
- SSH: `~/.ssh/id_rsa` (used for GitHub and DigitalOcean)
- GPG: `C541F963D4C90C30` (the "Chris Password Key", used by `pass`)
- Password repo: `git@github.com:chrisnatali/e_w.git`

---

## 1. Install the packages (Mac)

```sh
brew install neovim pass gnupg pinentry-mac ripgrep fd lazygit gh stow tmux
brew install --cask visual-studio-code font-jetbrains-mono-nerd-font
# optional, only if you want to manage droplets from the CLI:
# brew install doctl
```

`ripgrep`, `fd`, `lazygit`, and a Nerd Font are what LazyVim expects. The `code` CLI is
installed along with the VS Code cask.

Pandoc (personal site + resume):

```sh
brew install pandoc librsvg      # librsvg lets pandoc embed SVGs when making PDFs
brew install --cask basictex     # LaTeX engine for pandoc -> PDF; asks for your password
```

BasicTeX puts its binaries in `/Library/TeX/texbin`. Open a new terminal (or
`eval "$(/usr/libexec/path_helper)"`) so `pdflatex` is on your PATH. BasicTeX is minimal, so if
a PDF build complains about a missing `.sty` file, install that package:

```sh
sudo tlmgr update --self
sudo tlmgr install <package>     # e.g. collection-fontsrecommended
```

Skip `basictex` if you only generate HTML.

AI coding CLIs:

```sh
brew install --cask claude-code   # Claude Code: run `claude`, log in on first launch
brew install --cask codex         # OpenAI Codex CLI: run `codex`, sign in with ChatGPT or an API key
# optional desktop app: brew install --cask claude
```

Both are updated with `brew upgrade` along with everything else.

## 2. Copy the keys from the Linux laptop to the Mac

**On the Mac:** temporarily turn on SSH so the laptop can `scp` to it:
- System Settings → General → Sharing → **Remote Login: On**
- Get the Mac's IP: `ipconfig getifaddr en0`
- `mkdir ~/transfer`

**On the Linux laptop:** export the GPG key and copy everything over:

```sh
mkdir -p /tmp/mac-transfer && cd /tmp/mac-transfer
gpg --export --armor C541F963D4C90C30 > gpg-public.asc
gpg --export-secret-keys --armor C541F963D4C90C30 > gpg-secret.asc   # still passphrase-protected
gpg --export-ownertrust > gpg-ownertrust.txt
cp ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ~/.ssh/config .

scp ./* <mac-user>@<mac-ip>:~/transfer/

cd ~ && rm -rf /tmp/mac-transfer
```

(A USB stick works too if you'd rather not turn on Remote Login.)

**On the Mac:** turn **Remote Login back Off** once the copy finishes.

## 3. SSH (Mac)

```sh
mkdir -p ~/.ssh && chmod 700 ~/.ssh
mv ~/transfer/id_rsa ~/transfer/id_rsa.pub ~/.ssh/
chmod 600 ~/.ssh/id_rsa && chmod 644 ~/.ssh/id_rsa.pub
```

Create `~/.ssh/config`. Use this instead of the Linux one, adding the macOS Keychain lines:

```
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

# change User if you log in to the droplet as someone other than root
Host dig_oc_personal_site
  HostName 137.184.151.193
  User root
  ForwardAgent yes
```

```sh
chmod 600 ~/.ssh/config
ssh-add --apple-use-keychain ~/.ssh/id_rsa   # enter passphrase once; macOS remembers it
ssh -T git@github.com                         # should greet you as chrisnatali
ssh dig_oc_personal_site                         # DigitalOcean droplet
```

macOS's built-in ssh-agent and Keychain take the place of `keychain` from `.profile`.
Add a `Host` block for each additional droplet.

## 4. GPG + pass (Mac)

```sh
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent

gpg --import ~/transfer/gpg-public.asc
gpg --import ~/transfer/gpg-secret.asc          # prompts for the key passphrase
gpg --import-ownertrust ~/transfer/gpg-ownertrust.txt
gpg -K                                           # should show C541F963D4C90C30 as [ultimate]

git clone git@github.com:chrisnatali/e_w.git ~/.password-store
pass                                             # list entries
pass -c amazon.com                               # copies to the clipboard (pbcopy) for 45s
```

The pinentry-mac dialog has a "Save in Keychain" checkbox. Tick it if you don't want to
retype the GPG passphrase.

Then remove the transfer dir:

```sh
rm -rf ~/transfer
```

## 5. Dotfiles: git config + Neovim (Mac)

```sh
mkdir -p ~/src && cd ~/src
git clone git@github.com:chrisnatali/dotfiles.git
cd dotfiles

ln -s ~/src/dotfiles/.gitconfig ~/.gitconfig     # name/email, editor=nvim, defaultBranch=main
stow --target=$HOME nvim                          # links ~/.config/nvim -> dotfiles/nvim/.config/nvim
ln -s ~/src/dotfiles/.tmux.conf ~/.tmux.conf      # sources ~/.tmux-osx.conf on macOS
ln -s ~/src/dotfiles/.tmux-osx.conf ~/.tmux-osx.conf

nvim    # LazyVim bootstraps and installs plugins on first launch; :Lazy to check
```

Don't link the bash dotfiles (`.bashrc`, `.profile`, `.bash_aliases`), and don't stow `bin`.
They are Linux/X-specific (keychain, xclip, xrandr, wacom).

Optional: `gh auth login` (choose SSH) if you want the `gh` CLI for PRs and issues.

## 6. zsh in emacs mode (Mac)

Create `~/.zshrc`:

```zsh
export EDITOR=nvim
export VISUAL=nvim

# Emacs keybindings (Ctrl-a/e/k/r, Alt-b/f/d...).
# Must be explicit: zsh auto-picks vi mode when EDITOR/VISUAL contains "vi".
bindkey -e

# History
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS

# Completion
autoload -Uz compinit && compinit

alias vi=nvim
```

Open a new terminal tab and check that `bindkey | head -3` mentions `beginning-of-line` for `^A`.

## 7. Make Alt/Option work as Meta in the terminal

`Alt-b`, `Alt-f`, and `Alt-d` need this setting.

- **Terminal.app** (built in, fine for today): Settings → Profiles → Keyboard →
  check **"Use Option as Meta key"**. While you're there, set the font to
  *JetBrainsMono Nerd Font* (Profiles → Text) so the LazyVim icons render.
- **iTerm2** (if you install it later): Settings → Profiles → Keys →
  Left Option key: **Esc+**.

## 8. VS Code

Launch it from Applications or run `code .` from a repo. Sign in with GitHub for Settings Sync
if you used it before. Otherwise install extensions as you need them.

## 9. Mainstream apps

Install as needed. These all just work on macOS:

```sh
brew install --cask zoom
# Google Meet runs in Chrome
```

---

## Done-today checklist

- [ ] `ssh -T git@github.com` works
- [ ] `ssh dig_oc_personal_site` reaches the DigitalOcean droplet
- [ ] `pass -c <entry>` decrypts and copies
- [ ] `nvim` opens with LazyVim, plugins installed
- [ ] `code .` opens VS Code
- [ ] `Ctrl-a`, `Ctrl-r`, `Alt-b`, `Alt-f` work in the terminal
- [ ] Remote Login is turned **off** again; `~/transfer` deleted on the Mac; `/tmp/mac-transfer` deleted on Linux

## Later (not today)

- Rewrite the `MacOS` section of `README.md` to match this.
- Trim `Brewfile` to what you actually use and run `brew bundle` with it.
- Keep things current with `brew update && brew upgrade` (and `:Lazy update` in nvim).
