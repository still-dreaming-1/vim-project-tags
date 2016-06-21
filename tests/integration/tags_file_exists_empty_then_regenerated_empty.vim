UTSuite tags_file integration: Exists empty, then regenerated empty

function! s:setup_script_vars()
	let s:data_dir= Dir(g:project_tags_dir_path.'/generated test data')
	let s:tags_file= project_tags_tags_file#new(s:data_dir, '.php')
endfunction

function! s:safe_teardown()
	call s:setup_script_vars()
	if s:data_dir.exists()
		call s:data_dir.delete()
	endif
endfunction

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert !s:data_dir.exists()
	call s:data_dir.create()
	Assert s:data_dir.exists()
	Assert !s:tags_file.readable()
	call s:tags_file.regenerate_empty()
	Assert s:tags_file.readable()
	call s:tags_file.regenerate_empty()
endfunction

function! s:Teardown()
	Assert s:data_dir.exists()
	call s:data_dir.delete()
	Assert !s:data_dir.exists()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:Test_tags_file_readable()
	Assert s:tags_file.readable()
endfunction

function! s:Test_tags_file_writable()
	Assert s:tags_file.writable()
endfunction

function! s:Test_tags_file_is_empty()
	AssertEquals(0, s:tags_file.size())
endfunction
