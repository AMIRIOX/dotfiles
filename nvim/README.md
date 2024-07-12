
## Install Packer.nvim

```
$ git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

## Test PackerSync

```
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
end)
```

## Configure your custom

In `init.lua`:   
`/home/amiriox/` -> `/home/${username}` (2 fix)

## Packer Sync

```
$ nvim
```
Then, run `:PackerSync` (vim).

It is recommended to use a proxy if necessary.
