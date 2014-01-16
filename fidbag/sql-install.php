<?php
/*
* 2007-2014 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2014 PrestaShop SA
*  @version  Release: $Revision: 9844 $
*  @license	http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/
	// Init
	$sql = array();
		
	$sql[] = 'CREATE TABLE IF NOT EXISTS `'._DB_PREFIX_.'fidbag_user` (
			  `id_user` int(10) NOT NULL AUTO_INCREMENT,
			  `id_customer` int(10) DEFAULT NULL,
			  `login` varchar(64) DEFAULT NULL,
			  `password` varchar(64) DEFAULT NULL,
			  `id_cart` int(10) DEFAULT NULL,
			  `card_number` varchar(64) DEFAULT NULL,
			  `payed` tinyint(1) unsigned NOT NULL DEFAULT "0",
			  PRIMARY KEY  (`id_user`)
		) ENGINE='._MYSQL_ENGINE_.' DEFAULT CHARSET=utf8;';
?>
