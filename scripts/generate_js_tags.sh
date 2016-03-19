cd $1
find -name '*.js' -exec ctags {} +
mv tags jstags
