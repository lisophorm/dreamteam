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

if(!isset($_POST['type'])) {
	die("result=ERROR&message=".urlencode("post unspecified"));
} else {
	$type=$_POST['type'];
}
switch($type) {
		case "0":
		$field="helmet";
		$picture="http://www.ignitesocial.co.uk/helmet.jpg";
		$message="I just had a go on the Vodafone McLaren Mercedes F1 Helmet Simulator!";
		$name="Vodafone Playground";
		$description="I just had a go on the Vodafone McLaren Helmet simulator! I can't believe how fast Lewis Hamilton and Jenson Button drive!"; //.$_POST['score']." volt!";
		break;
		case "1":
		$field="simulator";
		$picture="http://www.ignitesocial.co.uk/simulator.jpg";
		$message="I just drove a lap on the Vodafone McLaren Mercedes F1 Simulator!";
		$name="Vodafone Playground";
		$description="I just drove a lap in the Vodafone McLaren Mercedes F1 simulator and my fastest lap time was ".$_POST['score']." !";
		break;
		case "2":
		$field="pitstop";
		$picture="http://www.ignitesocial.co.uk/pitstop.jpg";
		$message="I just changed the tyre on a Vodafone McLaren Mercedes F1 car!";
		$name="Vodafone Playground";
		$description="I just changed the wheel of a Vodafone McLaren Mercedes car in ".$_POST['score']."!";
		break;




}

require 'aes.php';     // AES PHP implementation
require 'aesctr.php';  // AES Counter Mode implementation 
$colname_user = "-1";
if (isset($_POST['urn'])) {
	 $colname_user =$_POST['urn'];
}
mysql_select_db($database_localhost, $localhost);
$query_user = sprintf("SELECT * FROM users WHERE urn = %s", GetSQLValueString($colname_user, "text"));
$user = mysql_query($query_user, $localhost) or die(mysql_error());
$row_user = mysql_fetch_assoc($user);
$totalRows_user = mysql_num_rows($user);

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
if($_POST['facebook_optin']=="1") {
	require 'php-sdk/src/facebook.php';
	
	// Create our Application instance (replace this with your appId and secret).
	$facebook = new Facebook(array(
	  'appId'  => '170716739801062',
	  'secret' => '895dcd2e86c0ee85b0d1971ea282787c',
	));
	
	// Get User ID
	$facebook->setAccessToken($row_user['token']);
	
	
	try {
		$user = $facebook->api('/me', 'get');
	} catch (FacebookApiException $e) {
		echo "result=ERROR&message=".$e->getMessage();
					die();
	}
	
	try {
					$publishStream = $facebook->api("/me/feed", 'post', array(
						'message' => $message,
						'link'    => 'https://www.facebook.com/VodafonePlayground',
						'picture' => $picture,
						'name'    => $name,
						'description'=> $description,
						//'place' => json_encode(array(
		  // 'id'  => '416595185038313',
		   //'name' => 'The name of my place'))
						)
					);
				} catch (FacebookApiException $e) {
					echo "result=ERROR&message=".$e->getMessage();
				}		
				mysql_select_db($database_localhost, $localhost);
				$query_user = sprintf("update users set posts=posts+1 WHERE urn = %s", GetSQLValueString($_POST['urn'], "text"));
				$user = mysql_query($query_user, $localhost) or die("result=ERROR&message=".urlencode(mysql_error().":".$query_user));
}

mysql_select_db($database_localhost, $localhost);
$query_user = sprintf("insert into ".$field." (userid,urn,value,creationdate,facebook) values (%s,%s,%s,NOW(),%s)", GetSQLValueString($row_user['id'], "text"),GetSQLValueString($colname_user, "text"),GetSQLValueString($_POST['score'], "text"),GetSQLValueString($_POST['facebook_optin'], "text"));
$user = mysql_query($query_user, $localhost) or die("result=ERROR&message=".urlencode(mysql_error().":".$query_user));


die("result=SUCCESS&id=".$publishStream['id']);

//199581572813




mysql_free_result($user);
?>
