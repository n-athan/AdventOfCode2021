$data = Get-Content ".\3input.txt"

## Part 1
# long version
$length = $data[0].Length
[string] $result = ""
foreach ($i in (0..($length-1))) {
    $result += ($data | Group-Object {$_[$i]} | Sort-Object Count)[1] | Select-Object -ExpandProperty name
}
$gamma = [Convert]::ToInt32($result,2)
$comp = [Math]::Pow(2,$length)-1
$epsilon = $gamma -bxor $comp

$gamma *$epsilon

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

## Part 2
#long version
$length = $data[0].Length
$Oxydata = $data
$CO2data = $data
foreach ($i in (0..($length-1))) {
    $Oxydata = ($Oxydata | Group-Object {$_[$i]} | Sort-Object Count, Name)[1].Group
    $CO2data = ($CO2data | Group-Object {$_[$i]} | Sort-Object Count, Name)[0].Group
}
$Oxy = [Convert]::ToInt32($Oxydata,2)
$Co2 = [Convert]::ToInt32($CO2data,2)

$Oxy *$Co2
