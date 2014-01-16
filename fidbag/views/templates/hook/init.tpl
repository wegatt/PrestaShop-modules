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
    fidbagModule.messages.technical ="{l s='Technical error, please try later' mod='fidbag'}";
    fidbagModule.messages.error ="{l s='Error' mod='fidbag'}";
    fidbagModule.messages.emailSent= "{l s='A mail has been sent' mod='fidbag'}";
    fidbagModule.messages.loginError="{l s='Indiquer votre Login' mod='fidbag'}";
    fidbagModule.messages.discountAmountIncoherence= "{l s='The total amount of rebate cannot be greater than' mod='fidbag'}";
    fidbagModule.messages.userNotVerified= "{l s='User cannot be verified' mod='fidbag'}";
    fidbagModule.messages.passwordNotTheSame="{l s='Passwords are required and must be the same' mod='fidbag'}";
    fidbagModule.messages.rebateApplied="{l s='Your discount has been applied' mod='fidbag'}";
    fidbagModule.messages.cur_login="{l s='You must enter an email' mod='fidbag'}";
    fidbagModule.messages.cur_passwd="{l s='You must enter your password' mod='fidbag'}";



    fidbagModuleObjConf = fidbagModule.getInstance();
    fidbagModuleObjConf.mainUrl = "{$main_url}";
    fidbagModuleObjConf.fidbag_login = "{$fidbag_login|escape:'htmlall':'UTF-8'}";
    fidbagModuleObjConf.fidbag_password = "{$fidbag_password|escape:'htmlall':'UTF-8'}";
    fidbagModuleObjConf.cart =  parseInt({$glob.id_cart});
    fidbagModuleObjConf.fidbagRedirect =  "{$redirect|escape:'htmlall':'UTF-8'}";
    fidbagModuleObjConf.customer = parseInt({$glob.id_customer});
    fidbagModuleObjConf.token =  "{$glob.fidbag_token|escape:'htmlall':'UTF-8'}";
    fidbagModuleObjConf.price =     parseFloat({$price|escape:'htmlall':'UTF-8'});
    fidbagModuleObjConf.discount =  parseFloat({$discount});
    fidbagModuleObjConf.totalCart = parseFloat({$total_cart});
    fidbagModuleObjConf.shipping =  parseFloat({$shipping});
    fidbagModuleObjConf.fidbagRedirect =  "{$redirect|escape:'htmlall':'UTF-8'}";
    fidbagModuleObjConf.totalDiscount = 0;

</script>