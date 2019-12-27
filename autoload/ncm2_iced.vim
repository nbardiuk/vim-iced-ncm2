if exists('g:loaded_ncm2_iced')
  finish
endif
let g:loaded_ncm2_iced = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

function! ncm2_iced#complete(ctx) abort
    if !iced#nrepl#is_connected()
        return
    endif

    if !iced#nrepl#check_session_validity(v:false)
        return
    endif

    let keyword = a:ctx['base']
    let starts_at = a:ctx['startccol']
    call iced#complete#candidates(keyword, {candidates -> ncm2#complete(a:ctx, starts_at, candidates)})
endfunction

function! ncm2_iced#init() abort
    let iced_source = {}
    let iced_source.name = 'vim-iced'
    let iced_source.mark = 'iced'
    let iced_source.priority = 9
    let iced_source.scope = ['clojure']
    let iced_source.complete_length = 2
    let iced_source.complete_pattern = ['/']
    let iced_source.word_pattern = '[\w!$&*\-=+:<>./?]+'
    let iced_source.on_complete = 'ncm2_iced#complete'

    call ncm2#register_source(iced_source)
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
