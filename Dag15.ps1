$data = Get-Content ".\15input.txt"
$data = @(
    "1163751742"
    "1381373672"
    "2136511328"
    "3694931569"
    "7463417111"
    "1319128137"
    "1359912421"
    "3125421639"
    "1293138521"
    "2311944581"
)

## Part 1
$risks = @(999)*(($data.Count*$data[0].Length)); $risks[0] = 0 
$weights = [int[]](($data -join "") -split "")[1..($risks.Count)]

$rowL = $data[0].Length
$colL = $data.Count
$maxi = $weights.Count -1

# voor elke i in data, is een niet-diagonale buur i-1, i+1, i-$rowL, i+$rowL, als dat in 0..max-i zit. 
function checkPath ($i, $x) {
    if (0 -le $x -and $x -le $global:maxi) {
        if ($global:risks[$i]+$global:weights[$x] -lt $global:risks[$x]) {
            $global:risks[$x] = $global:risks[$i]+$global:weights[$x]
        }
    } 
}

for ($i = 0; $i -lt $weights.Count; $i++) {
    checkPath -i $i -x ($i-1)
    checkPath -i $i -x ($i+1)
    checkPath -i $i -x ($i-$rowL)
    checkPath -i $i -x ($i+$rowL)
}

#resultaat bekijken
# (0..($colL)) | % {($risks[($_*10)..($_*10+$rowL)] | % {if ($_ -lt 10) {"0$_"} else {$_}}) -join " "}

## Part 2
<#
0 1 2 3 4
1 2 3 4 5
2 3 4 5 6
3 4 5 6 7
4 5 6 7 8
#>

$rowL = $data[0].Length
$colL = $data.Count

$dataDict = @{}
$dataDict[0] = $data
foreach ($x in (1..8)) {
    $dataDict[$x] = $dataDict[($x-1)] | % {([int[]]($_ -split "")[1..$rowL] | % {if ($_ -eq 9){1} else {$_ + 1}}) -join ""}
} 

$field = ""
for ($k = 0; $k -lt 5; $k++) {
    $start = $k 
    $end = $k + 4
    for ($j = 0; $j -lt $colL; $j++) {
        for ($i = $start; $i -le $end; $i++) {
            $field += $dataDict[$i][$j]
        }
    } 
}

$rowL = $data[0].Length*5
#field bekijken
# (0..($colL*5)) | % {(($field[($_*$rowL)..($_*$rowL+$rowL-1)]) -join "")} | Out-File ".\15output.txt"

$weights = ([int[]]($field -split "")[1..$field.Length])
$risks = @(9999)*$weights.Count; $risks[0] = 0 
$maxi = $weights.Count -1

function checkPath ($i, $x) { 
    if (0 -le $x -and $x -le $global:maxi) {
        if ($global:risks[$i]+$global:weights[$x] -lt $global:risks[$x]) {
            $global:risks[$x] = $global:risks[$i]+$global:weights[$x]
        }
    } 
}

while ($res -gt $risks[-1]) {
    $res = $risks[-1]
    $counter ++
    Write-Output "loop $counter, ltr $res"
    for ($i = 0; $i -lt $weights.Count; $i++) {
        Write-Progress -Activity "Getting Lowest Risk Paths" -Status "At number $i" -PercentComplete ($i/$maxi * 100)
        if ([Math]::Floor(($i-1)/$rowL) -eq [Math]::Floor($i/$rowL)) { #niet Snake oversteken
            checkPath -i $i -x ($i-1)
        }
        if ([Math]::Floor(($i+1)/$rowL) -eq [Math]::Floor($i/$rowL)) { #niet Snake oversteken
            checkPath -i $i -x ($i+1)
        }
        checkPath -i $i -x ($i-$rowL)
        checkPath -i $i -x ($i+$rowL)
    }
}

$risks[-1]