UTSuite when no project file exists and saving txt file

function! s:setup_script_vars()
	let s:data_dir= Dir(g:project_tags_dir_path.'/tests/data')
	let s:txt_file= s:data_dir.get_contained_file('text fl.txt')
endfunction

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert !s:data_dir.exists()
	call s:data_dir.create()
	Assert s:data_dir.exists()
	Assert !s:txt_file.readable()
	call s:txt_file.create()
	Assert s:txt_file.readable()
	Assert s:txt_file.writable()
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

function! s:Test_only_file_is_original_txt_file()
	let files= s:data_dir.get_all_files()
	AssertEquals(1, len(files))
	AssertEquals(s:txt_file.path, files[0].path)
endfunction
