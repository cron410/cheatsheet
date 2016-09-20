$a = Get-Date “8/24/2016 1:00 AM”

$b = Get-ChildItem * -recurse


foreach ($i in $b)

{

    $i.LastWriteTime = $a

    $a = $a.AddMinutes(1)

}


$b
