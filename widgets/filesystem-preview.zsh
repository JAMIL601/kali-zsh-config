# ==========================================================
# Filesystem Preview Widget
# Ctrl + Space = filesystem browser
# ==========================================================

_live_fzf_preview() {

    local parsed
    parsed=(${(z)LBUFFER})

    local cmd="${parsed[1]}"

    case "$cmd" in
        cd|ls|ll|la|l|cat|less|more|head|tail|nano|vi|vim|nvim|cp|mv|rm|mkdir|rmdir|touch|ln|chmod|chown|chgrp|stat|file|readlink|realpath|find|du|diff|cmp|grep|sed|awk|python|python3|perl|ruby|php|bash|sh|zsh|source|ssh|scp|sftp|rsync|tar|zip|unzip|tree|locate|whereis|which)
            ;;
        *)
            return
            ;;
    esac

    local current="${LBUFFER##* }"

    [[ -n "$current" ]] || return

    current="${current#\"}"
    current="${current%\"}"
    current="${current#\'}"
    current="${current%\'}"

    if [[ "$current" == "~"* ]]; then
        current="${HOME}${current#\~}"
    fi

    local dir="$PWD"

    if [[ "$current" == */* ]]; then
        dir="${current:h}"
        [[ -z "$dir" ]] && dir="/"
    fi

    dir="${~dir}"

    [[ "$dir" != /* ]] && dir="$PWD/$dir"

    [[ -d "$dir" ]] || return

    local selected

    selected=$(
        command find "$dir" \
            -maxdepth 1 \
            -mindepth 1 \
            -print 2>/dev/null |
        command sort |
        fzf \
            --height=70% \
            --layout=reverse \
            --border \
            --prompt=' Files > ' \
            --pointer='▶' \
            --marker='✓' \
            --header='↑ ↓ Select   Enter Insert   Esc Cancel' \
            --preview-window='right:58%:wrap' \
            --preview '
                target={}

                if [[ -d "$target" ]]; then
                    printf "\033[1;36mDIRECTORY\033[0m\n\n"
                    printf "%s\n\n" "$target"

                    stat -c "PERM     : %A\nOWNER    : %U\nGROUP    : %G\nSIZE     : %s bytes\nMODIFIED : %y" -- "$target" 2>/dev/null

                    printf "\n\033[1;36mCONTENTS\033[0m\n\n"

                    ls -lah --color=always -- "$target" 2>/dev/null | head -20

                elif [[ -L "$target" ]]; then
                    printf "\033[1;35mSYMBOLIC LINK\033[0m\n\n"
                    printf "%s\n\n" "$target"

                    stat -c "PERM     : %A\nOWNER    : %U\nGROUP    : %G\nSIZE     : %s bytes\nMODIFIED : %y" -- "$target" 2>/dev/null

                    printf "\nTARGET   : "
                    readlink -- "$target" 2>/dev/null

                elif [[ -f "$target" ]]; then
                    printf "\033[1;32mFILE\033[0m\n\n"
                    printf "%s\n\n" "$target"

                    stat -c "PERM     : %A\nOWNER    : %U\nGROUP    : %G\nSIZE     : %s bytes\nMODIFIED : %y" -- "$target" 2>/dev/null

                    printf "\nTYPE     : "
                    file --brief -- "$target" 2>/dev/null

                    local mime
                    mime=$(file --brief --mime-type -- "$target" 2>/dev/null)

                    if [[ "$mime" == text/* ]]; then
                        printf "\n\033[1;36mCONTENT\033[0m\n\n"
                        sed -n "1,20p" -- "$target" 2>/dev/null
                    else
                        printf "\n\033[2mBinary / non-text file\033[0m\n"
                        printf "\033[2mContent preview disabled.\033[0m\n"
                    fi

                else
                    printf "\033[1;33mFILESYSTEM OBJECT\033[0m\n\n"

                    stat -c "TYPE     : %F\nPERM     : %A\nOWNER    : %U\nGROUP    : %G\nSIZE     : %s bytes\nMODIFIED : %y" -- "$target" 2>/dev/null
                fi
            '
    )

    [[ -n "$selected" ]] || return

    if [[ "$selected" == "$PWD/"* ]]; then
        selected="${selected#$PWD/}"
    fi

    LBUFFER="${LBUFFER%$current}$selected"

    zle redisplay
}

zle -N _live_fzf_preview
bindkey '^ ' _live_fzf_preview
