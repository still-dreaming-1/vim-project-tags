function! project_tags_tags_file#new(dir, file_extension)
	let tags_file= {}
	let tags_file.path= a:dir.get_contained_file(a:file_extension.'tags').path
	let tags_file.ctags_path= 'ctags'

	function! tags_file.regenerate_empty()
		let file= File(self.path)
		if self.readable() && self.size() > 0
			call file.delete()
		endif
		call file.create()
	endfunction

	function! tags_file.append_from_all(code_file_path_list)
		let command= self.ctags_path." --append=yes -f ".shellescape(self.path)
		for file_path in a:code_file_path_list
			let command= command." ".shellescape(file_path)
		endfor
		call Shell().run(command)
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
