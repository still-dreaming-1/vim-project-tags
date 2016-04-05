" Finding the project root and creating tag files for different
" languages works well enough, but sometimes, more fine grained control is
" wanted. For example I work on a web project where the root project
" directory has a mobile directory inside it. The mobile directory depends on
" code from the rest of the project, but the rest of the project never
" depends on the code from the mobile directory. There needs to be a way to
" define the relationships between directories. In this case, I want
" the mobile directory to be excluded when generating tags in the main
" directory. I want the mobile directory to contain its own tag files that
" only point to stuff inside that directory. When editing files in the mobile
" directory, I want vim to look in the tag files stored there first, and only
" look at the main tag files if not found in the mobile ones. When a file
" from the mobile directory is saved, the tag file in that directory for the
" approriate language should be regenerated. Also, the appropriate tag file in
" the main directory should also be regenerated, following the normal rules of
" excluding the mobile directory.
" The simplest solution I can think of for the file that defines relationships
" is to have a .vim file with a specific name. It will get sourced, and it
" should contain settings stored in expected variable names. It is ok if it
" overwrites previously stored values in this variable because the file is
" sourced just before the variable is used.

function! s:GenerateTags(file_extension)
	let l:project_root_dir= s:FindProjectRoot()
	if l:project_root_dir == ''
		echo 'No project root found. Not generating tags'
		return
	endif
	let l:tags_filename= a:file_extension.'tags'
	let l:tags_filepath= l:project_root_dir.path.'/'.l:tags_filename
	let l:rm_out= system('rm -f "'.l:tags_filepath.'"')
	echo 'rm out: '.l:rm_out
	if exists('g:project_tags_ctags_path')
		let l:ctags= g:project_tags_ctags_path
	else
		let l:ctags= 'ctags'
	endif
	let l:command= "find '".l:project_root_dir.path."' -name '*".a:file_extension."' -exec ".l:ctags." --append=yes -f '".l:tags_filepath."' {} +"
	echo 'command: '.l:command
	let l:out= system(l:command)
	echo 'out: '.l:out
endfunction

function! s:FindProjectRoot()
	let l:buffer_dir= l_dir#new(expand("%:p:h"))
	echo 'buffer dir path: '.l:buffer_dir.path
	return s:FindProjectRootRecursive(l:buffer_dir)
endfunction

function! s:FindProjectRootRecursive(dir)
	" the following commented out line is from when I started rewriting this function to use a project file instead of the .git directory
	" let filepath= findfile('project_tags.project.vim', a:dir.path.';')
	echo 'recursive dir path '.a:dir.path
	echo 'recursive dir path length: '.len(a:dir.path)
	let l:git_dir= l_dir#new(a:dir.path.'/.git')
	if l:git_dir.exists
		echo 'found git dir: '.l:git_dir.path
		return a:dir
	endif
	echo 'failed git path: '.l:git_dir.path
	echo 'failed git path length: '.len(l:git_dir.path)
	let l:parent_dir= a:dir.parent()
	if l:parent_dir == ''
		echo 'no parent dir.'
		return ''
	endif
	return s:FindProjectRootRecursive(l:parent_dir)
endfunction

call project_tags#add_extension('php')
call project_tags#add_extension('js')
augroup <SID>mapping_group
	" removes all autocmd in group
	autocmd!
	for s:extension in g:project_tags_extension_l
		execute 'autocmd BufRead *.'.s:extension.' setlocal tags=./'.s:extension.'tags;'
		execute 'autocmd bufwritepost *.'.s:extension.' silent call s:GenerateTags("'.s:extension.'")'
	endfor
augroup END
