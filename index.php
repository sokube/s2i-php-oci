<html>
<head>
	<title>Test PHP passed</title>
</head>
<body>
<h1>PHP is working</h1>
<p>
<?php
  phpinfo();
  
  // // Connexion au service XE (i.e. la base de données) sur la machine "localhost"
  // $conn = oci_connect('hr', 'welcome', 'localhost/XE');
  // if (!$conn) {
  //     $e = oci_error();
  //     trigger_error(htmlentities($e['message'], ENT_QUOTES), E_USER_ERROR);
  // }

  // $stid = oci_parse($conn, 'SELECT * FROM employees');
  // oci_execute($stid);

  // echo "<table border='1'>\n";
  // while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
  //     echo "<tr>\n";
  //     foreach ($row as $item) {
  //         echo "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "") . "</td>\n";
  //     }
  //     echo "</tr>\n";
  // }
  // echo "</table>\n";

?>




</p>
</body>
</html>