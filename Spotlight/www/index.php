<?php
// Web requirement for Spotlight for Windows
// WIP
// Ron Egli - github.com/smugzombie
// Version 0.0.1

$search = $_GET['query'];
$action = $_GET['action'];
$output - "";
//$myApps = array("sublime","subway","substring","cygwin","cygstart","forticlient");

$apps[0]['name'] = "sublime";
$apps[0]['path'] = "C:\Program Files\Sublime Text 3\sublime_text.exe";
$apps[0]['info'] = "Hello Text Editor";
$apps[1]['name'] = "cygwin";
$apps[1]['path'] = "A:\bin\mintty.exe -i /Cygwin-Terminal.ico -";
$apps[1]['info'] = "Unix terminal for Windows";
$apps[2]['name'] = "forticlient";
$apps[2]['path'] = "C:\Program Files (x86)\Fortinet\FortiClient\FortiClient.exe";
$apps[2]['info'] = "VPN Client";
$apps[3]['name'] = "notepad";
$apps[3]['path'] = "%windir%\system32\\notepad.exe";
$apps[3]['info'] = "Notepad";
$apps[4]['name'] = "notepadplusplus";
$apps[4]['path'] = "\"C:\Program Files\ (x86)\Notepad++\\notepad++.exe\"";
$apps[4]['info'] = "Notepad++";
$apps[5]['name'] = "postman";
$apps[5]['path'] = "\"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe\"  --profile-directory=Default --app-id=fhbjgbiflinjbdggehcddcbncdddomop";
$apps[5]['info'] = "postman";
$apps[6]['name'] = "mountVHD";
$apps[6]['path'] = "\"C:\Users\roneg\Dropbox (Terra Verde)\AutoHotKey\WinRun\mount.exe\"";
$apps[6]['info'] = "Mount mountVHD";

$json = json_decode(json_encode($apps), true);

//echo "Hello";

function startsWith($haystack, $needle) {
    // search backwards starting from haystack length characters from the end
    return $needle === "" || strrpos($haystack, $needle, -strlen($haystack)) !== false;
}

if($action == "search"){
	/*for ($i=0; $i < count($myApps); $i++) { 
		if(startsWith($myApps[$i], $search)){
			$output .= ",".$myApps[$i];
		}
	}	*/
	//$json = json_decode($myApps, true);

	//var_dump($json);

	for ($i=0; $i < count($json); $i++) { 
		//echo $json[$i]['name'];
		if(startsWith($json[$i]['name'], $search)){
			$output .= ",".$json[$i]['name'];
		}
	}
}

if($action == "validate"){
	for ($i=0; $i < count($json); $i++) { 
		//echo $json[$i]['name'];
		if($json[$i]['name'] == $search){
			$found = true;
			echo $json[$i]['path'];
		}
	}
	if(!$found){
		echo 0;
	}
}

if($action == "json"){
	$apps = array();

	$apps[0]['name'] = "sublime";
	$apps[0]['path'] = "C:\Program Files\Sublime Text 3\sublime_text.exe";
	$apps[0]['info'] = "Hello Text Editor";
	$apps[1]['name'] = "cygwin";
	$apps[1]['path'] = "C:\Program Files\Sublime Text 3\sublime_text.exe";
	$apps[1]['info'] = "Unix terminal for Windows";

	$json = json_encode($apps);
	echo $json;
}

echo $output;
