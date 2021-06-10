<?php
$servername = "localhost";
$username   = "crimsonw_bunplanetowner";
$password   = "n{s2,~0eB{?c";
$dbname     = "crimsonw_bunplanetdb1";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>