if exist pacman; then
    if ! exist sudo; then
        echo 'Additional setups related to pacman require sudo(1) but it is unavailable. Skipping.'
    else
        if [ -f /etc/pacman.conf ]; then
            sed -E 's/#(Color)/\1/' /etc/pacman.conf > /tmp/pacman.conf
            if ! diff -q /etc/pacman.conf /tmp/pacman.conf > /dev/null; then
                diff -U 2 --color /etc/pacman.conf /tmp/pacman.conf || true
                if yesno 'Modify /etc/pacman.conf as shown above?'; then
                    sudo tee /etc/pacman.conf < /tmp/pacman.conf > /dev/null
                fi
                rm -f /tmp/pacman.conf
            fi
        fi

        if [ -f /etc/makepkg.conf ]; then
            sed -E 's/(^OPTIONS=.* )(debug .*)/\1!\2/' /etc/makepkg.conf > /tmp/makepkg.conf
            if ! diff -q /etc/makepkg.conf /tmp/makepkg.conf > /dev/null; then
                diff -U 2 --color /etc/makepkg.conf /tmp/makepkg.conf || true
                if yesno 'Modify /etc/makepkg.conf as shown above?'; then
                    sudo tee /etc/makepkg.conf < /tmp/makepkg.conf > /dev/null
                fi
                rm -f /tmp/makepkg.conf
            fi
        fi

        if ! exist yay && yesno 'Install yay?'; then
            sudo pacman -S --needed git base-devel
            git clone https://aur.archlinux.org/yay-bin.git ~/git/yay-bin
            cd ~/git/yay-bin
            makepkg -si
            cd -
        fi
    fi
fi
