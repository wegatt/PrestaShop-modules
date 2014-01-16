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

require('../../config/config.inc.php');
require_once(_PS_MODULE_DIR_."/fidbag/class/fidbagWebService.php");

foreach ($_POST as $key => $value)
{
	if ($keyk == "MerchantCode")
		$arg[$key] = Configuration::get('FIDBAG_MERCHANT_CODE');
	else
		$arg[$key] = Tools::safeOutput($value);
}

$webService = new FidbagWebService();
$return = $webService->action('LostPassword', $arg);
$result = 'LostPasswordResult';

$json_return = Tools::jsonDecode($return->$result);

echo $json_return;

?>