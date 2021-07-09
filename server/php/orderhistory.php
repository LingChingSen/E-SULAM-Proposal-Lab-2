<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlhistory = "SELECT * FROM tbl_history INNER JOIN tbl_products ON tbl_history.prid = tbl_products.prid WHERE tbl_history.email = '$email'";;

$result = $conn->query($sqlhistory);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        
        $productlist['datepurchase'] = $row['datepurchase'];
        $productlist['productId'] = $row['prid'];
        $productlist['productName'] = $row['prname'];
        $productlist['productType'] = $row['prtype'];
     
        $productlist['price'] = $row['prprice'];
        $productlist['cartqty'] = $row['qty'];
        $productlist['prqty'] = $row['prqty'];
       
        array_push($products['cart'], $productlist);
    }
    echo json_encode($products);
} else {
    echo "nodata";
}

?>