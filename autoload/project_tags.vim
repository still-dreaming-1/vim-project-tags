function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= U_ls()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
endfunction

function! project_tags#FindProjectRoot(dir)
	" the following commented out line is from when I started rewriting this function to use a project file instead of the .git directory
	" let filepath= findfile('project_tags.project.vim', a:dir.path.';')
	let l:git_dir= a:dir.get_contained_dir('.git')
	if l:git_dir.exists
		return a:dir
	endif
	let l:parent_dir= a:dir.parent()
	if l:parent_dir == Null()
		return Null()
	endif
	return project_tags#FindProjectRoot(l:parent_dir)
endfunction
