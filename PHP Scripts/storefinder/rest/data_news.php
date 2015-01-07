<?php

  require '../header_rest.php';
  $controllerRest = new ControllerRest();

  $resultNews = $controllerRest->getResultNews();
  $resultCategories = $controllerRest->getResultCategories();
  $resultStores = $controllerRest->getResultStores();

  header ("content-type: text/json");
  // header("Content-Type: application/text; charset=ISO-8859-1");
  echo "{";

            // NEWS
            echo "\"news\" : [";
            $no_of_rows = $resultNews->rowCount();
            $ind = 0;
            $count = $resultNews->columnCount();
            foreach ($resultNews as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));

                    if($columnName == "news_content") {
                        $val1 = preg_replace('~[\r\n]+~', '', $val);
                        $val = htmlspecialchars(trim(strip_tags($val1)));
                    }
                    
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }

                if($count > $inner_ind) {
                    echo "\"slug\" : \"slug\"";
                }

                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "]";

  echo "}";
?>