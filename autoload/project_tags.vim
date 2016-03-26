function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_l')
		let g:project_tags_extension_l= []
	endif
	call add(g:project_tags_extension_l, a:file_extension)
endfunction

function! project_tags#parse_parent_dir(dir_path)
	let l:parent_dir= system("dirname '".a:dir_path."'")
	let l:len = len(l:parent_dir)
	if l:parent_dir[l:len - 1] == "\n"
		let l:parent_dir= l:parent_dir[0 : l:len - 2]
	endif
	return l:parent_dir
endfunction
