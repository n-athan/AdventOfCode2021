$data = Get-Content ".\17input.txt"

## Part 1
############# short version ###############
<# bij part 2 pas door, dat de hoogste y die de target kan raken Abs($target[3])-1 is. 
bij een maximaal gekozen x, kan y eerst 1+2+3..+y omhoog en daarna evenveel naar beneden (y wordt telkens 1 kleiner.)
Dan gaat de probe nog y+1 naar beneden (vanaf 0) en om target te raken, moet y 1 kleiner zijn dat de laagtste waarde van de target. #>

$Target = ($data -replace "[a-z\s:=]", "") -split "," | % { $_ -split "\.\." | Sort-Object {[Math]::Abs($_)}} #x1, x2, y1, y2
$y = [Math]::Abs([int]$target[3])-1
(($y+1)*$y)/2 #antwoord, maximale y hoogte


############### long version ###############
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue
$Target = ($data -replace "[a-z\s:=]", "") -split "," | % { $_ -split "\.\." | Sort-Object {[Math]::Abs($_)}} #x1, x2, y1, y2

function TestTarget ($x, $y) {
    if ($y -lt $Target[3]) {
        return "miss"
    } 
    if ($x -in ($Target[0]..$Target[1]) -and $y -in ($Target[2]..$Target[3])) {
        return "hit"
    }
    else {
        return "continue"
    }
}

$yspeed = 1000 #start een onrealistish hoge gok
$diff = $yspeed
$maxhit = 0

while ($maxhit -ne $maxprev) {
    $speed = @{
        x = [Math]::Floor((-1 + [Math]::Sqrt(1 + (8 * $Target[1]))) / 2) # afgeleid van kwadratische formule. hoogtste x, zodat x+(x-1)+(x-2)...etc binnen target eindigt
        y = $yspeed
    }
    $x = 0; $y = 0; $result = "continue"; $maxy = 0 
    while ($result -eq "continue") {
        $x += $speed["x"]
        $y += $speed["y"]
        $result = TestTarget -x $x -y $y
        $maxy = [Math]::Max($y, $maxy)
        if ($speed["x"] -ne 0) { $speed["x"] = $speed["x"] - ($speed["x"] / [Math]::Abs($speed["x"])) }
        $speed["y"] = $speed["y"] - 1
    }
    "$maxy, $yspeed, $diff, $result"
    if ($result -eq "hit") {
        $diff = [Math]::Ceiling($diff / 2)
        $yspeed += $diff
        $maxprev = $maxhit
        $maxhit = $maxy
    }
    else {
        $diff = [Math]::Ceiling($diff / 2)
        $yspeed -= $diff
    }
}

$maxhit

## Part 2
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

$Target = ($data -replace "[a-z\s:=]", "") -split "," | % { $_ -split "\.\." | Sort-Object {[Math]::Abs($_)}} #x1, x2, y1, y2
$maxy = [Math]::Abs([int]$target[3])-1
$maxx = $Target[1]

function testHit ($xspeed, $yspeed) {
    $result = "continue"
    $speed = @{
        x = $xspeed
        y = $yspeed
    }
    $x = 0; $y = 0
    while ($result -eq "continue") {
        $x += $speed["x"]
        $y += $speed["y"]
        $result = TestTarget -x $x -y $y
        if ($speed["x"] -ne 0) { $speed["x"] = $speed["x"] - ($speed["x"] / [Math]::Abs($speed["x"])) }
        $speed["y"] = $speed["y"] - 1
    }
    if ($result -eq "hit") {$true}
    else {$false}
}

$totest = ((-$maxy-1)..$maxy).count * (0..$maxx).count; $i = 0
$hits = @()
foreach ($x in (0..$maxx)) {
    foreach ($y in ((-$maxy-1)..$maxy)) {
        Write-Progress -Activity "testing trajectories" -PercentComplete ($i/$totest*100); $i ++
        if (testHit -xspeed $x -yspeed $y) {
            $hits += "$x,$y"
        }
    }
}

$hits = $hits |  Get-Unique 
$hits.count