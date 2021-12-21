## Part 1
function readPackage ($message) {
    $version = [Convert]::ToInt32(($message[0..2] -join ""), 2) ; $global:versions += $version
    $type = [Convert]::ToInt32(($message[3..5] -join ""), 2)
    if ($type -eq 4) {
        $mess = @()
        $i = 6
        $stop = $false
        while ($i -lt ($message.Length) -and -not $stop) {
            $mess += , ($message[($i + 1)..($i + 4)] -join "")
            if ($message[$i] -eq "0") {$stop = $true; $i+=5} 
            else {$i += 5}
        }
        $mess = $mess -join ""
        if ($message.Substring($i).Length -gt 6) {
            readPackage ($message.Substring($i))
            # $message = ($message.Substring($i))
        }
    }
    else {
        $mess = $message.Substring(6)
        if ($mess[0] -eq "0") {
            $length = [Convert]::ToInt32(($mess.Substring(1, 15)), 2)
            $subs = $mess.Substring(16, $length)
            $rest = ($mess.Substring(16+$length))
            if ($rest.Length -gt 6 -and $rest -notmatch "^0+$") { readPackage $rest }
        }
        else {
            $count = [Convert]::ToInt32(($mess.Substring(1, 11)), 2)
            $subs = $mess.Substring(12)
        }
        readPackage $subs
        # $message = $subs
    }    
}
# $data = "38006F45291200"
# $data = "8A004A801A8002F478"
# $data = "620080001611562C8802118E34"
# $data = "C0015000016115A2E0802F182340"
# $data = "A0016C880162017C3686B18A3D4780"
$data = Get-Content ".\16input.txt"
$versions = @()
$signal = $data.ToCharArray()
$binary = foreach ($e in $signal) {
    $b = [byte]::Parse($e, [System.Globalization.NumberStyles]::HexNumber)
    ([System.convert]::ToString($b, 2)).PadLeft(4, '0')
} ; $binary = $binary -join ""

readPackage $binary

$versions | Measure-Object -sum | Select-Object Sum

## Part 2
