UTSuite FindProjectRoot

function! s:get_not_readable_stub(name)
	let stub= {}
	function! stub.readable()
		return 0
	endfunction
	return stub
endfunction

function! s:get_readable_stub(name)
	let stub= {}
	function! stub.readable()
		return 1
	endfunction
	return stub
endfunction

function! s:Test_when_param_is_proj_root()
	let dir= {}
	let dir.get_contained_file= function("s:get_readable_stub")

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(root, dir)
endfunction

function! s:Test_when_there_is_no_proj_root()
	let dir= {}
	let dir.get_contained_file= function("s:get_not_readable_stub")
	function! dir.parent()
		return Null()
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(Null(), root)
endfunction

function! s:Test_when_parent_is_proj_root()
	let dir= {}
	let dir.get_contained_file= function('s:get_not_readable_stub')
	function! dir.parent()
		let parent= { 'get_contained_file' : function('s:get_readable_stub') }
		return parent
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(dir.parent(), root)
endfunction

function! s:Test_when_grandparent_is_proj_root()
	let dir= {}
	let dir.get_contained_file= function('s:get_not_readable_stub')
	function! dir.parent()
		let parent= { 'get_contained_file' : function('s:get_not_readable_stub') }
		function! parent.parent()
			let grandparent= { 'get_contained_file' : function('s:get_readable_stub') }
			return grandparent
		endfunction
		return parent
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(dir.parent().parent(), root)
endfunction
