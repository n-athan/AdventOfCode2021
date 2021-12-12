$data = Get-Content ".\11input.txt"
$dc = $data.Count 
$dl = $data[0].Length

## Part 1
# long version
function inc ([int] $index) {
    if ($octopi[$index] -ne 0) {
        # Write-Output "$index, flasher: $flasher"
        $octopi[$index] += 1
    }
}
function step {
    foreach ($i in (0..($octopi.Count -1))) {
        $octopi[$i] += 1
    }
    while (($octopi | Where-Object {$_ -gt 9}).count -gt 0 ) {
        foreach ($i in (0..($octopi.Count -1))) {
            if ($octopi[$i] -gt 9) {
                $octopi[$i] = 0
                $global:flashes += 1
                $x = $i % $dl
                $y = [Math]::Floor($i/$dl)
                # a b c 
                # d X e
                # f g h
                if ($x -gt 0) {
                    inc($i-1) # d
                    if ($y -gt 0) { inc($i-1-$dl) } # a
                    if ($y -lt $dc-1) { inc($i-1+$dl) } # f
                }
                if ($x -lt $dl-1) {
                    inc($i+1) # e
                    if ($y -gt 0) { inc($i+1-$dl)} # c
                    if ($y -lt $dc-1) {inc($i+1+$dl)} # h
                }
                if ($y -gt 0) { inc($i-$dl) } # b
                if ($y -lt $dc-1) {inc($i+$dl)} # g
            }
        }
    }
}

$octopi = @()
foreach ($i in (0..($dc-1))) {
    $line =  $data[$i].ToCharArray()
    foreach ($octo in $line) {
        $octopi += [int] $octo.ToString()
    }
}

$flashes = 0
(0..99) | ForEach-Object {step}
$flashes

#View state
 # (0..9) | % {($octopi[(($_*10+0)..($_*10+9))] | % {[string] $_}) -join ""}

## Part 2
$step = 100
while (-not (($octopi |Where-Object {$_ -eq 0}).count -eq $octopi.count)) {
    $step += 1
    step
}
$step
