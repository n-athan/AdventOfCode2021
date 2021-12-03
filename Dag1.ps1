$data = Get-Content ".\1input.txt"

## Part 1
# long version
$ExpandedData = @()
foreach ($depth in $data) {
    $prop = @{
        depth = $depth
        increase = ($depth -gt $prev)
    }
    $ExpandedData += New-Object -TypeName psobject -Property $prop
    $prev = $depth
}
($ExpandedData | Where-object {$_.increase}).count 

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

## Codegolf 
$data | % {$c = 0}{$c += ($_ -gt $p); $p = $_}{$c}

## Part 2

#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#long version
$ExpandedData = @()
(0..($data.count - $data.Count % 3 )) | ForEach-Object {
    $depth = $data[$_]
    $sum = 0+$data[$_] + $data[$_+1] + $data[$_+2]
    $prop = @{
        depth = $data[$_]
        depthIncrease = ($depth -gt $prev.depth)
        sum = $sum
        sumIncrease = ($sum -gt $prev.sum)
    } 
    if ($prev -eq $null) {
        $prop.depthIncrease = $false
        $prop.sumIncrease = $false
    }
    $ExpandedData += New-Object -TypeName psobject -Property $prop
    $prev = @{depth = $depth; sum = $sum}
}
($ExpandedData | Where-object {$_.sumincrease}).count


#Reset Vars
Remove-Variable -name * -Exclude "Data" -Erroraction SilentlyContinue

#code golf
(0..($data.count)) | % {$c = 0}{$s = 0; $data[$_..($_+2)]| % {$s += $_}; $c += ($s -gt $p); $p = $s}{$c-1}