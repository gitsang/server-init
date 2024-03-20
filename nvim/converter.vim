" snake_case -> camelCase
:command -range SnakeCaseToCamelCase <line1>,<line2> call SnakeCaseToCamelCase()
function SnakeCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /_\(\w\)/\u\1/g'
endfunction

" snake_case -> PascalCase
:command -range SnakeCaseToPascalCase <line1>,<line2> call SnakeCaseToPascalCase()
function SnakeCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /\v_(\w)/\u\1/g'
endfunction

" snake_case -> UPPER_SNAKE_CASE
:command -range SnakeCaseToUpperCase <line1>,<line2> call SnakeCaseToUpperCase()
function SnakeCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /_/\U&/g'
endfunction

" snake_case -> kebab-case
:command -range SnakeCaseToKebabCase <line1>,<line2> call SnakeCaseToKebabCase()
function SnakeCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /_/-/g'
endfunction

" snake_case -> Train-Case
:command -range SnakeCaseToTrainCase <line1>,<line2> call SnakeCaseToTrainCase()
function SnakeCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /_/\=submatch(0) == "_" ? "-" : toupper(submatch(0))/g'
endfunction

" snake_case -> dot.case
:command -range SnakeCaseToDotCase <line1>,<line2> call SnakeCaseToDotCase()
function SnakeCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /_/\./g'
endfunction

" camelCase -> snake_case
:command -range CamelCaseToSnakeCase <line1>,<line2> call CamelCaseToSnakeCase()
function CamelCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1_\l\2/g'
endfunction

" camelCase -> PascalCase
:command -range CamelCaseToPascalCase <line1>,<line2> call CamelCaseToPascalCase()
function CamelCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /^./\u&/'
endfunction

" camelCase -> UPPER_SNAKE_CASE
:command -range CamelCaseToUpperCase <line1>,<line2> call CamelCaseToUpperCase()
function CamelCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1_\U\2/g'
endfunction

" camelCase -> kebab-case
:command -range CamelCaseToKebabCase <line1>,<line2> call CamelCaseToKebabCase()
function CamelCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1-\l\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" camelCase -> Train-Case
:command -range CamelCaseToTrainCase <line1>,<line2> call CamelCaseToTrainCase()
function CamelCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1-\U\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\u&/'
endfunction

" camelCase -> dot.case
:command -range CamelCaseToDotCase <line1>,<line2> call CamelCaseToDotCase()
function CamelCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1.\l\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" PascalCase -> snake_case
:command -range PascalCaseToSnakeCase <line1>,<line2> call PascalCaseToSnakeCase()
function PascalCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1_\l\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" PascalCase -> camelCase
:command -range PascalCaseToCamelCase <line1>,<line2> call PascalCaseToCamelCase()
function PascalCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" PascalCase -> UPPER_SNAKE_CASE
:command -range PascalCaseToUpperCase <line1>,<line2> call PascalCaseToUpperCase()
function PascalCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1_\U\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" PascalCase -> kebab-case
:command -range PascalCaseToKebabCase <line1>,<line2> call PascalCaseToKebabCase()
function PascalCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1-\l\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" PascalCase -> Train-Case
:command -range PascalCaseToTrainCase <line1>,<line2> call PascalCaseToTrainCase()
function PascalCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1-\U\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\u&/'
endfunction

" PascalCase -> dot.case
:command -range PascalCaseToDotCase <line1>,<line2> call PascalCaseToDotCase()
function PascalCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /\v([a-z0-9])([A-Z])/\1.\l\2/g'
    execute a:firstline ',' a:lastline 'substitute /^./\l&/'
endfunction

" UPPER_SNAKE_CASE -> snake_case
:command -range UpperSnakeCaseToSnakeCase <line1>,<line2> call UpperSnakeCaseToSnakeCase()
function UpperSnakeCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /\v_(\w)/\l\1/g'
endfunction

" UPPER_SNAKE_CASE -> camelCase
:command -range UpperSnakeCaseToCamelCase <line1>,<line2> call UpperSnakeCaseToCamelCase()
function UpperSnakeCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /\v_(\w)/\u\1/g'
endfunction

" UPPER_SNAKE_CASE -> PascalCase
:command -range UpperSnakeCaseToPascalCase <line1>,<line2> call UpperSnakeCaseToPascalCase()
function UpperSnakeCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /^./\u&/'
endfunction

" UPPER_SNAKE_CASE -> kebab-case
:command -range UpperSnakeCaseToKebabCase <line1>,<line2> call UpperSnakeCaseToKebabCase()
function UpperSnakeCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /_/-/g'
endfunction

