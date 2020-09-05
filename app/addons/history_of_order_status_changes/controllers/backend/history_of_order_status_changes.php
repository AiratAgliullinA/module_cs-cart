<?php

use Tygh\Registry;
use Tygh\Navigation\LastView;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$params = $_REQUEST;

if ($mode == 'manage') {

    list($orders, $search) = fn_get_orders_history($params, Registry::get('settings.Appearance.admin_elements_per_page'));
    foreach ($orders as $key => $val) {
        $user_info = fn_get_user_info($val['user_id']);
        $orders[$key]['user_name'] = $user_info['firstname'];

        $order_status_description = fn_get_simple_statuses(STATUSES_ORDER, true, true);
        $orders[$key]['status'] = $order_status_description[$val['status']];
        $orders[$key]['old_status'] = $order_status_description[$val['old_status']];
    }
    
    Tygh::$app['view']->assign('orders', $orders);
    Tygh::$app['view']->assign('search', $search);
}

/**
 * Returns orders history
 *
 * @param array  $params         Array with search params
 * @param int    $items_per_page Number of orders history per page
 *
 * @return array
 */
function fn_get_orders_history($params, $items_per_page = 0)
{
    // Init filter
    $params = LastView::instance()->update('orders_history', $params);

    // Set default values to input params
    $default_params = [
        'page'           => 1,
        'items_per_page' => $items_per_page
    ];

    $params = array_merge($default_params, $params);

    // Define fields that should be retrieved
    $fields = [
        '?:orders_history.order_history_id',
        '?:orders_history.order_id',
        '?:orders_history.old_status',
        '?:orders_history.status',
        '?:orders_history.user_id',
        '?:orders_history.date_changes'
    ];

    // Define sort fields
    $sortings = [
        'order_id'     => '?:orders_history.order_id',
        'old_status'   => '?:orders_history.old_status',
        'status'       => '?:orders_history.status',
        'user_id'      => '?:orders_history.user_id',
        'date_changes' => '?:orders_history.date_changes'
    ];
    
    $sorting = db_sort($params, $sortings, 'date_changes', 'desc');

    $limit = '';
    if (!empty($params['items_per_page'])) {
        $limit = db_paginate($params['page'], $params['items_per_page']);
        $params['total_items'] = db_get_field(
            'SELECT COUNT(DISTINCT (?:orders_history.order_history_id))'
            . ' FROM ?:orders_history'
        );
    }

    $orders = db_get_array('SELECT ' . implode(', ', $fields) . ' FROM ?:orders_history WHERE 1 ?p ?p', $sorting, $limit);

    LastView::instance()->processResults('orders_history', $orders, $params);

    return [$orders, $params];
}