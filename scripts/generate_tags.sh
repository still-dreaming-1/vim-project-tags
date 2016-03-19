cd $1
find -name "*.$2" -exec ctags {} +
mv tags "$2tags"
