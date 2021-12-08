$data = Get-Content ".\8input.txt"
$testdata = @(
    "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
    "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc"
    "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg"
    "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb"
    "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea"
    "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb"
    "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe"
    "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef"
    "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb"
    "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
)

## Part 1
# long version
# $dataOutput = $testdata | ForEach-Object {($_.split("|"))[1]}
$dataOutput = $data | ForEach-Object { ($_.split("|"))[1] }
($dataOutput | Select-String -Pattern "\b(\w{2,4}|\w{7})\b" -AllMatches).Matches.Count

## Part 2
# $dataOutput = $testdata | ForEach-Object {($_.split("|"))[1]}
# $dataInput = $testdata | ForEach-Object {($_.split("|"))[0]}
$dataOutput = $data | ForEach-Object { ($_.split("|"))[1] }
$dataInput = $data | ForEach-Object { ($_.split("|"))[0] }

$sortedOut = @()
$dataOutput.Trim() | ForEach-Object {
    $sortedOut += , @($_.split(" ") | ForEach-Object {
        ($_.ToCharArray() | Sort-Object) -join "" 
        })
}

$sortedIn = @()
$dataInput.Trim() | ForEach-Object {
    $sortedIn += , @($_.split(" ") | ForEach-Object {
        ($_.ToCharArray() | Sort-Object) -join "" 
        } | Sort-Object { $_.length } | Get-Unique)
}

$results = ForEach ($i in (0..($data.Count - 1))) {
    $line = $sortedIn[$i]
    $dict = @{}
    foreach ($digit in $line) {
        switch ($digit.length) {
            2 { $dict[1] = $digit }
            3 { $dict[7] = $digit }
            4 { $dict[4] = $digit }
            7 { $dict[8] = $digit }
            5 {     
                if ($digit -match (($dict[1] -split "") -join ".*")) {
                    # 3 (alles van 1 zit in 3)
                    $dict[3] = $digit
                }
                elseif (($dict[4].ToCharArray() | ForEach-Object { $T = 0 } { $T += $_ -in $digit.ToCharArray() } { $T }) -eq 3) {
                    # 5 (heeft 3 streepjes overeenkomstig met 4)
                    $dict[5] = $digit
                }
                else {
                    # 2 (heeft 2 streepjes overeenkomstig met 4)
                    $dict[2] = $digit
                }             
            }
            6 {
                if ($digit -match (($dict[4] -split "") -join ".*")) {
                    # 9 (alles van 4 zit in 9)
                    $dict[9] = $digit
                }
                elseif ($digit -match (($dict[5] -split "") -join ".*")) {
                    # 6 (alles van 5 zit in 6, maar niet 4)
                    $dict[6] = $digit
                }
                else {
                    # 0 (niet alles van 5 of 4 zit in 0)
                    $dict[0] = $digit
                }  
            }
        }
    }
    [int] $res = @(
        ($dict.GetEnumerator() | Where-Object { $_.Value -eq $sortedOut[$i][0] }).Name
        ($dict.GetEnumerator() | Where-Object { $_.Value -eq $sortedOut[$i][1] }).Name
        ($dict.GetEnumerator() | Where-Object { $_.Value -eq $sortedOut[$i][2] }).Name
        ($dict.GetEnumerator() | Where-Object { $_.Value -eq $sortedOut[$i][3] }).Name
    ) -join ""
    $res
} 
$results | Measure-Object -AllStats | ForEach-Object Sum
