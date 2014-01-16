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
{if $glob.process_type==1}
 <H3>Compte de fidélité</H3>
{include file="./fidbagIntro.tpl"}
{include file="./init.tpl" glob=$glob}

<label for="createFidbagAccount" style="margin-left: 10px;" > {l s='Do you have a fidbag loyalty account ?'} </label>
<p class="required">
<input type="radio" value="1" name="createFidbagAccountRadioShow" id="createFidbagAccount" onclick="fidbagModule.toggleSubscription()" > {l s='No, create one now'}
<input type="radio" value="0" name="createFidbagAccountRadioShow" id="createFidbagAccount" checked="checked" onclick="fidbagModule.toggleSubscription()" > {l s='Yes, let me connect after my account creation'}</p>

<div id="fidbag_module_subscription_p">
	<div id="fidbag_log_form">
		<div id="fidbag_tabList">
 			<div id="fidbag_menuTab1Sheet" class="fidbag_tabList selected">{include file="{$glob.module}views/templates/hook/subscription.tpl"  sub_lastname=$sub_lastname glob=$glob}</div>
		</div>
    </div>
</div>
<script type="text/javascript"> 
fidbagModule.toggleSubscription(); 
$(".div_form_fidbag.submit-block,.div_form_fidbag.na").css("visibility","hidden");
$(".div_form_fidbag.submit-block,.div_form_fidbag.na").css("position","absolute");
$(".fidbag_button").attr("disabled","disabled");
</script>
 
{/if}

 