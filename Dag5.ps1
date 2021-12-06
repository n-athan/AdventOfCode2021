$data = Get-Content ".\5input.txt"

## Part 1
$linedata = @()
$data | ForEach-Object { $linedata += , ($_ -split ",| -> ") }
$vert = $linedata | Where-Object {$_[0] -eq $_[2]}
$horz = $linedata | Where-Object {$_[1] -eq $_[3]}

$vents = New-Object int[][] 1000
foreach ($line in $vert) {
    ($line[1]..$line[3]) | ForEach-Object {
        $vents[$_] += $line[0]
    }
}
foreach ($line in $horz) {
    $vents[$line[1]] += ($line[0]..$line[2])
}

$t = foreach($row in $vents) {
    ($row | Group-Object | Where-Object {$_.count -gt 1})
}
$t.Count #answer part 1

## Part 2
$diag = $linedata | Where-Object {-not ($_[0] -eq $_[2] -or $_[1] -eq $_[3])}
foreach ($line in $diag) {
    if ($line[0] - $line[2] -gt 0) { $xInc = -1 } else { $xInc = 1 }
    if ($line[1] - $line[3] -gt 0) { $yInc = -1 } else { $yInc = 1 }
    $dur = [Math]::Abs($line[0] - $line[2])
    (0..$dur) | ForEach-Object {
        $y = [int] $line[1]+($_*$yInc)
        $x = [int] $line[0]+($_*$xInc)
        $vents[$y] += $x
    }
}

$t = foreach($row in $vents) {
    ($row | Group-Object | Where-Object {$_.count -gt 1})
}
$t.Count #answer part 2