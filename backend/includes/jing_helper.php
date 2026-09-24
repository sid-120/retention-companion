<?php
// Age के हिसाब से penalty days निकालने वाला function
function getPenaltyByAge($age)
{
    if ($age >= 20 && $age <= 30) {
        return 4;
    } elseif ($age > 30 && $age <= 40) {
        return 8;
    } elseif ($age > 40 && $age <= 50) {
        return 16;
    } elseif ($age > 50 && $age <= 60) {
        return 21;
    } elseif ($age > 60) {
        return 30;
    } else {
        return 4; // fallback (under 20 या invalid age)
    }
}
