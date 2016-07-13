function! project_tags#add_language(tags_filename, file_extension_list)
	call l#log('project_tags autoload add_language() start')
	if !exists('g:project_tags_language_ls')
		let g:project_tags_language_ls= []
	endif
	let language= {}
	let language.tags_filename= a:tags_filename
	let language.file_extension_list= a:file_extension_list
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
