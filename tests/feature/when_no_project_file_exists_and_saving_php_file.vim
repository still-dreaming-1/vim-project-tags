UTSuite when no project file exists and saving php file

function! s:setup_script_vars()
	let s:data_dir= Dir(g:project_tags_dir_path.'/tests/data')
	let s:static_php_file= Dir(g:project_tags_dir_path.'/static test data').get_contained_file('supported_file.php')
	let s:php_file= s:data_dir.get_contained_file('supported_file.php')
endfunction

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
	Assert! s:static_php_file.readable()
	Assert! !s:php_file.readable()
	call s:static_php_file.copy_to(s:php_file.path)
	Assert! s:php_file.readable()
	Assert! s:php_file.writable()
	call s:php_file.edit()
	w
endfunction

function! s:safe_teardown()
	call s:setup_script_vars()
	if s:data_dir.exists()
		call s:data_dir.delete()
	endif
endfunction

function! s:Teardown()
	call s:setup_script_vars()
	Assert s:data_dir.exists()
	call s:data_dir.delete()
	Assert !s:data_dir.exists()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:Test_not_create_tags_file()
	let phptags_file= s:data_dir.get_contained_file('phptags')
	Assert !phptags_file.readable()
endfunction

function! s:Test_only_file_is_copied_php_file()
	let files= s:data_dir.get_all_files()
	AssertEquals(1, len(files))
	AssertEquals(s:php_file.path, files[0].path)
endfunction
