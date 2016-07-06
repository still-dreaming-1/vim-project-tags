UTSuite when specifying an include dir and saving code from the project dir

function! s:setup_script_vars()
	let s:static_data_dir= L_dir(g:project_tags_dir_path.'/static test data')
		let s:static_php_file= s:static_data_dir.get_contained_file('supported_file.php')
		let s:static_another_php_file= s:static_data_dir.get_contained_file('another_class.php')
		let s:static_include_project_file= s:static_data_dir.get_contained_file('include_dir_project.vim')

	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
		let s:include_dir= s:data_dir.get_contained_dir('include dir')
			let s:another_php_file= s:include_dir.get_contained_file('another_class.php')
		let s:proj_dir= s:data_dir.get_contained_dir('proj dir')
			let s:project_file= s:proj_dir.get_contained_file('.project_tags.config.vim')
			let s:php_file= s:proj_dir.get_contained_file('supported_file.php')
			let s:phptags_file= s:proj_dir.get_contained_file('phptags')
endfunction

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()

	Assert! s:static_data_dir.exists()
		Assert! s:static_php_file.readable()
		Assert! s:static_include_project_file.readable()

	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
		Assert! !s:include_dir.exists()
		call s:include_dir.create()
		Assert! s:include_dir.exists()
			Assert! !s:another_php_file.readable()
			call s:static_another_php_file.copy_to(s:another_php_file.path)
			Assert! s:another_php_file.readable()
		Assert! !s:proj_dir.exists()
		call s:proj_dir.create()
		Assert! s:proj_dir.exists()
			Assert! !s:project_file.readable()
			call s:static_include_project_file.copy_to(s:project_file.path)
			Assert! s:project_file.readable()
			Assert! !s:php_file.readable()
			call s:static_php_file.copy_to(s:php_file.path)
			Assert! s:php_file.readable()
			Assert! !s:phptags_file.readable()

	call s:php_file.edit()
	call l#log('test before save')
	w
	call l#log('after save')
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

function! s:Test_accepted_project_file_include_setting()
	call l#log('test: before check include setting')
	AssertEquals(1, len(g:project_tags_include))
	AssertEquals('../include dir', g:project_tags_include[0])
endfunction

function! s:Test_created_tags_file()
	Assert s:phptags_file.readable()
	Assert s:phptags_file.writable()
endfunction

function! s:Test_3_files_in_proj_dir()
	let files= s:proj_dir.get_all_files()
	AssertEquals(3, len(files))
endfunction

function! s:Test_tags_file_does_contain_tags_from_included_dir()
	call s:phptags_file.edit()
	normal! gg
	let line_num= search('supported_file')
	AssertEquals(1, line_num)
endfunction
