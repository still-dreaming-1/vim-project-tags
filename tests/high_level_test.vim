UTSuite project_tags

function! s:Test_supports_more_than_1_file_extension()
	Assert g:project_tags_extension_ls.len() > 1
endfunction
