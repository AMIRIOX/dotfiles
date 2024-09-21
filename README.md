# Amiriox's dotfiles

## Included
Items with strikethrough lines indicate that these configurations are no longer in use,      
but are still configurable

- [x] Zsh Theme `amx`: `amx.zsh-theme`
- [x] Hyprland: `hypr/hyprland.conf`
- [ ] ~~Hyprpaper~~: Swaybg instead
- [x] Neovim: `nvim/*`
- [x] Waybar: `waybar/config`, `waybar/style.css`
- [x] Rofi: `rofi/config.rasi`, `rofi/themes/*`
- [x] Kitty: `kitty/kitty.conf`
- [x] Mako: `mako/config`
- [ ] ~~i3wm~~: `i3/config`
- [ ] ~~Picom~~: `picom/picom.conf`
- [ ] ~~Polybar~~: `polybar/*`
- [x] Tofi: `tofi/config`
- [ ] ~~Neofetch~~: `neofetch/*`
- [x] Brightness: `br.c`
- [x] Keyboard Backlight: `led.py`
- [ ] Other Tools: `yazi`, `fzf`...

## Usage

- Zsh Theme:
```zsh
$ cp amx.zsh-theme ~/.oh-my-zsh/themes
$ vim ~/.zshrc # ZSH_THEME="amx"
```

- Hyprland, Kitty, Waybar
```bash
$ cp -r hypr ~/.config/ # The directory is like "~/.config/hypr/hyprland.conf"
$ cp -r kitty ~/.config/ # ~/.config/kitty/kitty.conf
$ cp -r waybar ~/.config/ # ~/.config/waybar/config ~/.config/waybar/style.css
```

- Neovim
```bash
$ # Also see in nvim/README.md
$ $ git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
$ nvim  # :PackerSync 
```

- rofi
```bash
$ # Also see in rofi/README.md
$ mkdir -p ~/.local/share/rofi/themes
$ cp themes/rounded-common.rasi themes/rounded-nord-dark.rasi ~/.local/share/rofi/themes/
```

- mako
```bash
$ cp -r mako ~/.config/ # ~/.config/mako/config
$ makoctl reload
$ notify-send 'Title' 'Text' -u normal
```

- Brightness
```
$ # Also see in br.c
$ su
# gcc br.c -o br
# chown root br
# chmod u+s  br
# mv br /usr/local/bin/
# setcap cap_dac_override+ep /usr/local/bin/br
```

- Backlight
```
$ mkdir Scripts # or anywhere
$ cp led.py ~/Scripts/led.py
$ # Modify led.py and hypr/hyprland.conf
```

- i3wm, picom, tofi
```
$ cp -r i3 ~/.config/       # ~/.config/i3/config
$ cp -r picom ~/.config/    # ~/.config/picom/picom.conf
$ cp -r tofi ~/.config/     # ~/.config/tofi/config
```

- polybar
```
$ # Also see in polybar/README.md
$ cp -r polybar ~/.config/
$ # Complicated to customize, honestly
```

- neofetch
```
$ cp -r neofetch ~/.config/
```

## Customize

Volume/Brightness/Backlight Settings in `hypr/hyprland.conf`. (search `'bind'`)

## Necessary Note

1. Package `AUR/hyprland.git` may cause the transparency effect 
of the terminal to fail in tile mode (Good in floating window mode).       
Solution: use `extra/hyprland` instead of `AUR/hyprland.git`    
Remember to replace `AUR/hyprutils-git` with `extra/hyprutils` as well! 

2. Package `extra/rofi` may experience a problem 
of retaining borders then the height of the candidate area is shortened in Wayland,
and the animation effect is abnormal.    
Solution: use `extra/rofi-wayland` instead.
