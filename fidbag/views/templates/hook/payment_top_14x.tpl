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
{if $glob.isLogged == 1}
<div style="display:block; border: 1px solid #BBB; margin-bottom: 20px;" id="fidbag_form">
	<div style="float:left; width:100px;margin-top:10px">
		<a target="_blank" href="http://www.fidbag.com/AccountCreation.aspx">
			<img border="0" src="{$glob.path}logo.png" alt="logo" style="margin:2px 0 10px 10px;border: 1px solid gray" id="logo_fidbag">
		</a>
	</div>
	<br />
	 {include file='./fidbagIntro.tpl'}	
	 {include file="./init.tpl" glob=$glob}
	 
	<div>
		<div id="fidbag_voucher_form" style='display:none' class="fidbag_rebate">
			<a style="float:right;" onclick='fidbagModule.logOutFidBagAccount()' class="fidbag_button">{l s='Log out' mod='fidbag'}</a>
			<h4 id="fidbag_title">{l s='Immediate rebate' mod='fidbag'}</h4><br/>
			<strong>{l s='Total amount available:' mod='fidbag'}</strong> <span id='fidbag_user_earned_money'></span> € - <i><span id='fidbag_user_earned_point'></span> {l s='loyalty points' mod='fidbag'}</i><br/>
			<label><strong>{l s='Thanks to your Fid\'bag rewards you own a discount of:' mod='fidbag'}</strong></label>
			<input type="hidden" id="fidbag_client_card_number"/>
			<input style='margin-left:10px;width:30px;background: none repeat scroll 0 0 white;border: 1px solid gray; color:black;margin:2px;padding:3px;' type="text" name="fidbag_discount" id="fidbag_discount"/> € <input type="button" class="fidbag_button" onclick="getImmediateRebate()" value="{l s='Use now!' mod='fidbag'}" /><br/>
			<div id="fidbag_info_form" style='display:none;margin-top:5px'>
				<span id="fidbag_info_discount"><strong>{l s='Discount value:' mod='fidbag'}</strong> <span id="fidbag_discount_amount"></span> {$currency->sign}</span><br/>
				<div id="fidbag_total_due"><strong>{l s='Total due after discount:' mod='fidbag'}</strong> <span id="fidbag_user_ttc">{$total_cart}</span> {$currency->sign}<br/></div>
				<span id="fidbag_discount_error" style="display:none;color:red"></span>
			</div>
		</div>
		<div id="fidbag_log_form">
			<ul id="fidbag_menuTab">
				<li id="fidbag_menuTab1" class="fidbag_menuTabButton">{l s='Creation of a Fid\'Bag loyalty account' mod='fidbag'}</li>
				<li id="fidbag_menuTab2" class="fidbag_menuTabButton selected">{l s='Connecting to your Fid\'Bag account' mod='fidbag'}</li>
			</ul>
			<div id="fidbag_tabList">
				<div id="fidbag_menuTab1Sheet" class="fidbag_tabList">{include file="{$glob.module}views/templates/hook/subscription.tpl"}</div>
				<div id="fidbag_menuTab2Sheet" class="fidbag_tabList selected">{include file="{$glob.module}views/templates/hook/login.tpl"}</div>
			</div>
		</div>
	</div>
	<div style="clear:both"></div>
</div>
{/if}
<p id="fidbag_loyalty">
    <img border="0" src="{$module_dir}/logo.png" alt="logo" style="width:15px" id="logo_fidbag" /> &nbsp;{l s='En validant votre panier, vous pouvez collecter '}<b>{round($total_cart*10,0) } {l s='points de fidélité Fid\'Bag'}</b>
</p>