# Configure

```bash
$ mkdir -p ~/.local/share/rofi/themes
$ cp themes/rounded-common.rasi themes/rounded-nord-dark.rasi ~/.local/share/rofi/themes/
```

# Customize

Theme `rounded-nord-dark` is modified from [newmanls/rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection/tree/master/themes)

Make fonts and window widths larger to perform better on high-resolution displays

```
~/.local/share/rofi/themes/rounded-common.rasi 
...
 font:   "RobotoMono Nerd Font 20";  // used to be "Roboto 12"
...
window {
    location:       center;
    width:          650;             // used to be "480"
    border-radius:  24px;
    
    background-color:   @bg0;
}
```

