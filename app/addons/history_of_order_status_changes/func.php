<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

function fn_history_of_order_status_changes_change_order_status_post($order_id, $status_to, $status_from, $force_notification, $place_order, $order_info, $edp_data) 
{
    $orders_history_data = array (
	    'order_id' => $order_id,
	    'old_status' => $status_from,
	    'status' => $status_to,
	    'user_id' => Tygh::$app['session']['auth']['user_id'],
	    'date_changes' => TIME
	);
    db_query('INSERT INTO ?:orders_history ?e', $orders_history_data);
}