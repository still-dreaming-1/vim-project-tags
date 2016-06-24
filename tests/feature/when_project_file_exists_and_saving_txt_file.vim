UTSuite when project file exists and saving txt file

function! s:setup_script_vars()
	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
	let s:txt_file= s:data_dir.get_contained_file('text fl.txt')
	let s:project_file= s:data_dir.get_contained_file('.project_tags.config.vim')
endfunction

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
	Assert! !s:txt_file.readable()
	call s:txt_file.create()
	Assert! s:txt_file.readable()
	Assert! s:txt_file.writable()
	Assert! !s:project_file.readable()
	call s:project_file.create()
	Assert! s:project_file.readable()
	Assert! s:project_file.writable()
	call s:txt_file.edit()
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
	let txttags_file= s:data_dir.get_contained_file('txttags')
	Assert !txttags_file.readable()
endfunction

function! s:Test_only_files_are_original_txt_and_project_files()
	let files= s:data_dir.get_all_files()
	AssertEquals(2, len(files))
	Assert s:txt_file.path ==# files[0].path || s:txt_file.path ==# files[1].path
	Assert s:project_file.path ==# files[0].path || s:project_file.path ==# files[1].path
endfunction
