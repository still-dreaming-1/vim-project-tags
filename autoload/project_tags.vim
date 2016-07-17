" The simplest way to use this functin is just pass in a file extension as a string (without the .). In that case the name of the tags file is chosen for you. It will be the file
" extensionwith 'tags' added to the end (jstags, phptags, etc). If you pass in 2 parameters, the first is the name of the tags file for the file generated for the file etensions passed
" in the second parameter. The second parameter would then be either a list of file extensions or a single file extension as a string. See project_tags.vim for examples.
function! project_tags#add_language(...)
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
	call l#log('project_tags autoload add_language() start')
	if !exists('g:project_tags_language_ls')
		let g:project_tags_language_ls= []
	endif
	let language= {}
	let language.tags_filename= tags_filename
	let language.file_extension_list= file_extension_list
	call add(g:project_tags_language_ls, language)
	call l#log('project_tags autoload add_language() end')
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
