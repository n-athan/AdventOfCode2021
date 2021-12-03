$data = Get-Content ".\2input.txt"

## Part 1
# long version
$position = @{
    x = 0
    y = 0
}
foreach ($instruction in $data) {
    $instruction = $instruction -split " "
    $direction = $instruction[0]
    $speed = $instruction[1]
    switch ($direction) {
        "up" { $position.y -= $speed }
        "down" { $position.y += $speed }
        "forward" { $position.x += $speed }
    }
}
$position
$position.x * $position.y

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

## Codegolf 
$data|%{$x=0;$y=0}{$d,$s=($_-split" ");switch($d[0]){"u"{$y-=$s};"d"{$y+=$s};"f"{$x+=$s}}}{$x*$y}

## Part 2

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#long version
$position = @{
    x   = 0
    y   = 0
    aim = 0
}
foreach ($instruction in $data) {
    $direction, [int] $change = $instruction -split " "
    switch ($direction) {
        "up" { $position.aim -= $change }
        "down" { $position.aim += $change }
        "forward" { $position.x += $change; $position.y += ($change * $position.aim) }
    }
}
$position
$position.x * $position.y

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#code golf
$data|%{$x=0;$y=0;$a=0}{$d,$s=($_-split" ");switch($d[0]){"u"{$a-=$s};"d"{$a+=$s};"f"{$x+=$s;$y+=$a*$s}}}{$x*$y}




