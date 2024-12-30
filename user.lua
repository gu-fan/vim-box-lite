require('lint').linters.gdlint = {
    -- gdscript = {'gdlint'}, 
     cmd = 'gdlint',
     append_fname = true,
     ignore_exitcode=true,
}
require('lint').linters_by_ft = {
  gdscript = {'gdlint'},
}
