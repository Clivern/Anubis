mkdir -p ~/Space/Personal
mkdir -p ~/Space/Work

[[ -z "$GIT_AUTHOR_NAME" ]] && { echo "\033[0;31mGIT_AUTHOR_NAME is empty, quit extra.sh\033[0m" ; exit 1; }
[[ -z "$PERSONAL_SPACE_GIT_AUTHOR_NAME" ]] && { echo "\033[0;31mPERSONAL_SPACE_GIT_AUTHOR_NAME is empty, quit extra.sh\033[0m" ; exit 1; }
[[ -z "$WORK_SPACE_GIT_AUTHOR_NAME" ]] && { echo "\033[0;31mWORK_SPACE_GIT_AUTHOR_NAME is empty, quit extra.sh\033[0m" ; exit 1; }

echo "Copy .gitconfig-personal-space -> ~"
cp .gitconfig-personal-space ~;

echo "Copy .gitconfig-work-space -> ~"
cp .gitconfig-work-space ~;

echo "Create ~/.extra"

echo "GIT_AUTHOR_NAME=\"$GIT_AUTHOR_NAME\"
GIT_COMMITTER_NAME=\"$GIT_AUTHOR_NAME\"
GIT_AUTHOR_EMAIL=\"$GIT_AUTHOR_EMAIL\"
GIT_COMMITTER_EMAIL=\"$GIT_AUTHOR_EMAIL\"

PERSONAL_SPACE_GIT_AUTHOR_NAME=\"$PERSONAL_SPACE_GIT_AUTHOR_NAME\"
PERSONAL_SPACE_GIT_AUTHOR_EMAIL=\"$PERSONAL_SPACE_GIT_AUTHOR_EMAIL\"
WORK_SPACE_GIT_AUTHOR_NAME=\"$WORK_SPACE_GIT_AUTHOR_NAME\"
WORK_SPACE_GIT_AUTHOR_EMAIL=\"$WORK_SPACE_GIT_AUTHOR_EMAIL\"
" > ~/.extra

echo "
[user]
    name = \"$PERSONAL_SPACE_GIT_AUTHOR_NAME\"
    email = \"$PERSONAL_SPACE_GIT_AUTHOR_EMAIL\"
" >> ~/.gitconfig-personal-space

echo "
[user]
    name = \"$WORK_SPACE_GIT_AUTHOR_NAME\"
    email = \"$WORK_SPACE_GIT_AUTHOR_EMAIL\"
" >> ~/.gitconfig-work-space
