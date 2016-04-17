function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= U_ls()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
endfunction
