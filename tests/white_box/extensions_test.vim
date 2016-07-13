UTSuite extensions

function! s:Setup()
	let s:stopwatch= L_stopwatch()
	call s:stopwatch.start()
endfunction

function! s:Teardown()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:Test_supports_more_than_1_file_extension()
	Assert len(g:project_tags_language_ls) > 1
endfunction
