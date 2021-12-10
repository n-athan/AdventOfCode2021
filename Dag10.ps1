$data = Get-Content ".\10input.txt"

## Part 1
# long version
$open = "[\(\[\{\<]"
$close = "[\)\]\}\>]"
$pair = "((\(\)|\[\])|(\{\}|\<\>))"

$corrupted = @()
$score = 0
foreach ($i in (0..($data.Count-1))) {
    $line = $data[$i]
    $l = $line.Length + 1

    while ($line.Length -lt $l){
        $l = $line.Length
        $line = $line -replace $pair, ""
    }

    if ($line -match $close) {
        # "Line $i is corrupted"; 
        $corrupted += $data[$i]
        switch -Regex ($line) {
            "^$open*\).*$" {$score += 3 }
            "^$open*\].*$" {$score += 57 }
            "^$open*\}.*$" {$score += 1197 }
            "^$open*>.*$"  {$score += 25137 }
        }
    }
}
$score

## Part 2
#long version
$incomplete = $data | Where-Object {$_ -notin $corrupted}
$scores = @()

foreach ($i in (0..($incomplete.Count-1))) {
    $line = $incomplete[$i]
    $l = $line.Length + 1

    while ($line.Length -lt $l){
        $l = $line.Length
        $line = $line -replace $pair, ""
    }

    $total = 0
    $line[-1..-$line.Length] | ForEach-Object {
        $total = $total * 5
        if ([int]$_ -ne 60) {$total += [int]([int]$_/40)} else {$total += 4}    
    }
    $scores += $total    
}
($scores | sort)[[Math]::Floor($scores.count/2)]

# om daadwerkelijk de sluitende haakjes te lezen, zet dit in de loop (boven $total = 0)
# (($line[-1..-$line.Length] | % {$c = [int]$_; if ($c -ne 40){[char]($c+2)}else{[char]($c+1)}})) -join ""