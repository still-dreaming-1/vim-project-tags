function! project_tags_tags_file#new(dir, file_extension)
	let tags_file= {}
	let tags_file.path= a:dir.get_contained_file(a:file_extension.'tags').path

	function! tags_file.regenerate_empty()
		let file= File(self.path)
		if self.readable() && self.size() > 0
			call file.delete()
		endif
		call file.create()
	endfunction

	function! tags_file.append_from(code_file_path)
	endfunction

	function! tags_file.readable()
		return File(self.path).readable()
	endfunction

	function! tags_file.writable()
		return File(self.path).writable()
	endfunction

	function! tags_file.size()
		return File(self.path).size()
	endfunction

	return tags_file
endfunction
