$data = Get-Content ".\9input.txt"

## Part 1
# long version

$map = @{}
foreach ($i in (0..($data.count - 1))) {
    $map[$i] = @{
        line   = $data[$i].ToCharArray() | ForEach-Object { [int] $_.ToString() }
        marked = @()
        low    = @()
    }

    $line = $map[$i].line
    foreach ($j in (0..($line.count - 1))) {
        if ($line[$j] -lt $line[$j + 1] -or $j -eq ($line.count - 1)) {
            if ($line[$j] -lt $line[$j - 1] -or $j -eq 0) {
                $map[$i].marked += $j
            }
        }
    }
}

$result = 0

foreach ($i in (0..($data.count - 1))) {
    foreach ($j in $map[$i].marked) {
        if ($i -eq ($data.count - 1) -or ($map[$i].line[$j] -lt $map[$i + 1].line[$j])) {
            if ($i -eq 0 -or ($map[$i].line[$j] -lt $map[$i - 1].line[$j])) {
                $map[$i].low += $j 
                $result += $map[$i].line[$j] + 1
            }
        }
    }
}

$result

## Part 2
$nines = @()
foreach ($i in (0..($data.count - 1))) {
    ($data[$i] | Select-String "9" -AllMatches).Matches.Index | ForEach-Object {
        $nines +=  "$i $_"
    }
}

$lows = @()
foreach ($key in $map.Keys) {
    $map[$key].low | ForEach-Object {
        $lows += "$key $_"
    }
}

function check ($toCheck, $group) {
    $nextOut = @()
    foreach ($cor in $tocheck) {
        if ($cor -notin $nines) {
            if ($cor -notin ($basins[$group].basin)) {
                $basins[$group].basin += $cor
                $basins[$group].size  += 1
            }
            [int]$x, [int]$y = $cor -split " "
            $nextOut += "$x $($y + 1)",  "$($x + 1) $y", "$($x - 1) $y", "$x $($y -1)"
        }
    }
    $nextOut | Where-Object {
        [int]$x, [int]$y = $_ -split " "; 
        $_ -notin ($basins[$group].basin) -and $_ -notin $nines -and ($x -ge 0 -and $x -lt $data[0].Length -and $y -ge 0 -and $y -lt $data.Count)
    }
}

$basins = @{}

foreach ($low in $lows) {
    $basins["$low"] = @{
        basin = @()
        size  = 0
    }

    $next = $low
    while ($next.count -gt 0) {
        $next = check -tocheck $next -group "$low" #;$next.count
    }
}

$largests = $basins.values.size | Sort-Object | Select-Object -last 3    
$largests[0]*$largests[1]*$largests[2]
