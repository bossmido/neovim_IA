syntax match LogTimestamp /^\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}/
highlight link LogTimestamp Comment


syntax match LogError /ERROR\|Error\|error/
highlight link LogError Error

syntax match LogWarning /WARN\|Warning\|warning/
highlight link LogWarning Warning

syntax match LogInfo /INFO\|Info\|info/
highlight link LogInfo Identifier
