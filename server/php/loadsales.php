<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlorder = "SELECT * FROM tbl_sales ";

$result = $conn->query($sqlorder);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $productlist['date'] = $row['date'];
        $productlist['sales'] = $row['sales'];
    
       
        array_push($products['cart'], $productlist);
    }
    echo json_encode($products);
} else {
    echo "nodata";
}

?>