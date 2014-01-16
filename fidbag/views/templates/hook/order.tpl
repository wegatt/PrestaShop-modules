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
<div style="clear:both" class="table_block">
	<table class="detail_step_by_step std">
		<thead>
			<tr>
				<th colspan="2">{l s='Fid\'Bag account' mod='fidbag'}</th>
			</tr>
		</thead>
		<tbody>
			{if isset($fidbag) && $fidbag->returnInfos->mCode == 0}
			<tr class="item">
				<td>{l s='Fid\'Bag Card number' mod='fidbag'}</td>
				<td>{$fidbag->FidBagCardNumber|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr class="item">
				<td>{l s='End of Validity' mod='fidbag'}</td>
				<td>{$fidbag->EndValidity|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr class="item">
				<td>{l s='Vertical Credit' mod='fidbag'}</td>
				<td>{$fidbag->VerticalCredit|escape:'htmlall':'UTF-8'}</td>
			</tr>
			{else if isset($fidbag) && $fidbag->returnInfos->mCode != 0}
			<tr class="item">
				<td>{l s='Error' mod='fidbag'}</td>
				<td>{$fidbag->returnInfos->mMessage|escape:'htmlall':'UTF-8'}</td>
			</tr>
			{else}
			<tr class="item">
				<td>{l s='Error' mod='fidbag'}</td>
				<td></td>
			</tr>
			{/if}
		</tbody>
	</table>
</div>
