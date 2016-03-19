cd $1
find -name '*.php' -exec ctags {} +
mv tags phptags
