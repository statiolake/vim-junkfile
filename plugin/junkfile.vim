scriptencoding utf-8

if exists('g:junkfile#loaded')
  finish
endif
let g:junkfile#loaded = 1

function! s:get_workspace_path() abort
  let path = get(g:, 'junkfile#workspace_path', '')
  let is_cmd = get(g:, 'junkfile#workspace_path_is_shell_command', 0)

  if is_cmd
    let workdir = system(path)
    let workdir = workdir[0:(strlen(workdir)-2)]
    return workdir
  else
    return path
  endif
endfunction

function! s:make_and_edit_tmp(ext) abort
  let workdir = s:get_workspace_path()
  if empty(workdir)
    echoerr 'Workspace path is not configured. Set junkfile#workspace_path'
    return
  endif

  let filename = expand(workdir .. '/junk_' .. strftime('%H%M%S') .. '.' .. a:ext)
  let edit_command = expand('%') ==# '' && &filetype ==# '' ? 'edit' : 'tabnew'
  execute ':' .. edit_command .. ' ' .. filename
endfunction

command! -nargs=1 -complete=filetype Junkfile call s:make_and_edit_tmp(<f-args>)
