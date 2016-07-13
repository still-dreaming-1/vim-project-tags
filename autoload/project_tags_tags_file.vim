function! project_tags_tags_file#new(dir, language)
	let tags_file= {}
	let tags_file.for_extension_ls= a:language.file_extension_list
	let tags_file.dir= L_dir(a:dir.path)
	let tags_file.path= a:dir.get_contained_file(a:language.tags_filename).path
	let tags_file.ctags_path= 'ctags'

	function! tags_file.regenerate_empty()
		let file= L_file(self.path)
		if self.readable() && self.size() > 0
			call file.delete()
		endif
		call file.create()
	endfunction

	function! tags_file.regenerate(exclude_dir_name_list, include_dir_name_list)
		call self.regenerate_empty()
		let grep_exclude_str= ''
		for exclude_dir_name in a:exclude_dir_name_list
			let path= self.dir.get_contained_dir(exclude_dir_name).path
			let grep_exclude_str= grep_exclude_str." -ve '^".path."'"
		endfor
		if len(grep_exclude_str) > 0
			let grep_exclude_str= 'grep'.grep_exclude_str.' | '
		endif
		let starting_command= 'find '.shellescape(self.dir.path)
		for include_dir_name in a:include_dir_name_list
			" code to convert list of relative directory names into a list of absolute paths
			let include_dir_path= self.dir.get_relative_dir(include_dir_name).path
			let starting_command= starting_command.' '.shellescape(include_dir_path)
		endfor
		for extension in self.for_extension_ls
			let extension_search_str= L_s(shellescape(extension)).remove_start().remove_end().str
			let extension_search_str= "'*.".extension_search_str."'"
			let command= starting_command.' -type f -name '.extension_search_str
				\ .' | '.grep_exclude_str.'xargs -d '."'\n' ".self.ctags_path.' --append=yes -f '.shellescape(self.path)
			call L_shell().run(command)
		endfor
	endfunction

	function! tags_file.readable()
		return L_file(self.path).readable()
	endfunction

	function! tags_file.writable()
		return L_file(self.path).writable()
	endfunction

	function! tags_file.size()
		return L_file(self.path).size()
	endfunction

	return tags_file
endfunction
