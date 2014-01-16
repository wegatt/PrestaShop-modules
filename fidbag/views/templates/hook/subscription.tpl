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
<script type="text/javascript">
{literal}
$(document).ready(function(){
	if($("#fidbag_subs_cart").attr('checked'))
		$("#div_form_fidbag_card_number").show();
	else
		$("#div_form_fidbag_card_number").hide();
	$("#fidbag_subs_cart").click(function(){
		if ($(this).attr('checked'))
			$("#div_form_fidbag_card_number").show();
		else
            {
			$("#fidbag_subs_card_number").val('');
			$("#div_form_fidbag_card_number").hide();
		}
	});
});

{/literal}
</script>

<div id="fidbag-subscription-form">
	<h4>{l s='No account, subscribe now' mod='fidbag'}</h4><br/>
	<div class="div_form_fidbag na">
		<label>{l s='Gender' mod='fidbag'} *</label>
		<select name="fidbag_subs_civility" id="fidbag_subs_civility" >
			<option value="2" {if isset($sub_gender) && $sub_gender == 2}selected='selected'{/if}>{l s='Ms.' mod='fidbag'}</option>
			<option value="1" {if isset($sub_gender) && $sub_gender == 1}selected='selected'{/if}>{l s='Mr.' mod='fidbag'}</option>
			<option value="3" {if isset($sub_gender) && $sub_gender == 3}selected='selected'{/if}>{l s='Miss' mod='fidbag'}</option>
		</select><br/>
	</div>
	
	<div class="div_form_fidbag na">
		<label>{l s='Last name' mod='fidbag'} *</label>
		<input type="text" size="30" name="fidbag_subs_last_name" id="fidbag_subs_last_name" value="{$sub_lastname|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag na">
		<label>{l s='First name' mod='fidbag'} *</label>
		<input type="text" size="30" name="fidbag_subs_first_name" id="fidbag_subs_first_name" value="{$sub_firstname|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag na">
		<label>{l s='Email (Fid\'Bag account)' mod='fidbag'} *</label>
		<input type="text" size="30" name="fidbag_subs_Email" id="fidbag_subs_Email" value="{$sub_email|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag">
		<label>{l s='Address' mod='fidbag'} *</label>
		<input type="text" size="30" name="fidbag_subs_address" id="fidbag_subs_address" value="{$sub_address|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag">
		<label>{l s='Zip code' mod='fidbag'} *</label>
		<input type="text" size="6" name="fidbag_subs_zip_code" id="fidbag_subs_zip_code" value="{$sub_zipcode|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag">
		<label>{l s='City' mod='fidbag'} *</label>
		<input type="text" size="20" name="fidbag_subs_city" id="fidbag_subs_city" value="{$sub_city|escape:'htmlall':'UTF-8'}"/>
	</div>
	
	<div class="div_form_fidbag na">
		<label>{l s='Fid\'Bag password' mod='fidbag'} *</label>
		<input type="password" size="20" name="fidbag_subs_password" id="fidbag_subs_password"/>
	</div>
	
	<div class="div_form_fidbag na">
		<label>{l s='Enter password confirmation' mod='fidbag'} *</label>
		<input type="password" size="20" name="fidbag_subs_password" id="fidbag_subs_repassword"/>
	</div>
	
	<div class="div_form_fidbag">
		<label>{l s='Already got a Fid\'card?' mod='fidbag'} </label>
		<input type="checkbox" name="fidbag_subs_cart" id="fidbag_subs_cart"/>
	</div>
	
	<div id="div_form_fidbag_card_number" style="display:none">
		<div class="div_form_fidbag">
		<label>{l s='Enter the card number below' mod='fidbag'} *</label>
			<input type="text" size="20" name="fidbag_subs_card_number" id="fidbag_subs_card_number"/>
		</div>
	</div>
	
	<input type="hidden" name="fidbag_subs_language_code" value="fr-FR" id="fidbag_subs_language_code"/>
	
	<div class="div_form_fidbag submit-block">
		<input name="submitSave" type="submit" class="fidbag_button" value="{l s='Create you account' mod='fidbag'}" onclick="fidbagModule.subscribeUserFidBag();return false;"/><br /><span id="fidbag_submit_subscription_result"></span>
	</div>
</div>
