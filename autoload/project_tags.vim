function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_l')
		let g:project_tags_extension_l= []
	endif
	call add(g:project_tags_extension_l, a:file_extension)
endfunction
