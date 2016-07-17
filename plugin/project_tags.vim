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

function! s:GenerateTags(language)
	call l#log('starting GenerateTags')
	let project_root_dir= project_tags#find_project_root(L_current_buffer().dir())
	if project_root_dir == L_null()
		call l#log('No project root found. Not generating tags')
		return
	endif
	let tags_filepath= project_root_dir.path.'/'.a:language.tags_filename
	let rm_out= system('rm -f "'.tags_filepath.'"')
	let project_config= project_tags#get_immediate_project_file(project_root_dir)
	let g:project_tags_exclude= []
	let g:project_tags_include= []
	call l#log('after create project variables before the project file is sourced')
	call project_config.source()
	let tags_file= project_tags_tags_file#new(project_root_dir, a:language)
	if exists('g:project_tags_ctags_path')
		let tags_file.ctags_path= g:project_tags_ctags_path
	endif
	call l#log('before regenerate tags')
	call tags_file.regenerate(g:project_tags_exclude, g:project_tags_include)
	call l#log('after regenerate tags')
endfunction

call project_tags#add_language('js')
call project_tags#add_language('vim')
call project_tags#add_language('php')
call project_tags#add_language('ctags', ['c', 'h'])
augroup <SID>mapping_group
	" removes all autocmd in group
	autocmd!
	let i= 0
	while i < len(g:project_tags_language_ls)
		let s:language= g:project_tags_language_ls[i]
		call l#log('project-tags: setting up tag generation for '.s:language.tags_filename.' file')
		for s:extension in s:language.file_extension_list
			let s:autocmd_string= 'autocmd BufRead *.'.s:extension.' setlocal tags=./'.s:language.tags_filename.';'
			call l#log('project_tags: BufRead autocmd: '.s:autocmd_string)
			execute s:autocmd_string
			let s:autocmd_string= 'autocmd bufwritepost *.'.s:extension.' silent call s:GenerateTags(g:project_tags_language_ls['.i.'])'
			call l#log('project_tags: bufwritepost autocmd: '.s:autocmd_string)
			execute s:autocmd_string
		endfor
		let i= i + 1
	endwhile
augroup END

let s:current_script_path= expand('<sfile>')
let g:project_tags_dir_path= L_dir(s:current_script_path).parent().parent().path
