""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunCucumberTest(filename)
  if exists("g:vim_test_recall_cucumber_command")
    let command = substitute(g:vim_test_recall_cucumber_command, "{feature}", a:filename, "")
    exec ":" . command
  elseif filereadable("bin/cucumber")
    exec ":!bin/cucumber " . a:filename
  elseif filereadable("zeus.json")
    exec ":!zeus cucumber " . a:filename
  elseif filereadable("script/features")
    exec ":!script/features " . a:filename
  else
    exec ":!bundle exec cucumber " . a:filename
  end
endfunction

function! RunRSpecTest(filename)
  if exists("g:vim_test_recall_rspec_command")
    let command = substitute(g:vim_test_recall_rspec_command, "{spec}", a:filename, "")
    exec ":" . command
  elseif filereadable("bin/rspec")
    exec ":!bin/rspec --color " . a:filename
  elseif filereadable("zeus.json")
    exec ":!zeus test --color " . a:filename
  elseif filereadable("script/test")
    exec ":!script/test " . a:filename
  elseif filereadable("Gemfile")
    exec ":!bundle exec rspec --color " . a:filename
  else
    exec ":!rspec --color " . a:filename
  end
endfunction

function! RunJasmineTest(filename)
  if exists("g:vim_test_recall_snapdragon_command")
    exec ":!" . g:vim_test_recall_snapdragon_command . " " . a:filename
  elseif filereadable("Gemfile")
    exec ":!bundle exec snapdragon " . a:filename
  elseif
    exec ":!snapdragon " . a:filename
  end
endfunction

function! RunTests(filename)
  :w
  if match(a:filename, '\.feature') != -1
    call RunCucumberTest(a:filename)
  elseif match(a:filename, '\spec.js\|Spec.js') != -1
    call RunJasmineTest(a:filename)
  else
    call RunRSpecTest(a:filename)
  end
endfunction

function! StoreCurrentFileAsTestFile()
  let t:grb_test_file=@%
endfunction

function! StoreCurrentLineNumAsTestLineNum()
  let t:grb_test_line=line('.')
endfunction

function! RemoveTestLineNum()
  if exists("t:grb_test_line")
    unlet t:grb_test_line
  end
endfunction

function! RunNearestTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|spec.js\|Spec.js\)$') != -1
  if in_test_file
    call StoreCurrentFileAsTestFile()
    call StoreCurrentLineNumAsTestLineNum()
  elseif !exists("t:grb_test_file") || !exists("t:grb_test_line")
    return
  end
  call RunTests(t:grb_test_file . ":" . t:grb_test_line)
endfunction

function! RunTestsInCurrentFile()
  call RunTests(expand("%"))
endfunction

function! RunAllTestsInCurrentTestFile()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|spec.js\|Spec.js\)$') != -1
  if in_test_file
    call StoreCurrentFileAsTestFile()
    call RemoveTestLineNum()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file)
endfunction

function! RunAllRSpecTests()
  call RunTests('spec/')
endfunction

function! RunAllCucumberFeatures()
  call RunCucumberTest("")
endfunction

function! RunWipCucumberFeatures()
  call RunCucumberTest("--profile wip")
endfunction
