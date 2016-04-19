UTSuite find_project_root

function! s:Test_FindProjectRoot_when_param_is_proj_root()
	let dir= {}
	function! dir.get_contained_dir(name)
		return { 'exists' : 1}
	endfunction

	let root= project_tags#FindProjectRoot(dir)
	AssertEquals(root, dir)
endfunction