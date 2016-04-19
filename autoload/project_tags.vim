function! project_tags#add_extension(file_extension)
	if !exists('g:project_tags_extension_ls')
		let g:project_tags_extension_ls= U_ls()
	endif
	call g:project_tags_extension_ls.add(a:file_extension)
endfunction

function! project_tags#FindProjectRoot(dir)
	" the following commented out line is from when I started rewriting this function to use a project file instead of the .git directory
	" let filepath= findfile('project_tags.project.vim', a:dir.path.';')
	echo 'recursive dir path '.a:dir.path
	echo 'recursive dir path length: '.len(a:dir.path)
	let l:git_dir= Dir(a:dir.path.'/.git')
	if l:git_dir.exists
		echo 'found git dir: '.l:git_dir.path
		return a:dir
	endif
	echo 'failed git path: '.l:git_dir.path
	echo 'failed git path length: '.len(l:git_dir.path)
	let l:parent_dir= a:dir.parent()
	if l:parent_dir == Null()
		echo 'no parent dir.'
		return ''
	endif
	return project_tags#FindProjectRoot(l:parent_dir)
endfunction
