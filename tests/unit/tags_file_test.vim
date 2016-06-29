UTSuite tags_file

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
endfunction

function! s:Teardown()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:Test_path()
	let dir= L_dir('/dkjfkdjfkdj')
	let tags_file= project_tags_tags_file#new(dir, 'php')
	Assert L_s(tags_file.path).starts_with(dir.path)
endfunction
