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
require 'aes.php';     // AES PHP implementation
require 'aesctr.php';  // AES Counter Mode implementation 
$colname_user = "-1";
if (isset($_POST['urn'])) {
	//AesCtr::decrypt($_POST['urn'], 'ginotronico', 256);
	 $colname_user = $_POST['urn'];
}
mysql_select_db($database_localhost, $localhost);
$query_user = sprintf("SELECT * FROM users WHERE urn = %s", GetSQLValueString($colname_user, "text"));
$user = mysql_query($query_user, $localhost) or die(mysql_error());
$row_user = mysql_fetch_assoc($user);
$totalRows_user = mysql_num_rows($user);


if($totalRows_user>0) {
	if(strlen(trim($row_user['token']))=="") {
		$facebook="&type=CLASSIC";
	} else {
		$facebook="&type=FACEBOOK";
	}
	//if(strlen(trim($row_user['score']))!="") {
		//die("result=DUPLICATE".$facebook);
	//} else {
		die("result=YES".$facebook);
	//}
} else {
	die("result=NO&message=".$colname_user."-".$_POST['urn']);
}
mysql_free_result($user);
?>
