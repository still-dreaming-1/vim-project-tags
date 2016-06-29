UTSuite get_immediate_project_file

function! s:Setup()
	let s:stopwatch= Stopwatch()
	call s:stopwatch.start()
endfunction

function! s:Teardown()
	let elapsed_milliseconds= s:stopwatch.stop()
	Assert elapsed_milliseconds < 1000
endfunction

function! s:get_not_readable_stub(name)
	let stub= {}
	let stub.path= 'non readable file'
	function! stub.readable()
		return 0
	endfunction
	return stub
endfunction

function! s:get_readable_stub(name)
	let stub= {}
	let stub.path= 'readable file'
	function! stub.readable()
		return 1
	endfunction
	return stub
endfunction

function! s:Test_when_param_has_project_file()
	let dir= {}
	let dir.get_contained_file= function("s:get_readable_stub")

	let project_file= project_tags#get_immediate_project_file(dir)
	AssertEquals('readable file', project_file.path)
endfunction

function! s:Test_when_there_not_has_project_file()
	let dir= {}
	let dir.get_contained_file= function("s:get_not_readable_stub")
	function! dir.parent()
		return L_null()
	endfunction

	let project_file= project_tags#get_immediate_project_file(dir)
	AssertEquals(L_null(), project_file)
endfunction
