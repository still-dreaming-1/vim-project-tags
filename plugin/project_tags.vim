" Finding the project root and creating tag files for different
" languages works well enough, but sometimes, more fine grained control is
" wanted. For example I work on a web project where the root project
" directory has a mobile directory inside it. The mobile directory depends on
" code from the rest of the project, but the rest of the project never
" depends on the code from the mobile directory. There needs to be a way to
" define the relationships between directories. In this case, I want
" the mobile directory to be excluded when generating tags in the main
" directory. I want the mobile directory to contain its own tag files that
" only point to stuff inside that directory. When editing files in the mobile
" directory, I want vim to look in the tag files stored there first, and only
" look at the main tag files if not found in the mobile ones. When a file
" from the mobile directory is saved, the tag file in that directory for the
" approriate language should be regenerated. Also, the appropriate tag file in
" the main directory should also be regenerated, following the normal rules of
" excluding the mobile directory.
" The simplest solution I can think of for the file that defines relationships
" is to have a .vim file with a specific name. It will get sourced, and it
" should contain settings stored in expected variable names. It is ok if it
" overwrites previously stored values in this variable because the file is
" sourced just before the variable is used.

function! s:GenerateTags(file_extension)
	call Log('starting GenerateTags')
	let project_root_dir= project_tags#find_project_root(L_current_buffer().dir())
	if project_root_dir == Null()
		call Log('No project root found. Not generating tags')
		return
	endif
	let tags_filename= a:file_extension.'tags'
	let tags_filepath= project_root_dir.path.'/'.tags_filename
	let rm_out= system('rm -f "'.tags_filepath.'"')
	let project_config= project_tags#get_immediate_project_file(project_root_dir)
	let g:project_tags_exclude= []
	let g:project_tags_include= []
	call Log('after create project variables before the project file is sourced')
	call project_config.source()
	let tags_file= project_tags_tags_file#new(project_root_dir, a:file_extension)
	if exists('g:project_tags_ctags_path')
		let tags_file.ctags_path= g:project_tags_ctags_path
	endif
	call Log('before regenerate tags')
	call tags_file.regenerate_excluding(g:project_tags_exclude)
	call Log('after regenerate tags')
endfunction

call project_tags#add_extension('php')
call project_tags#add_extension('js')
augroup <SID>mapping_group
	" removes all autocmd in group
	autocmd!
	for s:extension in g:project_tags_extension_ls.ls
		execute 'autocmd BufRead *.'.s:extension.' setlocal tags=./'.s:extension.'tags;'
		execute 'autocmd bufwritepost *.'.s:extension.' silent call s:GenerateTags("'.s:extension.'")'
	endfor
augroup END

let s:current_script_path= expand('<sfile>')
let g:project_tags_dir_path= L_dir(s:current_script_path).parent().parent().path
