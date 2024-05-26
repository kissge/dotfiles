function _git-commit () {
  local amend_opt='--amend[amend the tip of the current branch]'
  if __git_is_initial_commit || __git_is_in_middle_of_merge; then
    amend_opt=
  fi

  local reset_author_opt=
  if (( words[(I)-C|--reuse-message(=*|)|-c|--reedit-message(=*|)|--amend] )); then
    reset_author_opt='(--author)--reset-author[make committer the author of the commit]'
  fi

  # TODO: --interactive isn't explicitly listed in the documentation.
  _arguments -S -s $endopt \
    '(-a --all --interactive -o --only -i --include *)'{-a,--all}'[stage all modified and deleted paths]' \
    '--fixup=[construct a commit message for use with rebase --autosquash]:commit to be amended:_git_fixup' \
    '--squash=[construct a commit message for use with rebase --autosquash]:commit to be amended:__git_recent_commits' \
    $reset_author_opt \
    '(        --porcelain --dry-run)--short[dry run with short output format]' \
    '--branch[show branch information]' \
    '!(--no-ahead-behind)--ahead-behind' \
    "--no-ahead-behind[don't display detailed ahead/behind counts relative to upstream branch]" \
    '(--short             --dry-run)--porcelain[dry run with machine-readable output format]' \
    '(--short --porcelain --dry-run -z --null)'{-z,--null}'[dry run with NULL-separated output format]' \
    {-p,--patch}'[use the interactive patch selection interface to chose which changes to commit]' \
    '(--reset-author)--author[override the author name used in the commit]:author name' \
    '--date=[override the author date used in the commit]:date' \
    '*--trailer=[add custom trailer(s)]:trailer' \
    '(-s --signoff)'{-s,--signoff}'[add Signed-off-by trailer at the end of the commit message]' \
    '(-n --no-verify)'{-n,--no-verify}'[bypass pre-commit and commit-msg hooks]' \
    '--allow-empty[allow recording an empty commit]' \
    '--allow-empty-message[allow recording a commit with an empty message]' \
    '--cleanup=[specify how the commit message should be cleaned up]:mode:_git_cleanup_modes' \
    '(-e --edit --no-edit)'{-e,--edit}'[edit the commit message before committing]' \
    '(-e --edit --no-edit)--no-edit[do not edit the commit message before committing]' \
    '--no-post-rewrite[bypass the post-rewrite hook]' \
    '(-a --all --interactive -o --only -i --include)'{-i,--include}'[update the given files and commit the whole index]' \
    '(-a --all --interactive -o --only -i --include)'{-o,--only}'[commit only the given files]' \
    '(-u --untracked-files)'{-u-,--untracked-files=-}'[show files in untracked directories]::mode:((no\:"show no untracked files"
                                                                                                  normal\:"show untracked files and directories"
                                                                                                  all\:"show individual files in untracked directories"))' \
    '(*)--pathspec-from-file=[read pathspec from file]:file:_files' \
    '(*)--pathspec-file-nul[pathspec elements are separated with NUL character]' \
    '(-q --quiet -v --verbose)'{-v,--verbose}'[show unified diff of all file changes]' \
    '(-q --quiet -v --verbose)'{-q,--quiet}'[suppress commit summary message]' \
    '--dry-run[only show list of paths that are to be committed or not, and any untracked]' \
    '(         --no-status)--status[include the output of git status in the commit message template]' \
    '(--status            )--no-status[do not include the output of git status in the commit message template]' \
    '(-S --gpg-sign --no-gpg-sign)'{-S-,--gpg-sign=}'[GPG-sign the commit]::key id' \
    "(-S --gpg-sign --no-gpg-sign)--no-gpg-sign[don't GPG-sign the commit]" \
    '(-a --all --interactive -o --only -i --include *)--interactive[interactively update paths in the index file]' \
    $amend_opt \
    '*: :__git_ignore_line_inside_arguments __git_changed_files' \
    - '(message)' \
      {-C+,--reuse-message=}'[use existing commit object with same log message]: :__git_commits' \
      {-c+,--reedit-message=}'[use existing commit object and edit log message]: :__git_commits' \
      {-F+,--file=}'[read commit message from given file]: :_files' \
      \*{-m+,--message=}'[use the given message as the commit message]:message:__git_commit_messages' \
      {-t+,--template=}'[use file as a template commit message]:template:_files'
}

function __git_commit_messages() {
  local -a messages
  messages=(${(f)"$(git log --format=$'%s\1%an    %ai' 2> /dev/null | sed -E 's/:/\\:/g; s/\x1/:/')"})
  _sequence -V messages -n 1 _describe 'previous commit messages' messages
}

