<?php

include_once("dbconnect.php");

$user_email = $_POST['email'];
$password = sha1($_POST['password']);
$newpassword = sha1 ($_POST['newpassword']);

$sql = "SELECT * FROM tbl_user WHERE user_email = '$user_email' AND password = '$password' ";
$result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET password = '$newpassword'  WHERE user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
                
                echo 'success';
        }else{
                echo 'failed';
        }
    }else{
        echo "failed";
    }

?>