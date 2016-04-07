function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= l_u_ls#new()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
endfunction
