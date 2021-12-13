$data = Get-Content ".\13input.txt"

## Part 1
$linebreak = $data.IndexOf("")
$folds = $data[($linebreak + 1)..($data.Count - 1)]
$crd = @{ x = @() ; y = @() }
$data[0..($linebreak - 1)] | ForEach-Object {
    [int]$x, [int]$y = $_ -split ","
    $Crd["x"] += $x
    $Crd["y"] += $y
}

foreach ($fold in $folds) { #part 2
# foreach ($fold in $folds[0]) { #part 1
    [string]$dir, [int]$line = $fold.Split("=")
    $dir = $dir[-1]
    foreach ($i in (0..($linebreak - 1))) {
        $p = $crd[$dir][$i]
        if ($p -gt $line) {
            $crd[$dir][$i] = $p - (($p - $line) * 2)
        }
    } 
}

$Paper = @()
(0..(($crd["y"] | Sort-Object)[-1])) | ForEach-Object {
    $Paper += , (@(".") * (($crd["x"] | Sort-Object)[-1]+1))
}
foreach ($i in (0..($linebreak - 1))) {
    $Paper[$crd["y"][$i]][$crd["x"][$i]] = "#"
}
($Paper | select-string "#" -AllMatches).Matches.Count #part 1
$Paper | ForEach-Object { $_ -join "" } | select-string "#"-AllMatches #show paper, and read letters (part 2) (select-string just for readability)