" UPPER_SNAKE_CASE -> Train-Case
:command -range UpperSnakeCaseToTrainCase <line1>,<line2> call UpperSnakeCaseToTrainCase()
function UpperSnakeCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /_/\=submatch(0) == "_" ? "-" : toupper(submatch(0))/g'
endfunction

" UPPER_SNAKE_CASE -> dot.case
:command -range UpperSnakeCaseToDotCase <line1>,<line2> call UpperSnakeCaseToDotCase()
function UpperSnakeCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /_/\./g'
endfunction

" kebab-case -> snake_case
:command -range KebabCaseToSnakeCase <line1>,<line2> call KebabCaseToSnakeCase()
function KebabCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /-/_/g'
endfunction

" kebab-case -> camelCase
:command -range KebabCaseToCamelCase <line1>,<line2> call KebabCaseToCamelCase()
function KebabCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /\v(-\w)/\u\1/g'
endfunction

" kebab-case -> PascalCase
:command -range KebabCaseToPascalCase <line1>,<line2> call KebabCaseToPascalCase()
function KebabCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /\v(-\w)/\u\1/g'
endfunction

" kebab-case -> UPPER_SNAKE_CASE
:command -range KebabCaseToUpperCase <line1>,<line2> call KebabCaseToUpperCase()
function KebabCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /-/\U&/g'
endfunction

" kebab-case -> Train-Case
:command -range KebabCaseToTrainCase <line1>,<line2> call KebabCaseToTrainCase()
function KebabCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /-/\=submatch(0) == "-" ? "-" : toupper(submatch(0))/g'
endfunction

" kebab-case -> dot.case
:command -range KebabCaseToDotCase <line1>,<line2> call KebabCaseToDotCase()
function KebabCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /-/\./g'
endfunction

" Train-Case -> snake_case
:command -range TrainCaseToSnakeCase <line1>,<line2> call TrainCaseToSnakeCase()
function TrainCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /\v(-|\w)/\L\1/g'
endfunction

" Train-Case -> camelCase
:command -range TrainCaseToCamelCase <line1>,<line2> call TrainCaseToCamelCase()
function TrainCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /\v(-|\w)/\u\1/g'
endfunction

" Train-Case -> PascalCase
:command -range TrainCaseToPascalCase <line1>,<line2> call TrainCaseToPascalCase()
function TrainCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /\v(-|\w)/\u\1/g'
endfunction

" Train-Case -> UPPER_SNAKE_CASE
:command -range TrainCaseToUpperCase <line1>,<line2> call TrainCaseToUpperCase()
function TrainCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /-/\U&/g'
endfunction

" Train-Case -> kebab-case
:command -range TrainCaseToKebabCase <line1>,<line2> call TrainCaseToKebabCase()
function TrainCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /-/"/g'
endfunction

" Train-Case -> dot.case
:command -range TrainCaseToDotCase <line1>,<line2> call TrainCaseToDotCase()
function TrainCaseToDotCase() range
    execute a:firstline ',' a:lastline 'substitute /-/./g'
endfunction

" dot.case -> snake_case
:command -range DotCaseToSnakeCase <line1>,<line2> call DotCaseToSnakeCase()
function DotCaseToSnakeCase() range
    execute a:firstline ',' a:lastline 'substitute /\./_/g'
endfunction

" dot.case -> camelCase
:command -range DotCaseToCamelCase <line1>,<line2> call DotCaseToCamelCase()
function DotCaseToCamelCase() range
    execute a:firstline ',' a:lastline 'substitute /\./\u/g'
endfunction

" dot.case -> PascalCase
:command -range DotCaseToPascalCase <line1>,<line2> call DotCaseToPascalCase()
function DotCaseToPascalCase() range
    execute a:firstline ',' a:lastline 'substitute /\./\u/g'
endfunction

" dot.case -> UPPER_SNAKE_CASE
:command -range DotCaseToUpperCase <line1>,<line2> call DotCaseToUpperCase()
function DotCaseToUpperCase() range
    execute a:firstline ',' a:lastline 'substitute /\./\U&/g'
endfunction

" dot.case -> kebab-case
:command -range DotCaseToKebabCase <line1>,<line2> call DotCaseToKebabCase()
function DotCaseToKebabCase() range
    execute a:firstline ',' a:lastline 'substitute /\./-/g'
endfunction

" dot.case -> Train-Case
:command -range DotCaseToTrainCase <line1>,<line2> call DotCaseToTrainCase()
function DotCaseToTrainCase() range
    execute a:firstline ',' a:lastline 'substitute /\./-/g'
endfunction
