""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunCucumberTest(filename)
  if exists("g:vim_test_recall_cucumber_command")
    let command = substitute(g:vim_test_recall_cucumber_command, "{feature}", a:filename, "")
    exec ":" . command
  elseif filereadable("bin/cucumber")
    exec ":!bin/cucumber " . a:filename
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
  elseif filereadable("Gemfile")
    exec ":!bundle exec rspec --color " . a:filename
  else
    exec ":!rspec --color " . a:filename
  end
endfunction

function! RunCrystalTest(filename)
  if exists("g:vim_test_recall_rspec_command")
    let command = substitute(g:vim_test_recall_crystal_command, "{spec}", a:filename, "")
    exec ":" . command
  else
    exec ":!crystal spec " . a:filename
  end
endfunction

function! RunJavascriptTest(filename)
  if exists("g:vim_test_recall_javascript_command")
    let command = substitute(g:vim_test_recall_javascript_command, "{spec}", a:filename, "")
    exec ":" . command
 elseif
    exec ":!jasmine " . a:filename
  end
endfunction

function! RunPythonTest(filename)
  if exists("g:vim_test_recall_python_command")
    let command = substitute(g:vim_test_recall_python_command, "{spec}", a:filename, "")
    exec ":" . command
 elseif
    exec ":!pytest " . a:filename
  end
endfunction

function! RunTests(filename)
  :w
  if match(a:filename, '\.feature') != -1
    call RunCucumberTest(a:filename)
 elseif match(a:filename, '\.cr') != -1
     call RunCrystalTest(a:filename)
 elseif match(a:filename, '\.js') != -1
    call RunJavascriptTest(a:filename)
 elseif match(a:filename, '\.py') != -1
    call RunPythonTest(a:filename)
 elseif match(a:filename, '\.clj') != -1
    exec ":RunTests"
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
  call StoreCurrentFileAsTestFile()
  call StoreCurrentLineNumAsTestLineNum()
  call RunTests(t:grb_test_file . ":" . t:grb_test_line)
endfunction

function! RunTestsInCurrentFile()
  call RunTests(expand("%"))
endfunction

function! RunAllTestsInCurrentTestFile()
  call StoreCurrentFileAsTestFile()
  call RemoveTestLineNum()
  call RunTests(t:grb_test_file)
endfunction

function! RunAllRSpecTests()
  if filereadable("spec/spec_helper.cr")
    call RunCrystalTest('spec/')
  else
    call RunRSpecTest('spec/')
  endif
endfunction

function! RunAllCucumberFeatures()
  call RunCucumberTest("")
endfunction

function! RunWipCucumberFeatures()
  call RunCucumberTest("--profile wip")
endfunction
