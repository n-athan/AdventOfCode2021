$data = Get-Content ".\12input.txt"
$data = @(
    "fs-end"
    "he-DX"
    "fs-he"
    "start-DX"
    "pj-DX"
    "end-zg"
    "zg-sl"
    "zg-pj"
    "pj-he"
    "RW-he"
    "fs-DX"
    "pj-RW"
    "zg-RW"
    "start-pj"
    "he-WI"
    "zg-he"
    "pj-fs"
    "start-RW"
)
$data = @(
    "start-A"
    "start-b"
    "A-c"
    "A-b"
    "b-d"
    "A-end"
    "b-end"
)

## Part 1
# long version
$paths = @{}
$data | % {
    $s, $e = $_ -split "-"; 
    if($s -ne "end" -and $e -ne "start") {$paths[$s] += [array]$e} 
    if($s -ne "start" -and $e -ne "end") {$paths[$e] += [array]$s}
}
$paths

function nextNode ($start,$route){
    if ($route -eq "") {$route = $start}
    foreach ($node in $paths[$start]) {
        if($node -eq "end") { 
            $global:routes += "$route,end"
        }
        if (-not ($node.ToLower() -ceq $node -and $route -match "\b$node\b")) {
            #$node is big cave, or not already visited.
            nextNode -start $node -route ($route + ",$node")
        } 
    }
}
$routes = @()
nextnode -start "start" -route ""
$routes.count	

## Part 2
function nextNode ($start,$route){
    if ($route -eq "") {$route = $start}
    foreach ($node in $paths[$start]) {
        if($node -eq "end") { 
            if ($route.StartsWith("MAX")) {
                $global:routes += "$($route.Substring(3)),end"
            } else {
                $global:routes += "$route,end"
            }
        } else {
            if ($node.ToLower() -ceq $node) {
                if (-not ($route.StartsWith("MAX"))) {
                    if ($route -match "\b$node\b") {
                        nextNode -start $node -route ("MAX"+ $route + ",$node")
                    }
                    else {
                        nextNode -start $node -route ($route + ",$node")
                    }
                } else {
                    if ($route -notmatch "\b$node\b") {
                        nextNode -start $node -route ($route + ",$node")
                    }
                }
            } else {
                nextNode -start $node -route ($route + ",$node")
            }
        }
    }
}

$routes = @()
nextnode -start "start" -route ""
$routes.count

