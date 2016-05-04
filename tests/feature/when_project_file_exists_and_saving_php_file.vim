UTSuite when project file exists and saving php file

function! s:setup_script_vars()
	let s:data_dir= Dir(g:project_tags_dir_path.'/tests/data')
	let s:static_php_file= Dir(g:project_tags_dir_path.'/tests/static data').get_contained_file('supported_file.php')
	let s:php_file= s:data_dir.get_contained_file('supported_file.php')
	let s:project_file= s:data_dir.get_contained_file('.project_tags.config.vim')
	let s:phptags_file= s:data_dir.get_contained_file('phptags')
endfunction

function! s:Setup()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert !s:data_dir.exists()
	call s:data_dir.create()
	Assert s:data_dir.exists()
	Assert s:static_php_file.readable()
	Assert !s:php_file.readable()
	call s:static_php_file.copy_to(s:php_file.path)
	Assert s:php_file.readable()
	Assert s:php_file.writable()
	Assert !s:project_file.readable()
	call s:project_file.create()
	Assert s:project_file.readable()
	Assert s:project_file.writable()
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
endfunction

function! s:Test_created_tags_file()
	Assert 1
	Assert s:phptags_file.readable()
endfunction

function! s:Test_only_files_are_copied_php_file_and_project_file_and_tags_file()
	let files= s:data_dir.get_all_files()
	AssertEquals(3, len(files))
	Assert s:php_file.path ==# files[0].path || s:php_file.path ==# files[1].path || s:php_file.path ==# files[2].path
	Assert s:project_file.path ==# files[0].path || s:project_file.path ==# files[1].path || s:project_file.path ==# files[2].path
	Assert s:phptags_file.path ==# files[0].path || s:phptags_file.path ==# files[1].path || s:phptags_file.path ==# files[2].path
endfunction
