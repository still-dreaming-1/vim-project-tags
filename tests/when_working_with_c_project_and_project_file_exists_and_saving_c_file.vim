UTSuite when working with a C project, and a project file exists and saving a .c file

function! s:setup_script_vars()
	let s:static_c_proj_dir= L_dir(g:project_tags_dir_path.'/static test data').get_contained_dir('Collections-C')
	let s:data_dir= L_dir(g:project_tags_dir_path.'/generated test data')
		let s:c_proj_dir= s:data_dir.get_contained_dir('Collections-C')
			let s:c_file= s:c_proj_dir.get_contained_file('src/array.c')
			let s:project_file= s:c_proj_dir.get_contained_file('.project_tags.config.vim')
			let s:ctags_file= s:c_proj_dir.get_contained_file('ctags')
endfunction

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
	call s:safe_teardown()
	call project_tags#add_language('ctags', ['c', 'h'])
	call s:setup_script_vars()
	Assert! s:static_c_proj_dir.exists()
	Assert! !s:data_dir.exists()
	call s:data_dir.create()
	Assert! s:data_dir.exists()
		Assert! !s:c_proj_dir.exists()
			Assert! !s:c_file.readable()
		call s:static_c_proj_dir.copy_to(s:c_proj_dir)
			Assert! s:c_file.readable()
			Assert! s:c_file.writable()
			Assert! !s:project_file.readable()
			call s:project_file.create()
			Assert! s:project_file.readable()
			Assert! s:project_file.writable()
			call s:c_file.edit()
			Assert! !s:ctags_file.readable()
			Assert! !s:ctags_file.writable()
			w
endfunction

function! s:safe_teardown()
	call project_tags#remove_all_languages()
	call project_tags#add_built_in_language_support()
	call s:setup_script_vars()
	if s:data_dir.exists()
		call s:data_dir.delete()
	endif
endfunction

function! s:Teardown()
	call project_tags#remove_all_languages()
	call project_tags#add_built_in_language_support()
	call s:setup_script_vars()
	Assert s:data_dir.exists()
	call s:data_dir.delete()
	Assert !s:data_dir.exists()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 2000
endfunction

function! s:Test_created_tags_file()
	Assert! s:ctags_file.readable()
endfunction

" function! s:Test_tags_file_not_empty()
" 	Assert s:ctags_file.size() > 0
" endfunction

" function! s:Test_tags_file_does_contain_tag_from_edited_c_file()
" 	call s:ctags_file.edit()
" 	normal! gg
" 	let line_num= search('expand_capacity')
" 	Assert line_num > 0
" endfunction

" function! s:Test_tags_file_does_contain_tag_from_different_c_file()
" 	call s:ctags_file.edit()
" 	normal! gg
" 	let line_num= search('hashset_conf_init')
" 	Assert line_num > 0
" endfunction

" function! s:Test_tags_file_does_contain_tag_from_h_file()
" 	call s:ctags_file.edit()
" 	normal! gg
" 	let line_num= search('list_iter_s')
" 	Assert line_num > 0
" endfunction
