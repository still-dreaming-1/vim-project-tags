cd $1
find -name "*.$2" -exec ctags -f "$2tags" {} +
