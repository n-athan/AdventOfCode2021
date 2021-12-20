$data = Get-Content ".\14input.txt"
$data = @(
    "NNCB"
    ""
    "CH -> B"
    "HH -> N"
    "CB -> H"
    "NH -> C"
    "HB -> C"
    "HC -> B"
    "HN -> C"
    "NN -> C"
    "BH -> H"
    "NC -> B"
    "NB -> B"
    "BN -> B"
    "BB -> N"
    "BC -> B"
    "CC -> N"
    "CN -> C"
)

## Part 1
$template = $data[0]
$rules = @{}
$data[2..($data.Count - 1)] | ForEach-Object {
    [string]$a, [String]$b = $_ -split " -> "
    $rules[$a] = $b
}

#long version
function step ($polymer) { 
    $newpol = "$($polymer[0])"
    foreach ($i in (0..($Polymer.length - 2))) {
        $inter = $rules[$polymer.Substring($i, 2)]
        $newpol += "$inter$($Polymer[$i+1])"
    }
    $newpol
}

$stepinput = $template
(0..9) | % {
    $stepinput = step $stepinput
}
$elements = $stepinput.ToCharArray() | group | sort Count
$elements[-1].Count - $elements[0].Count


## Part 2
$rules10 = @{}
foreach ($key in $rules.Keys) {
    $stepinput = $key
    (0..9) | % {
        $stepinput = step $stepinput
    }
    # $rules10[$key] = $stepinput
    $rules10[$key] = @{
        string = $stepinput
        group = ($stepinput.ToCharArray() | group | sort Count)
    }
}

function pow($i,$j) {[Math]::pow($i,$j)}
($rules10["kb"].string | Select-String "\w{2}" -AllMatches).Matches | group

#hoeveel in NN ($template[0,1]) zit na 40 stappen
$counts = @{}
$rules.Values | Get-Unique | % {
    $counts[$_] = 0
} 
$subs = ($rules10["nn"].string | Select-String "\w{2}" -AllMatches).Matches | group # stap 10
$rules10["nn"].group | % {$counts[$_.Name] =$_.Count}

# (0..2) | % { #stap 20,30,40
#     $t = foreach ($sub in $subs.Name) {
#         $m = ($rules10[$sub].string | Select-String "\w{2}" -AllMatches).Matches
#         # $counts[$sub] = $counts[$sub]*($m | ? {$_.Name -eq $sub}).Count
#         $m
#     } 
#     $subs = $t | group
# }
# $subs | sort Count -Descending

foreach ($sub in $subs) {
    $x = ($rules10[$sub.Name].string | Select-String "\w{2}" -AllMatches).Matches 
    $x | group | select Name, Count, @{n = "totalCount"; e = {$_.count*$sub.Count}}
}
$subs = $t | group 
$subs | sort Count -Descending

[string]$result = $template[0]
foreach ($i in (0..($template.length - 2))) {
    $start = $template[$i]
    $end = $template[$i + 1]
    $temp = $start
    (0..3) | % {
        $temp += $rules10["$($temp[-1])$end"].substring(1)
        $temp
    }
    $result += $temp
}
$elements = $stepinput.ToCharArray() | group | sort Count
$elements[-1].Count - $elements[0].Count
