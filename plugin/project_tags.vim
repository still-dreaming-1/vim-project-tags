call project_tags#add_built_in_language_support()
let s:current_script_path= expand('<sfile>')
let g:project_tags_dir_path= L_dir(s:current_script_path).parent().parent().path
