<?php

//
// Download script for ISO 19139 metadata records from DEIMS-SDR
//
// 0 3 7 * 6 /usr/bin/php /home/ilter_cwohner/metadata_caching/iso19139_harvesting.php > /home/ilter_cwohner/metadata_caching/iso19139.log
//

$url = 'https://data.lter-europe.net/deims/iso/harvest_list';
$xml = simplexml_load_file($url) or die("feed not loading");

$arr = json_decode(json_encode($xml), true);
$zwischen_var = $arr["dataset"]; 

// empty folder before downloading new files
$files = glob(__DIR__ . "/iso19139_files/*"); // get all file names
foreach($files as $file){ // iterate files
  if(is_file($file))
    unlink($file); // delete file
}

// save files to folder with uuid as file_name
for ($x = 0; $x < count($zwischen_var); $x++) {
    $temp_record = $zwischen_var[$x];	
	// get current directory
	$file_name = __DIR__ . "/iso19139_files/".$temp_record["UUID"].".xml";	
	file_put_contents($file_name, fopen($temp_record["path"], 'r'));	
}

?>
