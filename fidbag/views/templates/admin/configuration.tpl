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
<h2><a target="_blank" href="http://www.fidbag.com/"><img style="width:100px" src="{$glob.path}logo.jpg" alt="{l s='Fid\'Bag' mod='fidbag'}" /></a></h2>
{foreach from=$error item=message}
<div class="error"><img src="{$glob.img}admin/forbbiden.gif" alt="nok" /> {$message}</div>
{/foreach}

<fieldset>
	<legend>{l s='Fid\'Bag' mod='fidbag'}</legend>
	<p>
		{l s='Fid\'Bag is the best way to manage your customers\' loyalty.' mod='fidbag'}<br /><br />
		{l s='With this service, your customer earns loyalty points with every purchase made on your PrestaShop store.' mod='fidbag'}<br /><br />
		<u>{l s='These points accumulated in your online store can be used by your customers of two ways:' mod='fidbag'}</u>
	</p>
	<ul style="list-style:circle;margin:-6px 0 20px 16px">
		<li>{l s='Thanks to the wallet that can transform their loyalty points into euros at the level of fidelity that you want to grant. This euro value can be used from the next command on your shop ;' mod='fidbag'}</li>
		<li>{l s='Thanks to the “good deals” catalog proposed on www.fidbag.com. These loyalty points allow your end users to obtain gifts and benefits that you could hardly offer individually (travels, leisure, movies, etc.).' mod='fidbag'}</li>
	</ul>
		 
	<p><u>{l s=' With Fid\'Bag\'s module:' mod='fidbag'}</u></p>
	<ul style="list-style:circle;margin:-6px 0 20px 16px">
		<li>{l s='You allow your end users to participate in the proposed national Fid\'Bag\'s games (2 per year) in order to win prizes (travels, movies, music, TV...).' mod='fidbag'}</li>
		<li>{l s='Your online store can be seen on different Fid\'Bag\'s communication channels (mobile, website, magazines, advertisings...).' mod='fidbag'}</li>
	</ul>

	<p>{l s='Your business also includes a network of physical stores, you can expend Fid\'Bag in your stores and the loyalty points will be distributed both in your stores and in your online store.' mod='fidbag'}</p>
		 
	<p><u>{l s='How to subscribe?' mod='fidbag'}</u></p>
	<ul style="list-style:circle;margin:-6px 0 0 16px">
		<li>{l s='Step 1 - Install Fid\'Bag\'s module for PrestaShop on the site of your online store.' mod='fidbag'}</li>
		<li>{l s='Step 2 - Register online on' mod='fidbag'} <a href="http://www.fidbag-network.com/module-prestashop-fidbag/" target="_blank"><strong>http://www.fidbag-network.com/module-prestashop-fidbag/</strong></a> {l s='(Form to be completed in 2 min) ;' mod='fidbag'}</li>
		<li>{l s='Step 3 - Print and return Fid\'Bag\'s contract.' mod='fidbag'}</li>
		<li>{l s='Step 4 - Fid\'Bag give me my configuration code to be saved in my back office.' mod='fidbag'}</li>
		<li>{l s='Step 5 - Communicate the launch of the loyalty program on your on line store (eg www.toinou.com) and inform your existing customers.' mod='fidbag'}</li>
		<li>{l s='Step 6 - You can folllow your loyalty\'s activity by accessing Fid\'Bag\'s Administration.' mod='fidbag'}</li>
	</ul>
</fieldset>

<br />

<form action="index.php?tab={$glob.tab}&configure={$glob.configure}&token={$glob.token}&tab_module={$glob.tab_module}&module_name={$glob.module_name}&section=account" method="post" class="form" id="configFormAccount">
	<fieldset>
		<p>
			{l s='The following parameters were provided to you by Fid\'bag' mod='fidbag'}. 
			{l s='If you are not yet registered, click ' mod='fidbag'} <a target="_blank" href="http://www.fidbag-network.com/module-prestashop-fidbag/"><strong>{l s='here' mod='fidbag'}</strong></a>
		</p>
		
		<h4>{l s='Fid\'bag Account' mod='fidbag'} :</h4>
		
		<label>{l s='Mode' mod='fidbag'} : </label>
		<div class="margin-form">
			<table>
			<tr><td><input type="radio" name="fidbag_environment" value="1" {($merchant.test_environment == true) ? 'checked="checked"' : ''} /></td>
			<td><img src="../img/admin/disabled.gif" /></td><td>{l s='Test' mod='fidbag'}</td></tr><tr><td>
		<input type="radio" name="fidbag_environment" value="0" {($merchant.test_environment == false) ? 'checked="checked"' : ''}/></td><td> <img src="../img/admin/enabled.gif" /></td><td>{l s='Reel' mod='fidbag'}</td></tr>
		</table>
		</div>
		
		<label>{l s='Merchant code' mod='fidbag'} : </label>
		<div class="margin-form"><input type="text" size="20" name="fidbag_merchant_code" value="{$merchant.code|escape:'htmlall':'UTF-8'}" /><br /></div>
            <label>{l s='Points are awarded when the order is' mod='fidbag'}</label>
        <div class="margin-form">
        <select id="fidbag_order_state" name="fidbag_order_state">';
                {foreach from=$order_states item=order_state}
                    <option value="{$order_state['id_order_state']}"    {if $order_state_trigger eq $order_state['id_order_state']} selected="selected" {/if}  >{$order_state['name']}</option>
                {/foreach}
            </select>
        </div>
		<div class="margin-form"><input class="button" name="submitSave" type="submit" value={l s='Save' mod='fidbag'}></div>
	</fieldset>
</form>
<br clear="left" />
<br />