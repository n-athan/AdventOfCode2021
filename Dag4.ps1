$data = Get-Content ".\4input.txt"

## Part 1
# long version
$numbers = $data[0].Split(",")
$boards = @()
for ($i = 2; $i -lt $data.Count; $i += 6 ) {
    $boards += , $data[$i..($i + 5)]
}
foreach ($number in $numbers) {
    if ($number.Length -lt 2) {
        $boards = $boards -replace " $number(\b)" , "xx$1"
    } else {
        $boards = $boards -replace $number , "xx"
    }    
    foreach ($board in $boards) {
        if ($board -match "^([\dx\s]{15}){0,4}(xx ){5}([\dx\s]{15}){0,3}([\dx\s]{14})?$") {
            #volle kolom
            Write-Output "board: $board", "last number: $number"
            return
        }
        elseif ($board -match "(xx [\d\sx]{12}){4}xx") {
            #volle rij
            Write-Output "board: $board", "last number: $number"
            return
        }
    }
}
$boardSum = ($board -replace "[\sxx]+", " ").split() | measure -AllStats | % sum     
[int] $number * $boardSum

## Part 2
#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#long version
$numbers = $data[0].Split(",")
$boards = @()
for ($i = 2; $i -lt $data.Count; $i += 6 ) {
    $boards += , $data[$i..($i + 5)]
}

foreach ($number in $numbers) {
    if ($number.Length -lt 2) {
        $boards = $boards -replace " $number(\b)" , "xx$1"
    } else {
        $boards = $boards -replace $number , "xx"
    }    
    $removeboards = @()
    foreach ($board in $boards) {
        if ($board -match "^([\dx\s]{15}){0,4}(xx ){5}([\dx\s]{15}){0,3}([\dx\s]{14})?$" -or $board -match "(xx [\d\sx]{12}){4}xx") {
            #volle kolom
            Write-Output "board: $board", "last number: $number"
            $removeboards += $board
        }
    }
    $boards = $boards | Where-Object {$_ -notin $removeboards}
    if ($boards.count -eq 0) {
        return
    }
}
$boardSum = ($board -replace "[\sxx]+", " ").split() | measure -AllStats | % sum     
[int] $number * $boardSum

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue
