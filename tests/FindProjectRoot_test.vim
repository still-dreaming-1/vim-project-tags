UTSuite FindProjectRoot

function! s:get_non_existent_dir_stub(name)
	return { 'exists' : 0}
endfunction

function! s:get_existing_dir_stub(name)
	return { 'exists' : 1}
endfunction

function! s:Test_when_param_is_proj_root()
	let dir= {}
	let dir.get_contained_dir= function("s:get_existing_dir_stub")

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(root, dir)
endfunction

function! s:Test_when_there_is_no_proj_root()
	let dir= {}
	let dir.get_contained_dir= function("s:get_non_existent_dir_stub")
	function! dir.parent()
		return Null()
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(Null(), root)
endfunction

function! s:Test_when_parent_is_proj_root()
	let dir= {}
	let dir.get_contained_dir= function('s:get_non_existent_dir_stub')
	function! dir.parent()
		let parent= { 'get_contained_dir' : function('s:get_existing_dir_stub') }
		return parent
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(dir.parent(), root)
endfunction
