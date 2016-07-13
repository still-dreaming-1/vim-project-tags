UTSuite when working with a C project, and a project file exists and saving a .h file

function! s:setup_script_vars()
	let s:static_c_proj_dir= L_dir(g:project_tags_dir_path.'/static test data').get_contained_dir('Collections-C')
	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
		let s:c_proj_dir= s:data_dir.get_contained_dir('Collections-C')
			let s:h_file= s:c_proj_dir.get_contained_file('src/hashset.h')
			let s:project_file= s:c_proj_dir.get_contained_file('.project_tags.config.vim')
			let s:ctags_file= s:c_proj_dir.get_contained_file('ctags')
endfunction

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call s:setup_script_vars()
	Assert! s:static_c_proj_dir.exists()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
		Assert! !s:c_proj_dir.exists()
			Assert! !s:h_file.readable()
		call s:static_c_proj_dir.copy_to(s:c_proj_dir)
			Assert! s:h_file.readable()
			Assert! s:h_file.writable()
			Assert! !s:project_file.readable()
			call s:project_file.create()
			Assert! s:project_file.readable()
			Assert! s:project_file.writable()
			call s:h_file.edit()
			Assert! !s:ctags_file.readable()
			Assert! !s:ctags_file.writable()
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
	Assert elapsed_milliseconds < 2000
endfunction

function! s:Test_created_tags_file()
	Assert s:ctags_file.readable()
endfunction

function! s:Test_tags_file_not_empty()
	Assert s:ctags_file.size() > 0
endfunction

function! s:Test_tags_file_does_contain_tag_from_edited_h_file()
	call s:ctags_file.edit()
	normal! gg
	let starts_with= 0
	let starting_line_num= -1
	let line_num= -2
	while !starts_with && starting_line_num != line_num
		let line_num= search('hashset_conf_init')
		if line_num <= 0
			break
		endif
		if starting_line_num == -1
			let starting_line_num= line_num
		endif
		let line= getline(line_num)
		let line_s= L_s(line)
		let starts_with= line_s.starts_with('hashset_conf_init')
		call cursor([line_num, 1])
		normal! j
		let current_line_num= line('.')
		if current_line_num != line_num
			break
		endif
	endwhile
	
	Assert line_num > 0
	Assert starts_with
endfunction

function! s:Test_tags_file_does_contain_tag_from_different_h_file()
	call s:ctags_file.edit()
	normal! gg
	let line_num= search('list_iter_s')
	Assert line_num > 0
endfunction

function! s:Test_tags_file_does_contain_tag_from_c_file()
	call s:ctags_file.edit()
	normal! gg
	let line_num= search('expand_capacity')
	Assert line_num > 0
endfunction
