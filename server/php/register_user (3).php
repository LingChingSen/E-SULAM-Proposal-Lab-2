<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s271738/bunplanet/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s271738/bunplanet/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s271738/bunplanet/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");

$username = $_POST['username'];
$user_email = $_POST['email'];
$phonenum = $_POST['phonenum'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$rating = "0";
$credit = "0";
$status = "active";

$sqlregister = "INSERT INTO tbl_user(username,user_email,phonenum,password,otp,rating,credit,status) VALUES('$username','$user_email','$phonenum','$passha1','$otp','$rating','$credit','$status')";
if($conn->query($sqlregister) === TRUE){
    sendEmail($otp,$user_email);
    echo "success";
}else{
    echo "failed";
}
function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                       //Disable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';                 //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'bunplanet@crimsonwebs.com';            //SMTP username
    $mail->Password   = 'xY!@rHdrn@=Z';                         //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "bunplanet@crimsonwebs.com";
    $to = $user_email;
    $subject = "From bunplanet. Please Verify Your Account";
    $message = "<p>Click the following link to verify your account<br><br>
    <a href='https://crimsonwebs.com/s271738/bunplanet/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here to verify your account</a>";
    
    $mail->setFrom($from,"bunplanet");
    $mail->addAddress($to);  
    
    $mail->isHTML(true);                    //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
    
}
?>
