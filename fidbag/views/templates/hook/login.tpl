{*
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
*}
<div>
<h4>{l s='I already have a Fid\'Bag account' mod='fidbag'}</h4><br/>
	<div class="div_form_fidbag">
		<label>{l s='Email (Fid\'Bag account)' mod='fidbag'}</label>
		<input type="text" size="30" name="fidbag_client_login" id="fidbag_client_login" value="{$fidbag_login|escape:'htmlall':'UTF-8'}"/><br/>
	</div>
	<div class="div_form_fidbag">
		<label>{l s='Fid\'Bag password' mod='fidbag'}</label>
		<input type="password" size="30" name="fidbag_client_password" id="fidbag_client_password" value="{$fidbag_password|escape:'htmlall':'UTF-8'}"/><br/>
	</div>
	<div class="div_form_fidbag submit-block">
		<input style="cursor:pointer;" name="submitSave" class="fidbag_button" type="submit" value="{l s='Log in' mod='fidbag'}" onclick="fidbagModule.connectUserFidBag()" /><span id="fidbag_submit_connect_result"></span>
	</div>
</div>
<a id='fidbag_password_forget' onclick='fidbagModule.passwordUserFidBag()'>{l s='Lost your password?' mod='fidbag'}</a> <span style="color:red" id="fidbag_password_result"></span>
<script type="text/javascript">
 
if ((fidbagModuleObjConf.fidbag_login != '') && (fidbagModuleObjConf.fidbag_password != ''))
$(document).ready(
		function() {
			$("#fidbag_client_remind").attr('checked', true);
			fidbagModule.connectUserFidBag();
		}
);

 </script>