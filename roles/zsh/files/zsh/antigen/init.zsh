#-- START ZCACHE GENERATED FILE
#-- GENERATED: E mai   29 09:32:52 EEST 2017
#-- ANTIGEN develop
_antigen () {
	local -a _1st_arguments
	_1st_arguments=('apply:Load all bundle completions' 'bundle:Install and load the given plugin' 'bundles:Bulk define bundles' 'cleanup:Clean up the clones of repos which are not used by any bundles currently loaded' 'cache-gen:Generate cache' 'init:Load Antigen configuration from file' 'list:List out the currently loaded bundles' 'purge:Remove a cloned bundle from filesystem' 'reset:Clears cache' 'restore:Restore the bundles state as specified in the snapshot' 'revert:Revert the state of all bundles to how they were before the last antigen update' 'selfupdate:Update antigen itself' 'snapshot:Create a snapshot of all the active clones' 'theme:Switch the prompt theme' 'update:Update all bundles' 'use:Load any (supported) zsh pre-packaged framework') 
	_1st_arguments+=('help:Show this message' 'version:Display Antigen version') 
	__bundle () {
		_arguments '--loc[Path to the location <path-to/location>]' '--url[Path to the repository <github-account/repository>]' '--branch[Git branch name]' '--no-local-clone[Do not create a clone]'
	}
	__list () {
		_arguments '--simple[Show only bundle name]' '--short[Show only bundle name and branch]' '--long[Show bundle records]'
	}
	__cleanup () {
		_arguments '--force[Do not ask for confirmation]'
	}
	_arguments '*:: :->command'
	if (( CURRENT == 1 ))
	then
		_describe -t commands "antigen command" _1st_arguments
		return
	fi
	local -a _command_args
	case "$words[1]" in
		(bundle) __bundle ;;
		(use) compadd "$@" "oh-my-zsh" "prezto" ;;
		(cleanup) __cleanup ;;
		(update|purge) compadd $(type -f \-antigen-get-bundles &> /dev/null || antigen &> /dev/null; -antigen-get-bundles --simple 2> /dev/null) ;;
		(theme) compadd $(type -f \-antigen-get-themes &> /dev/null || antigen &> /dev/null; -antigen-get-themes 2> /dev/null) ;;
		(list) __list ;;
	esac
}
antigen () {
  local MATCH MBEGIN MEND
  [[ "$ZSH_EVAL_CONTEXT" =~ "toplevel:*" || "$ZSH_EVAL_CONTEXT" =~ "cmdarg:*" ]] && source "/usr/share/zsh/share/antigen.zsh" && eval antigen $@;
  return 0;
}
typeset -gaU fpath path
fpath+=(/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/systemd /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/git /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/history /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/per-directory-history /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/rsync /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/autojump /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/web-search /etc/zsh/antigen/bundles/psprint/history-search-multi-word /etc/zsh/antigen/bundles/horosgrisa/mysql-colorize /etc/zsh/antigen/bundles/skx/sysadmin-util /etc/zsh/antigen/bundles/peterhurford/up.zsh /etc/zsh/antigen/bundles/zsh-users/zsh-autosuggestions /etc/zsh/antigen/bundles/djui/alias-tips /etc/zsh/antigen/bundles/bric3/nice-exit-code /etc/zsh/antigen/custom/plugins/auto-ls /etc/zsh/antigen/bundles/zsh-users/zsh-syntax-highlighting /etc/zsh/antigen/custom/themes/juanghurtado) path+=(/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/systemd /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/git /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/history /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/per-directory-history /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/rsync /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/autojump /etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/web-search /etc/zsh/antigen/bundles/psprint/history-search-multi-word /etc/zsh/antigen/bundles/horosgrisa/mysql-colorize /etc/zsh/antigen/bundles/skx/sysadmin-util /etc/zsh/antigen/bundles/peterhurford/up.zsh /etc/zsh/antigen/bundles/zsh-users/zsh-autosuggestions /etc/zsh/antigen/bundles/djui/alias-tips /etc/zsh/antigen/bundles/bric3/nice-exit-code /etc/zsh/antigen/custom/plugins/auto-ls /etc/zsh/antigen/bundles/zsh-users/zsh-syntax-highlighting /etc/zsh/antigen/custom/themes/juanghurtado)
_antigen_compinit () {
  autoload -Uz compinit; compinit -C -d "/etc/zsh/antigen/.zcompdump"; compdef _antigen antigen
  add-zsh-hook -D precmd _antigen_compinit
}
autoload -Uz add-zsh-hook; add-zsh-hook precmd _antigen_compinit
compdef () {}

if [[ -n "/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh" ]]; then
  ZSH="/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh"; ZSH_CACHE_DIR="/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/cache/"
fi
#--- BUNDLES BEGIN
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/bzr.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/clipboard.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/compfix.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/completion.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/correction.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/diagnostics.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/directories.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/functions.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/git.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/grep.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/history.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/key-bindings.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/misc.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/nvm.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/prompt_info_functions.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/spectrum.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/termsupport.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/lib/theme-and-appearance.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/colored-man-pages/colored-man-pages.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/systemd/systemd.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/history/history.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/per-directory-history/per-directory-history.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/rsync/rsync.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/autojump/autojump.plugin.zsh';
source '/etc/zsh/antigen/bundles/robbyrussell/oh-my-zsh/plugins/web-search/web-search.plugin.zsh';
source '/etc/zsh/antigen/bundles/psprint/history-search-multi-word/history-search-multi-word.plugin.zsh';
source '/etc/zsh/antigen/bundles/horosgrisa/mysql-colorize/mysql-colorize.plugin.zsh';
source '/etc/zsh/antigen/bundles/skx/sysadmin-util/sysadmin-util.plugin.zsh';
source '/etc/zsh/antigen/bundles/peterhurford/up.zsh/up.plugin.zsh';
source '/etc/zsh/antigen/bundles/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh';
source '/etc/zsh/antigen/bundles/djui/alias-tips/alias-tips.plugin.zsh';
source '/etc/zsh/antigen/bundles/bric3/nice-exit-code/nice-exit-code.plugin.zsh';
source '/etc/zsh/antigen/custom/plugins/auto-ls/auto-ls.zsh';
source '/etc/zsh/antigen/bundles/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh';
source '/etc/zsh/antigen/custom/themes/juanghurtado/juanghurtado.zsh-theme';

#--- BUNDLES END
typeset -gaU _ANTIGEN_BUNDLE_RECORD; _ANTIGEN_BUNDLE_RECORD=('https://github.com/robbyrussell/oh-my-zsh.git lib plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/colored-man-pages plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/systemd plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/git plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/history plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/per-directory-history plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/rsync plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/autojump plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/web-search plugin true' 'https://github.com/psprint/history-search-multi-word.git / plugin true' 'https://github.com/horosgrisa/mysql-colorize.git / plugin true' 'https://github.com/skx/sysadmin-util.git / plugin true' 'https://github.com/peterhurford/up.zsh.git / plugin true' 'https://github.com/zsh-users/zsh-autosuggestions.git / plugin true' 'https://github.com/djui/alias-tips.git / plugin true' 'https://github.com/bric3/nice-exit-code.git / plugin true' '/etc/zsh/antigen/custom/plugins/auto-ls / plugin false' 'https://github.com/zsh-users/zsh-syntax-highlighting.git / plugin true' '/etc/zsh/antigen/custom/themes/juanghurtado / theme false')
typeset -g _ANTIGEN_CACHE_LOADED=true ANTIGEN_CACHE_VERSION='develop'

#-- END ZCACHE GENERATED FILE
