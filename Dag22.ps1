$data = Get-Content ".\input.txt"
$data = @(
    "on x=10..12,y=10..12,z=10..12"
    "on x=11..13,y=11..13,z=11..13"
    "off x=9..11,y=9..11,z=9..11"
    "on x=10..10,y=10..10,z=10..10"
)
$data = @(
    "on x=-20..26,y=-36..17,z=-47..7"
    "on x=-20..33,y=-21..23,z=-26..28"
    "on x=-22..28,y=-29..23,z=-38..16"
    "on x=-46..7,y=-6..46,z=-50..-1"
    "on x=-49..1,y=-3..46,z=-24..28"
    "on x=2..47,y=-22..22,z=-23..27"
    "on x=-27..23,y=-28..26,z=-21..29"
    "on x=-39..5,y=-6..47,z=-3..44"
    "on x=-30..21,y=-8..43,z=-13..34"
    "on x=-22..26,y=-27..20,z=-29..19"
    "off x=-48..-32,y=26..41,z=-47..-37"
    "on x=-12..35,y=6..50,z=-50..-2"
    "off x=-48..-32,y=-32..-16,z=-15..-5"
    "on x=-18..26,y=-33..15,z=-7..46"
    "off x=-40..-22,y=-38..-28,z=23..41"
    "on x=-16..35,y=-41..10,z=-47..6"
    "off x=-32..-23,y=11..30,z=-14..3"
    "on x=-49..-5,y=-3..45,z=-29..18"
    "off x=18..30,y=-20..-8,z=-3..13"
    "on x=-41..9,y=-7..43,z=-33..15"
    "on x=-54112..-39298,y=-85059..-49293,z=-27449..7877"
    "on x=967..23432,y=45373..81175,z=27513..53682"
)
## Part 1
# long version
$steps = @()
$data | % {
    $state, $cor = $_ -split " "
    $cor = $cor -replace "[xyz=]", ""
    $x, $y, $z = $cor -split "," 
    $x = $x | % { $a, $b = $null } { $a, $b = $_ -split "\.\." } { if ($a -in (-50..50) -and $b -in (-50..50)) { ($a..$b) } else { continue } }
    $y = $y | % { $a, $b = $null } { $a, $b = $_ -split "\.\." } { if ($a -in (-50..50) -and $b -in (-50..50)) { ($a..$b) } else { continue } }
    $z = $z | % { $a, $b = $null } { $a, $b = $_ -split "\.\." } { if ($a -in (-50..50) -and $b -in (-50..50)) { ($a..$b) } else { continue } }
    $prop = @{
        state = $state
        x     = $x
        y     = $y
        z     = $z
    }
    $steps += New-Object -TypeName PSobject -Property $prop
}

$cubeson = @()
foreach ($step in $steps) {
    foreach ($x in $step.x) {
        foreach ($y in $step.y) {
            foreach ($z in $step.z) {
                if ($step.state -eq "on") {
                    $cubeson += "$x,$y,$z"
                }
                else {
                    $cubeson = $cubeson | ? { $_ -ne "$x,$y,$z" }
                }
            }
        }
    }
}
$cubeson = $cubeson | Select-Object -Unique
$cubeson.Count

# $xchecked = @()
# $cubeson = @()
# foreach ($step in $steps) {
#     foreach ($x in $step.x) {
#         if ($x -in $xchecked) { continue } 
#         else {
#             $xchecked += $x
#             $xsteps = $steps | ? { $_.x -eq $x -and $_.state -eq $step.state}
#             $ychecked = @()
#             foreach ($xstep in $xsteps) {
#                 foreach ($y in $xstep.y) {
#                     if ($y -in $ychecked) { continue } 
#                     else {
#                         $ychecked += $y
#                         $zz = ($xsteps | ? { $_.y -eq $y }).z | Select-Object -Unique
#                         foreach ($z in $zz) {
#                             if ($step.state -eq "on") {
#                                 $cubeson += "$x,$y,$z"
#                             }
#                             else {
#                                 $cubeson = $cubeson | ? { $_ -ne "$x,$y,$z" }
#                             }
#                         }
#                     }
#                 }
#             }
#         }
#     }
# }
# $cubeson = $cubeson | Select-Object -Unique
# $cubeson.Count

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

## Codegolf 

## Part 2

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#long version

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#code golf
