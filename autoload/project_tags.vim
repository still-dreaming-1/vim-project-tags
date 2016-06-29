function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= L_u_ls()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
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
