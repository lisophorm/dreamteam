<?php require_once('Connections/localhost.php'); ?>
<?php
if (!function_exists("GetSQLValueString")) {
function GetSQLValueString($theValue, $theType, $theDefinedValue = "", $theNotDefinedValue = "") 
{
  if (PHP_VERSION < 6) {
    $theValue = get_magic_quotes_gpc() ? stripslashes($theValue) : $theValue;
  }

  $theValue = function_exists("mysql_real_escape_string") ? mysql_real_escape_string($theValue) : mysql_escape_string($theValue);

  switch ($theType) {
    case "text":
      $theValue = ($theValue != "") ? "'" . $theValue . "'" : "NULL";
      break;    
    case "long":
    case "int":
      $theValue = ($theValue != "") ? intval($theValue) : "NULL";
      break;
    case "double":
      $theValue = ($theValue != "") ? doubleval($theValue) : "NULL";
      break;
    case "date":
      $theValue = ($theValue != "") ? "'" . $theValue . "'" : "NULL";
      break;
    case "defined":
      $theValue = ($theValue != "") ? $theDefinedValue : $theNotDefinedValue;
      break;
  }
  return $theValue;
}
}

/**
 * Copyright 2011 Facebook, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */
require 'aes.php';     // AES PHP implementation
require 'aesctr.php';  // AES Counter Mode implementation 

//$token=AesCtr::decrypt(mysql_real_escape_string($_POST['token']), 'ginotronico', 256);
//$urn=AesCtr::decrypt(mysql_real_escape_string($_POST['urn']), 'ginotronico', 256);

$token=mysql_real_escape_string($_POST['token']);
$urn=mysql_real_escape_string($_POST['urn']);

require 'php-sdk/src/facebook.php';

// Create our Application instance (replace this with your appId and secret).
$facebook = new Facebook(array(
  'appId'  => '170716739801062',
  'secret' => '895dcd2e86c0ee85b0d1971ea282787c',
));

// Get User ID from GET
try {
	$facebook->setAccessToken($token);
} catch (FacebookApiException $e) {
	echo "result=ERROR&message=".$e->getMessage();
				die();
            }

try {
	$data = $facebook->api('/me', 'get');
} catch (FacebookApiException $e) {
	echo "result=ERROR&message=".$e->getMessage();
				die();
}


$editFormAction = $_SERVER['PHP_SELF'];
if (isset($_SERVER['QUERY_STRING'])) {
  $editFormAction .= "?" . htmlentities($_SERVER['QUERY_STRING']);
}

if ((isset($_POST["urn"]))) {
  $insertSQL = sprintf("INSERT INTO users (urn, token, firstname, lastname, email, fbusername, fb_id, gender,optInTerms,optInMarketing) VALUES (%s, %s, %s, %s, %s, %s, %s, %s,%s,%s)",
                       GetSQLValueString($urn, "text"),
                       GetSQLValueString($token, "text"),
                       GetSQLValueString($data['first_name'], "text"),
                       GetSQLValueString($data['last_name'], "text"),
                       GetSQLValueString($data['email'], "text"),
                       GetSQLValueString($_POST['username'], "text"),
                       GetSQLValueString($data['id'], "text"),
                       GetSQLValueString($data['gender'], "text"),
					   GetSQLValueString($_POST['optInTerms'], "text"),
					   GetSQLValueString($_POST['optInMarketing'], "text"));

  mysql_select_db($database_localhost, $localhost);
  $Result1 = mysql_query($insertSQL, $localhost) or die("result=ERROR&message=".mysql_error());
}

try {
		$facebook->api('/me/checkins', 'POST', array(
		'access_token' => $facebook->getAccessToken(),
		'place' => '416595185038313',
		'message' =>'I am at the Vodafone Fanzone, CHQ Building to see the Vodafone McLaren Mercedes team',
		'picture' => 'http://www.ignitesocial.co.uk/logored.jpg',
		'coordinates' => json_encode(array(
		   'latitude'  => '53.349639897629',
		   'longitude' => '-6.2486263394932',
		   'tags' => $data['id'])
		 )
		
		)
		);
		} catch (FacebookApiException $e) {
					echo "result=ERROR&message=CHECKIN:".$e->getMessage();
				}	
die("result=OK");
?>