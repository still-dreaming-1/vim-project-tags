UTSuite tags_file integration: When tags file exists empty, then append tags

function! s:setup_script_vars()
	let s:data_dir= Dir(g:project_tags_dir_path.'/tests/data')
	let s:tags_file= project_tags_tags_file#new(s:data_dir, '.php')
	let s:static_php_file= File(g:project_tags_dir_path.'/tests/static data/supported_file.php')
endfunction

function! s:safe_teardown()
	call s:setup_script_vars()
	if s:data_dir.exists()
		call s:data_dir.delete()
	endif
endfunction

function! s:Setup()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert !s:data_dir.exists()
	call s:data_dir.create()
	Assert s:data_dir.exists()
	Assert !s:tags_file.readable()
	call s:tags_file.regenerate_empty()
	Assert s:tags_file.readable()
	AssertEquals(0, s:tags_file.size())
	Assert s:static_php_file.readable()
	Assert s:static_php_file.size() > 0
	call s:tags_file.append_from(s:static_php_file.path)
endfunction

function! s:Teardown()
	Assert s:data_dir.exists()
	call s:data_dir.delete()
	Assert !s:data_dir.exists()
endfunction

function! s:Test_tags_file_readable()
	Assert s:tags_file.readable()
endfunction

function! s:Test_tags_file_writable()
	Assert s:tags_file.writable()
endfunction

function! s:Test_tags_file_not_empty()
	Assert s:tags_file.size() > 0
endfunction
