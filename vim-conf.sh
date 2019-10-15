#!/bin/bash
#
# Vim configuration and plugins installation, specially vim-orgmode and suggested plugins.
# For user only. Need curl and 7z, no git dependence.

# No git, download repo in zip, 7z -o doesn't work with ~
user_name=$(whoami)
user_path=$(awk -F: '$1 == "'"$user_name"'" {print $6}' /etc/passwd)
pathogen_autoload_path="${user_path}/.vim/autoload"
pathogen_bundle_path="${user_path}/.vim/bundle"
my_colors="${user_path}/.vim/colors"
my_plugins_path="${user_path}/.vim/my-plugins-vim-git"


rm -r "${my_plugins_path}"
mkdir -p "${pathogen_autoload_path}" "${pathogen_bundle_path}" "${my_colors}" "${my_plugins_path}" &&


# install/update pathogen
curl -LSo "${pathogen_autoload_path}/pathogen.vim" 'https://tpo.pe/pathogen.vim'

# install/update vim-sensible
curl -LSo "${pathogen_bundle_path}/sensible.vim" 'https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim'

# my colortheme
curl -LSo "${my_colors}/herald_mod.vim" 'https://raw.githubusercontent.com/michten/buster-inst/master/07_herald_mod.vim'


# My ~/.vimrc config file
echo \
"syntax on
filetype plugin indent on

set number
set relativenumber

inoremap kk <ESC>

colorscheme herald_mod

execute pathogen#infect('bundle/{}', 'my-plugins-vim-git/{}')" > "${user_path}/.vimrc"


# linki for github repos of vim plugins
# add another repository here
vim_git_repos=(
'https://github.com/jceb/vim-orgmode/archive/master.zip'
'https://github.com/tpope/vim-speeddating/archive/master.zip'
'https://github.com/dense-analysis/ale/archive/master.zip'
)


install_repo() {
	link=$1
	curl -LSo "${my_plugins_path}/master.zip" "$link" &&
	7z x "${my_plugins_path}/master.zip" -o"${my_plugins_path}" &&
	rm -- "${my_plugins_path}/master.zip" && true
}


for repo in ${vim_git_repos[@]}; do
	install_repo "$repo" && true
done
