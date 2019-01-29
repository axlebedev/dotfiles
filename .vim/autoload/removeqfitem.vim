" When using in the quickfix list, remove the item from the quickfix list.
function! removeqfitem#RemoveQFItem() abort
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
endfunction
