function! s:SetProtoALE()
    let g:ale_proto_protoc_gen_lint_options = '-I .'
    if match(expand('%:p'), '/yvs2/apis/proto/yvs2/v1/') != -1
        let g:ale_proto_protoc_gen_lint_options .= ' '
        let g:ale_proto_protoc_gen_lint_options .= '-I ../../third_party/ -I ../'
    endif
endfunction

autocmd BufRead,BufNewFile *.proto call s:SetProtoALE()
