$data = Get-Content ".\6input.txt"

## Part 1
# long version
$data = "3,4,3,1,2" #test
$days = 18 # test expect 26
$days = 80 # test expect 5934
$school = $data.split(",")
function AantalKids ([int] $start) {
    for ($d = $start; $d -gt 0; $d -= 7) {
        # "$start, $d"
        $global:total += 1
        if ($d - 9 -gt 0) {
            AantalKids -start ($d - 9)
        }
    }
}

$total = 0
foreach ($fish in $school) {
    $global:total += 1
    AantalKids($days-$fish)
}
$total

#moet nog een manier vinden om * kind te doen en aantal door te geven. 
#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

## Codegolf 

## Part 2
$days = 32                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
$total = 1
AantalKids($days); $total #21

$days = 64 
$total = 1
AantalKids($days); $total #350

$days = 128
$total = 1
AantalKids($days); $total #94508

$days = 32  
$a = [Math]::Floor($days/7)
(0..$a) | % {$result = 0} {
    $n = [Math]::Floor(($days-($_*7+($_-1)*2))/7)
    $n
    if ($n -ge 0) {$result += $n}
}{$result}

$days = 32
$a = [Math]::Floor($days/7)
(1..$a) | % {$result = 1} {
    $result += $_*($a-$_+1)
}{$result}

$data = "3,4,3,1,2" #test
$school = $data.split(",")
$days = 18 # test expect 26
$total = 0
foreach ($fish in $school) {
    $d = $days - $fish 
    $a = [Math]::Floor($d/7)
    $total += (1..$a) | % {$result = 0} {
        $result += $_*($a-$_+1)
    }{$result}
} 
$total


$days = 18
$a = [Math]::Floor($days/7)
(1..$a) | % {$result = 1} {
    $result += $_*($a-$_+1)
}{$result}
