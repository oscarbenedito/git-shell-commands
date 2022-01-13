#!/bin/sh
# create a new repository (private by default)

# check number of params
[ $# -ne 1 ] && echo "Usage: i repo[.git]" && exit 1

# set the repository name, adding .git if necessary
p=$(echo "$1" | sed 's/\.git$\|$/.git/i')

[ -e "$p" ] && echo "$p is already a file or directory." && exit 1

# create and initialise the repository
mkdir "$p" && \
    cd "$p" && \
    git --bare init
ln -sf "/usr/local/share/doc/stagit/example_post-receive.sh" "hooks/post-receive"
ln -sf "$(dirname "$(realpath "$0")")/non-interactive/post-update-hook" "hooks/post-update"

echo "Oscar Benedito" > "owner"
echo "https://git.oscarbenedito.com/${p%.git}" > "url"
echo "${p%.git}" > "description"
