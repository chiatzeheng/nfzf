# NeoFZF

Built to preview and search for files using Fuzzy Finder.


## Installation

Install Dependecies with Pacman or Yay

```bash
 pacman -S fzf bat feh mpv
```
    
## Run Locally

Clone the project

```bash
  git clone https://github.com/chiatzeheng/nfzf.git
```

Go to the project directory

```bash
  cd nfzf
```

Move script to dotfilesw

```bash
  mv nfzf ~/.dotfiles/scripts/
```

Add alias to nfzf

```bash
  nvim ~/.bashrc
  alias nfzf = "~/.dotfiles/scripts/nfzf.sh"
```


## Flags

Open Nvim after searching for file

```bash
  nfzf --edit
```

CD into directory 

```bash
  nfzf --dir
```
