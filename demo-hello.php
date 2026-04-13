<?php
/**
 * Plugin Name: Hello Demo
 * Description: A starter demo plugin for this WordPress project.
 * Version:     1.0.0
 * Author:      Your Name
 */

if ( ! defined( 'ABSPATH' ) ) exit;

add_action( 'wp_footer', function () {
    echo '<!-- Hello from demo-hello.php -->';
} );
