#!/bin/sh
# edit metadata of a repository

# check number of params
[ $# -ne 1 ] && echo "Usage: e repo[.git]" && exit 1

# set the repository name, adding .git if necessary
p=$(echo "$1" | sed 's/\.git$\|$/.git/i')

[ ! -d "$p" ] && echo "$p not found." && exit 1

get_category() {
    if [ ! -f "$p/git-daemon-export-ok" ]; then
        echo "Private repository"
    elif [ ! -f "$p/category" ]; then
        echo "Unlisted repository (public cloning but not listed on website)"
    else
        printf "Public repository, category: "
        cat "$p/category"
    fi
}

modify_metadata() {
    printf "Enter new $1: "
    read answer
    echo "$answer" > "$p/$1"
}

modify_category() {
    echo "Category options:

    [p]rivate repository
    [u]nlisted repository (public cloning but not listed on website)

    [pr]ojects (public repository)
    [pe]rsonal setup (public repository)
    [m]iscellanea (public repository)"

    printf ">>> "
    read answer

    case $answer in
        p) rm -f "$p/git-daemon-export-ok"; rm -f "$p/category" ;;
        u) touch "$p/git-daemon-export-ok"; rm -f "$p/category" ;;
        pr) touch "$p/git-daemon-export-ok"; echo "Projects" > "$p/category" ;;
        pe) touch "$p/git-daemon-export-ok"; echo "Personal setup" > "$p/category" ;;
        m) touch "$p/git-daemon-export-ok"; echo "Miscellanea" > "$p/category" ;;
        *) echo "Option unknown" ;;
    esac
}

while true; do
    echo "Editing repository $p. What data do you want to modify?

    [u]rl: $(cat "$p/url")
    [o]wner: $(cat "$p/owner")
    [d]escription: $(cat "$p/description")
    [c]ategory/visibility: $(get_category)

    [e]xit"

    printf "> "
    read answer

    case $answer in
        u) modify_metadata "url" ;;
        o) modify_metadata "owner" ;;
        d) modify_metadata "description" ;;
        c) modify_category ;;
        e) break ;;
        *) echo "Option unknown" ;;
    esac
done

$HOME/git-shell-commands/r
