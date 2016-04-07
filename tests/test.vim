UTSuite project_tags

function! s:Test_supports_more_than_1_file_extension()
	Assert len(g:project_tags_extension_l) > 1
endfunction
