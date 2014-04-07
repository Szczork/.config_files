#!/bin/zsh

#//// Bindkeys & setopt (completion, Globbing options etc ..)
export GREP_OPTIONS='--binary-files=without-match --ignore-case'

#//// keybindings Strg+v is your friend :-)
bindkey "^[[1;5D" .backward-word
bindkey "^[[1;5C" .forward-word
bindkey "^[[1;6D" backward-delete-word
bindkey "^[[1;6C" delete-word

#//// alt+left (on mac) deletes word
bindkey "^[" backward-kill-word
#//// fn-left
bindkey "^[[H" .backward-word
#//// fn-right
bindkey "^[[F" .forward-word

#//// arrow up/down searches in history if line is already started
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

#//// History Settings (big history for use with many open shells and no dups)
#//// Different History files for root and standard user
if (( ! EUID )); then
    HISTFILE=$ZSH_CACHE/history_root
else
    HISTFILE=$ZSH_CACHE/history
fi
SAVEHIST=10000
HISTSIZE=12000
setopt share_history append_history extended_history hist_no_store hist_ignore_all_dups hist_ignore_space

#///// 2x control is completion from history!!!
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history
bindkey '^X^X' hist-complete

#//// man setopt
setopt AUTO_CD                  # change directory without cd
setopt EXTENDED_GLOB            # '#', '~' and '^' as part of patterns for filename generation
setopt NOMATCH                  # if path not match / print an error
setopt NO_BEEP                  # we don't wan't beep
setopt TRANSIENT_RPROMPT        # remove any right prompt
setopt COMPLETE_IN_WORD         # make autocompletion better, ls comd -> complete_in_word
setopt AUTO_PUSHD               # cd easy, ex: mkdir ~/1/2/3/4    ->   cd 3
setopt PUSHD_IGNORE_DUPS        # avoid directory duplication
setopt no_clobber
