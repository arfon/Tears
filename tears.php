<?php
$fp = fopen("https://_bucketsoftears:bucketsoftears1234@stream.twitter.com/1/statuses/filter.json?track=crying","r");
while($data = fgets($fp))
{
    $time = date("YmdH");
    if ($newTime!=$time)
    {
        @fclose($fp2);
        $fp2 = fopen("{$time}.txt","a");
    }
    fputs($fp2,$data);
    $newTime = $time;
}
?>


