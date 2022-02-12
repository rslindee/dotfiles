setlocal formatprg=yapf
setlocal makeprg=flake8\ %:S
setlocal errorformat=%f:%l:%c:\ %t%n\ %m
