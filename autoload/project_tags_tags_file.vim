function! project_tags_tags_file#new(dir, file_extension)
	let tags_file= {}
	let tags_file.path= a:dir.get_contained_file(a:file_extension.'tags').path

	function! tags_file.regenerate_empty()
	endfunction

	function! tags_file.append_from(code_file_path)
	endfunction

	return tags_file
endfunction
