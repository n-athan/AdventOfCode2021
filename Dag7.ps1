$data = Get-Content ".\7input.txt"

## Part 1
$data = $data.split(",") | ForEach-Object {[int] $_}| Sort-Object
$median = $data[($data.Count)/2]
$data | ForEach-Object {$fuel = 0}{$fuel += [Math]::Abs($_-$median)}{$fuel}

## Part 2
function cost([int]$start,[int]$line) {
    $dist = [Math]::Abs($start-$line)
    ($dist*(1+$dist))/2
}
$stats = $data | measure -AllStats
$avg = [Math]::Floor($stats.Average)
$data | ForEach-Object {$fuel = 0}{$fuel += cost -start $_ -line $avg}{$fuel} 