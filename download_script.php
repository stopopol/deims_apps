<?php

//
// Download script for ISO 19139 metadata records from DEIMS-SDR
//
// 0 1 * * 0 /usr/bin/php /home/ilter_cwohner/metadata_caching/emf2iso/emf2iso.php > /home/ilter_cwohner/metadata_caching/iso19139.log 		// create records for ef
// 0 2 * * 0 /usr/bin/php /home/ilter_cwohner/metadata_caching/emf2iso/product2iso.php > /home/ilter_cwohner/metadata_caching/iso19139.log	// create records for data products
// 0 3 * * 0 /usr/bin/php /home/ilter_cwohner/metadata_caching/iso19139_harvesting.php > /home/ilter_cwohner/metadata_caching/iso19139.log	// download iso19139 records
// 0 4 * * 0 rm /home/ilter_cwohner/cswdatabase/cite.db > /home/ilter_cwohner/metadata_caching/iso19139.log					// delete db
// 1 4 * * 0 docker exec -ti pycsw pycsw-admin.py -c setup_db -f /etc/pycsw/pycsw.cfg > /home/ilter_cwohner/metadata_caching/iso19139.log	// recreate db
// 5 4 * * 0 docker exec -ti pycsw pycsw-admin.py -c load_records -p /var/lib/pycsw/iso19139_files -f /etc/pycsw/pycsw.cfg -y -r 			// import files to db
//

$url = 'https://data.lter-europe.net/deims/iso/harvest_list';
$xml = simplexml_load_file($url) or die("feed not loading");

$arr = json_decode(json_encode($xml), true);
$zwischen_var = $arr["dataset"]; 

// empty folder before downloading new files
$files = glob("/home/ilter_cwohner/cswdatabase/iso19139_files/*"); // get all file names
foreach ($files as $file) { // iterate files
  if(is_file($file))
    unlink($file); // delete file
}

// save files to folder with uuid as file_name
for ($x = 0; $x < count($zwischen_var); $x++) {
    $temp_record = $zwischen_var[$x];	
	// get current directory
	$file_name = "/home/ilter_cwohner/cswdatabase/iso19139_files/".$temp_record["UUID"].".xml";	
	file_put_contents($file_name, fopen($temp_record["path"], 'r'));	
}

// copy files from emf2iso folder to metadata caching folder
$src_folder = __DIR__ . "/emf2iso/data/emf2iso";
$dst_folder = "/home/ilter_cwohner/cswdatabase/iso19139_files/";

recurse_copy($src_folder,$dst_folder);

// copy files from product2iso folder to metadata caching folder
$src_folder = __DIR__ . "/emf2iso/data/product2iso";
recurse_copy($src_folder,$dst_folder);

// function for recursive copying
function recurse_copy($src,$dst) { 
    $dir = opendir($src); 
    @mkdir($dst); 
    while(false !== ( $file = readdir($dir)) ) { 
        if (( $file != '.' ) && ( $file != '..' )) { 
            if ( is_dir($src . '/' . $file) ) { 
                recurse_copy($src . '/' . $file,$dst . '/' . $file); 
            } 
            else { 
                copy($src . '/' . $file,$dst . '/' . $file); 
            } 
        } 
    } 
    closedir($dir); 
} 

?>
