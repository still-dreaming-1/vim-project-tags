UTSuite when specifying an exclude dir

function! s:setup_script_vars()
	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
	let s:static_data_dir= L_dir(g:project_tags_dir_path.'/static test data')
	let s:exclude_dir= s:data_dir.get_contained_dir('exclude dir')
	let s:static_php_file= s:static_data_dir.get_contained_file('supported_file.php')
	let s:php_file= s:data_dir.get_contained_file('supported_file.php')
	let s:another_static_php_file= s:static_data_dir.get_contained_file('another_class.php')
	let s:another_php_file= s:exclude_dir.get_contained_file('another_class.php')
	let s:static_exclude_project_file= s:static_data_dir.get_contained_file('exclude_dir_project.vim')
	let s:project_file= s:data_dir.get_contained_file('.project_tags.config.vim')
	let s:phptags_file= s:data_dir.get_contained_file('phptags')
endfunction

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
	Assert! s:static_data_dir.exists()
	Assert! s:static_php_file.readable()
	Assert! !s:php_file.readable()
	call s:static_php_file.copy_to(s:php_file.path)
	Assert! s:php_file.readable()
	Assert! s:php_file.writable()
	Assert! s:static_exclude_project_file.readable()
	Assert! !s:project_file.readable()
	call s:static_exclude_project_file.copy_to(s:project_file.path)
	Assert! s:project_file.readable()
	Assert! s:project_file.writable()
	Assert! !s:exclude_dir.exists()
	call s:exclude_dir.create()
	Assert! s:exclude_dir.exists()
	Assert! s:another_static_php_file.readable()
	Assert! !s:another_php_file.readable()
	call s:another_static_php_file.copy_to(s:another_php_file.path)
	Assert! s:another_php_file.readable()
	Assert! !s:phptags_file.readable()
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

function! s:Test_accepted_project_file_exclude_setting()
	AssertEquals(1, len(g:project_tags_exclude))
	AssertEquals('exclude dir', g:project_tags_exclude[0])
endfunction

function! s:Test_created_tags_file()
	Assert s:phptags_file.readable()
	Assert s:phptags_file.writable()
endfunction

function! s:Test_only_3_files_in_data_dir()
	let files= s:data_dir.get_all_files()
	AssertEquals(3, len(files))
endfunction

function! s:Test_tags_file_does_not_contain_tags_from_excluded_dir()
	call s:phptags_file.edit()
	normal! gg
	let line_num= search('another_class')
	AssertEquals(0, line_num)
endfunction
