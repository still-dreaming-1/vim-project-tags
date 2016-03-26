UTSuite vim-project-tags tests

function! s:Test_parse_parent_dir()
	let l:parent= project_tags#parse_parent_dir('~/.config')
	Assert l:parent == '~'
endfunction
