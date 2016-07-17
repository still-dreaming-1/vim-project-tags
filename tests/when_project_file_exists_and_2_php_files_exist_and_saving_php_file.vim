UTSuite when a project file exists and 2 php files exist and saving a php file

function! s:setup_script_vars()
	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
	let s:static_php_file= L_dir(g:project_tags_dir_path.'/static test data').get_contained_file('supported_file.php')
	let s:static_another_php_file= L_dir(g:project_tags_dir_path.'/static test data').get_contained_file('another_class.php')
	let s:php_file= s:data_dir.get_contained_file('supported_file.php')
	let s:another_php_file= s:data_dir.get_contained_file('another_class.php')
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
	Assert! s:static_php_file.readable()
	Assert! !s:php_file.readable()
	call s:static_php_file.copy_to(s:php_file.path)
	Assert! s:php_file.readable()
	Assert! s:static_another_php_file.readable()
	Assert! !s:another_php_file.readable()
	call s:static_another_php_file.copy_to(s:another_php_file.path)
	Assert! s:another_php_file.readable()
	Assert! !s:project_file.readable()
	call s:project_file.create()
	Assert! s:project_file.readable()
	Assert! s:project_file.writable()
	call s:php_file.edit()
	Assert! !s:phptags_file.readable()
	Assert! !s:phptags_file.writable()
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

function! s:Test_created_tags_file()
	Assert s:phptags_file.readable()
endfunction

function! s:Test_only_files_are_copied_php_files_and_project_file_and_tags_file()
	let files= s:data_dir.get_all_files()
	AssertEquals(4, len(files))
	Assert s:php_file.path ==# files[0].path || s:php_file.path ==# files[1].path || s:php_file.path ==# files[2].path || s:php_file.path ==# files[3].path
	Assert s:another_php_file.path ==# files[0].path || s:another_php_file.path ==# files[1].path || s:another_php_file.path ==# files[2].path
		\ || s:another_php_file.path ==# files[3].path
	Assert s:project_file.path ==# files[0].path || s:project_file.path ==# files[1].path || s:project_file.path ==# files[2].path || s:project_file.path ==# files[3].path
	Assert s:phptags_file.path ==# files[0].path || s:phptags_file.path ==# files[1].path || s:phptags_file.path ==# files[2].path || s:phptags_file.path ==# files[3].path
endfunction

function! s:Test_tags_file_not_empty()
	Assert s:phptags_file.size() > 0
endfunction

function! s:Test_tags_file_containes_exactly_two_tags()
	call s:phptags_file.edit()
	normal! gg
	let num_lines= line('$')
	AssertEquals(2, num_lines)
endfunction

function! s:Test_tags_file_does_contain_tag_from_supported_file_class()
	call s:phptags_file.edit()
	normal! gg
	let line_num= search('supported_file')
	Assert line_num > 0
	Assert line_num < 3
endfunction

function! s:Test_tags_file_does_contain_tag_from_another_class_class()
	call s:phptags_file.edit()
	normal! gg
	let line_num= search('another_class')
	Assert line_num > 0
	Assert line_num < 3
endfunction
