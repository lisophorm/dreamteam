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

$editFormAction = $_SERVER['PHP_SELF'];
if (isset($_SERVER['QUERY_STRING'])) {
  $editFormAction .= "?" . htmlentities($_SERVER['QUERY_STRING']);
}


  $updateSQL = sprintf("UPDATE users SET team=%s, customer=%s, terms=%s WHERE urn=%s",
                       GetSQLValueString(AesCtr::decrypt($_POST['team'], 'ginotronico', 256), "text"),
                       GetSQLValueString(AesCtr::decrypt($_POST['customer'], 'ginotronico', 256), "text"),
                       GetSQLValueString(AesCtr::decrypt($_POST['terms'], 'ginotronico', 256), "text"),
                       GetSQLValueString(AesCtr::decrypt($_POST['urn'], 'ginotronico', 256), "text"));

  mysql_select_db($database_localhost, $localhost);
  $Result1 = mysql_query($updateSQL, $localhost) or die("result=error&message=".urlencode(mysql_error()));

die("result=OK");
?>