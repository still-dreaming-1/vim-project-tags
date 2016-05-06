UTSuite tags_file

function! s:Test_path()
	let dir= Dir('/dkjfkdjfkdj')
	let tags_file= project_tags_tags_file#new(dir, 'php')
	Assert S(tags_file.path).starts_with(dir.path)
endfunction
