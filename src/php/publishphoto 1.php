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

$colname_user = "-1";
if (isset($_POST['urn'])) {
  $colname_user = $_POST['urn'];
}
mysql_select_db($database_localhost, $localhost);
$query_user = sprintf("SELECT * FROM users WHERE urn = %s", GetSQLValueString($colname_user, "text"));
$user = mysql_query($query_user, $localhost) or die(mysql_error());
$row_user = mysql_fetch_assoc($user);
$totalRows_user = mysql_num_rows($user);


mysql_select_db($database_localhost, $localhost);
$query_update = sprintf("insert into userphoto (userid, urn, creationdate,facebook,filename) values (%s,%s,NOW(),%s,%s)", $row_user['id'], GetSQLValueString($_POST['urn'], "text"), GetSQLValueString($_POST['facebook_optin'], "text"),GetSQLValueString($_POST['file'], "text"));
$update = mysql_query($query_update, $localhost) or die("result=ERROR&message=".urlencode(mysql_error()));

mysql_select_db($database_localhost, $localhost);
$query_user = sprintf("update users set posts=posts+1 WHERE urn = %s", GetSQLValueString($_POST['urn'], "text"));
$user = mysql_query($query_user, $localhost) or die("result=ERROR&message=".urlencode(mysql_error()));

if($_POST["facebook_optin"]==1) {
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

$facebook->setFileUploadSupport(true);
$args = array('message' => 'Check me out at the Vodafone Fanzone, CHQ Building, George\'s Dock, Dublin!');
//$args = array('message' => 'Nézd meg, ahogy a Vodafone McLaren Mercedes F1 versenyautójában ülök a Vodafone Kezdj El Valami Újat Hétvégén!');
$args['image'] = '@' . realpath($_SERVER['DOCUMENT_ROOT']."/uploads/".$_POST['file']);
/*$args['tags']= array(array(
                              'tag_uid'=> $user['id'],
                              'x'      => 0,
                              'y'      => 0));*/

try {
	$data = $facebook->api('/me/photos', 'post', $args); 
} catch (FacebookApiException $e) {
	echo "result=ERROR&message=facebookpostphoto:".$e->getMessage();
				die();
}

        $post_url = "https://graph.facebook.com/".$data['id']."/tags/"
        . $user['id']."?access_token=".$row_user['token']."&x=" . 20 ."&y=20"
         ."&method=POST";
        $response = file_get_contents($post_url);
		die("result=SUCCESS&id=".$data['id']);
} else {
	require_once('phpmailer/class.phpmailer.php');
	
	$mail             = new PHPMailer(); // defaults to using php "mail()"
	
	$mail->IsSendmail(); // telling the class to use SendMail transport
	
	$mail->AddReplyTo("Noreply@vodafone.hu","Kezdj El Valami Újat Hétvége");
	
	$mail->SetFrom('Noreply@vodafone.hu', 'Kezdj El Valami Újat Hétvége');
	$mail->CharSet="UTF-8";
	
	$mail->AddAddress($row_user['email'],$row_user['firstname']." ".$row_user['lastname']);
	//$mail->AddAddress("andrew.fraser@ignite-london.com", "Andrew Fraser");
	
	$mail->Subject    = "Kezdj El Valami Újat Hétvége Fotó";
	
	$mail->AltBody    = "Keves Látogató! Köszönjük, hogy résztvett a Kezdj El Valami Újat Hétvégén! A csatolmányban találja az Önröl készült fotót! \n\nÜdvözlettel, Vodafone\n\n"; // optional, comment out and test
	
	$mail->MsgHTML("Keves Látogató! Köszönjük, hogy résztvett a Kezdj El Valami Újat Hétvégén! A csatolmányban találja az Önröl készült fotót! <br/><br/><em>Üdvözlettel, Vodafone</em>");
	
	$mail->AddAttachment($_SERVER['DOCUMENT_ROOT']."/uploads/".$_POST['file']); // attachment
	
	if(!$mail->Send()) {
	  $result= $mail->ErrorInfo;
	  die("result=ERROR&message=Error while sending email:".$result);
	} else {
	  die("result=SUCCESS");
	}

}







//199581572813




mysql_free_result($user);
?>
