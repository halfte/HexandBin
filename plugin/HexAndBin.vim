" description: 
" any number to binary, octal and hex
" <leader>h: hex to binary and octal
" <leader>s: binary to hex

function! DecimalToBinary(n, length)
    let n = a:n
    if n == 0
        return repeat('0', a:length)
    endif
    let binary = ''
    while n > 0
        let binary = (n % 2) . binary
        let n = n / 2
    endwhile
    return repeat('0', a:length - len(binary)) . binary
endfunction

function! HexToBinary(hex)
    let hex = substitute(a:hex, '^0[xX]', '', '')  " 去除前缀
    if hex !~? '^[0-9a-f]\+$'
        return 'Error: Invalid hex: ' . a:hex
    endif
    let binary = ''
    for c in split(hex, '\zs')
        let dec = str2nr(c, 16)  " 字符转十进制
        let bin = ''
        let n = dec
        " 强制生成4位二进制（即使高位为0）
        for _ in range(4)
            let bin = (n % 2) . bin
            let n = n / 2
        endfor
        let binary .= bin
    endfor
    return binary
endfunction

function! BinToHex(bin)
    let bin = substitute(a:bin, '\s', '', 'g')

    if bin !~ '^[01]\+$'
        echoerr "Error: " . bin
        return ""
    endif

    let len = len(bin)
    let padding = (4 - (len % 4)) % 4
    let bin = repeat('0', padding) . bin

    let hex_map = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']

    let hex = ''
    let i = 0
    while i < len(bin)
        let nibble = strpart(bin, i, 4)

        let val = 0
        for j in range(4)
            let char = strpart(nibble, j, 1)
            let val = val * 2 + (char == '1' ? 1 : 0)
        endfor

        let hex .= hex_map[val]
        let i += 4
    endwhile
    return hex

endfunction

function! HexOctBin(num) abort
    let n = a:num
    let reg16 = '\v^(\\x|0x|\\?u|\#)'
"    if n =~? '\v^\d+$'
"        let dec = printf('%d', n)
"       let hex = BinToHex(n)
"       let bin = HexToBinary(n)
""   else
""       if n =~? reg16
""           let n = '0x'.substitute(n,reg16,'','g')
""       else
""           let n = '0x' . n
""       endif
        let hex = BinToHex(n)
        let dec = printf('%d', n)
        let bin = HexToBinary(n)
""     endif

    let @" = '<' . dec . '> ' . '0x' . '<' . hex . '> ' . '<' . bin . '>'
    echo @"
endfunction

vnoremap <silent> ga y:call HexOctBin(@0)<CR>
vnoremap <silent> gs y:call BinToHex(@0)<CR>
