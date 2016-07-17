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
function! project_tags#generate_tags(...)
	call l#log('starting project_tags#generate_tags')
	let tags_filename= a:1
	let file_extension_list_len= a:0 - 1
	let file_extension_list= []
	let i= 0
	while i < file_extension_list_len
		let a_i= i + 2
		let add_string= 'call add(file_extension_list, a:'.a_i.')'
		execute add_string
		let i= i + 1
	endwhile
	let project_root_dir= project_tags#find_project_root(L_current_buffer().dir())
	if project_root_dir == L_null()
		call l#log('No project root found. Not generating tags')
		return
	endif
	let tags_filepath= project_root_dir.path.'/'.tags_filename
	let rm_out= system('rm -f "'.tags_filepath.'"')
	let project_config= project_tags#get_immediate_project_file(project_root_dir)
	let g:project_tags_exclude= []
	let g:project_tags_include= []
	call l#log('after create project variables before the project file is sourced')
	call project_config.source()
	let tags_file= project_tags_tags_file#new(project_root_dir, tags_filename, file_extension_list)
	if exists('g:project_tags_ctags_path')
		let tags_file.ctags_path= g:project_tags_ctags_path
	endif
	call l#log('before regenerate tags')
	call tags_file.regenerate(g:project_tags_exclude, g:project_tags_include)
	call l#log('after regenerate tags')
endfunction

" The simplest way to use this functin is just pass in a file extension as a string (without the .). In that case the name of the tags file is chosen for you. It will be the file
" extensionwith 'tags' added to the end (jstags, phptags, etc). If you pass in 2 parameters, the first is the name of the tags file for the file generated for the file etensions passed
" in the second parameter. The second parameter would then be either a list of file extensions or a single file extension as a string. See project_tags.vim for examples.
function! project_tags#add_language(...)
	call l#log('project_tags autoload add_language() start')
	if a:0 == 2
		let tags_filename= a:1
		if type(a:2) == l_type#string()
			let file_extension_list= [a:2]
		else
			let file_extension_list= a:2
		endif
	endif
	if a:0 == 1
		let file_extension= a:1
		let tags_filename= file_extension.'tags'
		let file_extension_list= [file_extension]
	endif

	augroup <SID>mapping_group
		call l#log('project-tags: setting up tag generation for '.tags_filename.' file')
		for extension in file_extension_list
			let autocmd_string= 'autocmd BufRead *.'.extension.' setlocal tags=./'.tags_filename.';'
			call l#log('project_tags: BufRead autocmd: '.autocmd_string)
			execute autocmd_string
			let autocmd_string= 'autocmd bufwritepost *.'.extension." silent call project_tags#generate_tags('".tags_filename."'"
			for file_extension in file_extension_list
				let autocmd_string= autocmd_string.", '".file_extension."'"
			endfor
			let autocmd_string= autocmd_string.')'
			call l#log('project_tags: bufwritepost autocmd: '.autocmd_string)
			execute autocmd_string
		endfor
	augroup END

	call l#log('project_tags autoload add_language() end')
endfunction

function! project_tags#add_built_in_language_support()
	call project_tags#add_language('js')
	call project_tags#add_language('vim')
	call project_tags#add_language('php')
endfunction

function! project_tags#remove_all_languages()
	augroup <SID>mapping_group
		" removes all autocmd in group
		autocmd!
	augroup END
endfunction

function! project_tags#find_project_root(dir)
	let proj_conf_file= project_tags#get_immediate_project_file(a:dir)
	if proj_conf_file != L_null()
		return a:dir
	endif
	let parent_dir= a:dir.parent()
	if parent_dir == L_null()
		return L_null()
	endif
	return project_tags#find_project_root(parent_dir)
endfunction

function! project_tags#get_immediate_project_file(dir)
	let proj_conf_file= a:dir.get_contained_file('.project_tags.config.vim')
	if proj_conf_file.readable()
		return proj_conf_file
	endif
	return L_null()
endfunction!
