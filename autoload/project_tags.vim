function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= U_ls()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
endfunction

function! project_tags#FindProjectRoot(dir)
	let proj_conf_file= a:dir.get_contained_file('.project_tags.config.vim')
	if proj_conf_file.readable
		return a:dir
	endif
	let parent_dir= a:dir.parent()
	if parent_dir == Null()
		return Null()
	endif
	return project_tags#FindProjectRoot(l:parent_dir)
endfunction
