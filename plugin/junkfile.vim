scriptencoding utf-8

if exists('g:junkfile#loaded')
  finish
endif
let g:junkfile#loaded = 1

function! s:get_workspace_path() abort
  let path = get(g:, 'junkfile#workspace_path', strftime('~/junk/%Y/%m%d'))
  return expand(path)
endfunction

function! s:make_and_edit_tmp(ext) abort
  let workdir = s:get_workspace_path()
  if empty(workdir)
    echoerr 'Workspace path is not configured. Set junkfile#workspace_path'
    return
  endif

  let filename = expand(
    \   printf(
    \     "%s/junk_%s.%s",
    \     workdir,
    \     strftime('%H%M%S'),
    \     a:ext
    \   )
    \ )
  let edit_command = expand('%') ==# '' && &filetype ==# ''
    \ ? 'edit' : 'tabnew'
  execute printf('%s %s', edit_command, filename)
endfunction

command! -nargs=1 -complete=filetype
  \ Junkfile call s:make_and_edit_tmp(<f-args>)
