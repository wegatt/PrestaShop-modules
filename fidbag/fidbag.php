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

if (!defined('_PS_VERSION_'))
	exit;

require_once(_PS_MODULE_DIR_."/fidbag/class/fidbagWebService.php");
require_once(_PS_MODULE_DIR_."/fidbag/class/fidbagUser.php");

class Fidbag extends Module
{

	private $_postErrors = array();
	private $_moduleName = 'fidbag';
	private $_fieldsList = array();
	private $_parsedVar = array();

	function __construct()
	{
		$this->name = 'fidbag';
		$this->tab = 'pricing_promotion';
		$this->version = '1.3';
		$this->author = 'PrestaShop';

		parent::__construct();

		$this->displayName = $this->l('Fid\'Bag');
		$this->description = $this->l('Provide a loyalty program to your customers.');

		$warning = array();

		$this->loadingVar();

		foreach ($this->_fieldsList as $keyConfiguration => $name)
			if (!Configuration::get($keyConfiguration) && !empty($name))
				$warning[] = '\''.$name.'\' ';

		if (count($warning) > 1)
			$this->warning .= implode(' , ',$warning).$this->l('must be configured to use this module correctly.').' ';
		elseif (count($warning) == 1)
			$this->warning .= implode(' , ',$warning).$this->l('has to be configured to use this module correctly.').' ';

		/**
		 * Backward compatibility
		 **/
		if (_PS_VERSION_ < '1.5')
			require(_PS_MODULE_DIR_.'/'.$this->name.'/backward_compatibility/backward.php');
	}

	public function loadingVar()
	{
		// Loading Fields List
 		$this->_fieldsList = array(
			'FIDBAG_MERCHANT_CODE' => $this->l('Fid\'bag Merchant Code'),
			'FIDBAG_MERCHANT_CERTIFICAT' => $this->l('Fid\'bag Merchant Certificat'),
            'FIDBAG_ORDER_STATUS'=> $this->l('Points are awarded when the order is'),
			'FIDBAG_MERCHANT_ACTIVE' => '',
			'FIDBAG_TOKEN' => ''
		);
	}

	function install()
	{
		include(dirname(__FILE__).'/sql-install.php');
		foreach ($sql as $s)
			if (!Db::getInstance()->Execute($s))
				return false;
		if (!parent::install() || !$this->registerHook('UpdateOrderStatus') || !$this->registerHook('orderDetailDisplayed') || !$this->registerHook('extraRight') || !$this->registerHook('shoppingCart')  || !$this->registerHook('header') || !$this->registerHook('createAccountForm') || !$this->registerHook('createAccount'))
			return false;

		Configuration::updateValue('FIDBAG_MERCHANT_CERTIFICAT', '120890882');
		Configuration::updateValue('FIDBAG_TOKEN', md5(rand()));
		Configuration::updateValue('FIDBAG_TEST_ENVIRONMENT', true);
        Configuration::updateValue('FIDBAG_ORDER_STATUS' ,  OrderStateCore::FLAG_SHIPPED);

		return true;
	}

	/*
	 * Load Modules Config on demand $this->_fieldsList
	 */
	function uninstall()
	{
        include(dirname(__FILE__).'/sql-install.php');
        foreach ($sqlUninstall as $s)
            if (!Db::getInstance()->Execute($s))
                return false;

        return parent::uninstall() &&
			$this->unregisterHook('UpdateOrderStatus') &&
 			$this->unregisterHook('header') &&
			$this->unregisterHook('orderDetailDisplayed') &&
            $this->unregisterHook('extraRight') &&
            $this->unregisterHook('shoppingCart') &&
			$this->unregisterHook('createAccountFrom') &&
			$this->unregisterHook('createAccount');
	}

	/***
	The getContent()method is the first one to be called when the configuration page is loaded
	**/
	public function getContent()
	{
		$html = '';
		$error = array();
		$smarty = Context::getContext()->smarty;
        global $cookie;

		if (!empty($_POST) && Tools::isSubmit('submitSave'))
		{
			$this->_postValidation();
			if (!sizeof($this->_postErrors))
			{
				$this->_postProcess();
				$html .= $this->_displayValidation();
			}
			else
				foreach ($this->_postErrors AS $err)
					$error[] = $err;
		}
		$smarty->assign('error', $error);
        $smarty->assign('order_states',OrderStateCore::getOrderStates($cookie->id_lang));
		$html .= $this->_displayConfiguration();
		return $html;
	}

	private function _postValidation()
	{
		$code = Tools::getValue('fidbag_merchant_code');

		if (!$code)
			$this->_postErrors[] = $this->l('All the fields are required');
		elseif (extension_loaded('soap'))
		{
			$webService = new FidbagWebService();
			$return = $webService->action('GetMerchantInformations', array('MerchantCode' => Tools::getValue('fidbag_merchant_code')));
			if ($return != null)
			{
				$json_return = Tools::jsonDecode($return->GetMerchantInformationsResult);
				if ($json_return->returnInfos->mCode != 0)
					$this->_postErrors[] = $this->l('failed login credential');
			}
			else
				$this->_postErrors[] = $this->l('WebService Error. Please, Try again later.');
		}
		else
			$this->_postErrors[] = $this->l('Soap must be activated');
	}

	private function _postProcess()
	{
		Configuration::updateValue('FIDBAG_MERCHANT_CODE', Tools::getValue('fidbag_merchant_code'));
		Configuration::updateValue('FIDBAG_TEST_ENVIRONMENT', (int)Tools::getValue('fidbag_environment'));
		Configuration::updateValue('FIDBAG_MERCHANT_ACTIVE', 'on');
        Configuration::updateValue('FIDBAG_ORDER_STATUS' , (int)Tools::getValue('fidbag_order_state'));
	}

	private function _displayValidation()
	{
		return '<div class="conf confirm">'.$this->l('Settings updated').'</div>';
	}

	private function _displayConfiguration()
	{
		$this->loadTPLVars(null);
		return $this->display( __FILE__, 'views/templates/admin/configuration.tpl' );
	}

	private function loadTPLVars($param)
	{
	    $smarty = Context::getContext()->smarty;
        $isLogged=$this->context->cookie->isLogged();


			$var = array('path' => $this->_path,
						 'tab' => Tools::safeOutput(Tools::getValue('tab')),
						 'configure' => Tools::safeOutput(Tools::getValue('configure')),
						 'token' => Tools::safeOutput(Tools::getValue('token')),
						 'tab_module' => Tools::safeOutput(Tools::getValue('tab_module')),
						 'module_name' => Tools::safeOutput(Tools::getValue('module_name')),
						 'fidbag_token' => $this->getSecureToken(-1),
						 'img' => _PS_IMG_,
						 'module' => _PS_MODULE_DIR_.$this->_moduleName.'/',
						 'process_type'=>(int)Configuration::get('PS_ORDER_PROCESS_TYPE'),
						 'isLogged'=>$this->context->cookie->isLogged(),
						 'id_cart'=>-1,
						 'id_customer'=>-1,
						 'discount'=>0,
						 'price'=>0,
						 'total_cart'=>0,
						 'shipping'=>0

						 );

			//init var
			$smarty->assign('sub_gender', 1);
			$smarty->assign('sub_lastname', '');
			$smarty->assign('sub_firstname', '');
			$smarty->assign('sub_email', '');
			$smarty->assign('fidbag_login', '');
			$smarty->assign('fidbag_password','');
			$smarty->assign('sub_address', '');
			$smarty->assign('sub_zipcode', '');
			$smarty->assign('sub_city', '');

 		   if(!empty($param) && isset($param['cart']) ){
			   if(isset($this->context->customer->id))
			   {
 				   $customer = new Customer($this->context->customer->id);
 				   $var['id_customer'] =$customer->id;
				   $var['fidbag_token'] = $this->getSecureToken($var['id_customer']);

	    			if (isset($customer->id_gender))
	    				$smarty->assign('sub_gender', $customer->id_gender);
	    			$smarty->assign('sub_lastname', $customer->lastname);
	   				$smarty->assign('sub_firstname', $customer->firstname);
	   				$smarty->assign('sub_email', $customer->email);


			   		$fidbag_user = new FidbagUser($var['id_customer']);
                     $fidbag_user =$fidbag_user->getFidBagUser();

                   if( $fidbag_user != false)
					{

                        $smarty->assign('fidbag_login', $fidbag_user->getLogin());
			   		    $smarty->assign('fidbag_password', $fidbag_user->getPassword());
					}
 				   $addresses = $customer->getAddresses(Context::getContext()->language->id);

 		 		  if(count($addresses) > 0)
 				  {
 					  $address = new Address($addresses[0]['id_address']);
 					  $smarty->assign('sub_address', $address->address1.' '.$address->address2);
 					  $smarty->assign('sub_zipcode', $address->postcode);
 					  $smarty->assign('sub_city', $address->city);
 				  }
               }
			  }


			  if(isset($param['cart']) && isset($param['cart']->id))
			  {
                  $cart = new Cart($param['cart']->id);
				  $smarty->assign('price', $cart->getOrderTotal(true, Cart::ONLY_PRODUCTS_WITHOUT_SHIPPING));
				  $smarty->assign('shipment', $cart->getOrderTotal(true, Cart::ONLY_SHIPPING));
				  $smarty->assign('total_cart', $cart->getOrderTotal());
				  $smarty->assign('shipping', $cart->getOrderTotal(true, Cart::ONLY_SHIPPING));
				  $smarty->assign('discount', $cart->getOrderTotal(true, Cart::ONLY_DISCOUNTS));
				  $var['id_cart'] = $param['cart']->id;
			  }



			$merchant = array(
				'code' => Configuration::get('FIDBAG_MERCHANT_CODE'),
				'test_environment' => (bool)Configuration::get('FIDBAG_TEST_ENVIRONMENT'),
			);

            $smarty->assign('glob', $var);
            $smarty->assign('order_state_trigger',Configuration::get('FIDBAG_ORDER_STATUS') );
			$smarty->assign('merchant', $merchant);
			$smarty->assign('main_url', $this->getMainUrl());
			$smarty->assign('fidbag_token', $var['fidbag_token']);

			if (_PS_VERSION_ < '1.5')
			 	$smarty->assign('base_dir', Tools::getProtocol().Tools::getHttpHost().__PS_BASE_URI__);
			$this->_parsedVar= $var;
	}

	private function getSecureToken($customer_id)
	{
			return Tools::encrypt((int)$customer_id.'-'.Configuration::get('FIDBAG_TOKEN'));
	}

	private function getMainUrl()
	{
		$protocol_link = Tools::usingSecureMode() ? 'https://' : 'http://';
		return $protocol_link.Tools::getShopDomainSsl().__PS_BASE_URI__;
	}

	public function hookHeader()
	{
		$context = Context::getContext() ;
        if ( $context->controller instanceof OrderOpcControllerCore  or  $context->controller instanceof OrderControllerCore or $context->controller instanceof ProductControllerCore  ) {
            $context->controller->addCSS(($this->_path).'css/fidbag.css','all');
            $context->controller->addJS(($this->_path).'js/fidbag.js');
        }
	}

	public function hookShoppingCart($param)
	{
		 $this->loadTPLVars($param);
		if (!$this->_activeVerification() )
			return false;
		$link = new Link();
		$customer = new Customer($param['cart']->id_customer);
		$smarty = Context::getContext()->smarty;


		if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE') == 1)
			$smarty->assign('redirect', $link->getPageLink('order-opc.php'));
		else
		{
			if (_PS_VERSION_ >= '1.5')
				$smarty->assign('redirect', $link->getPageLink('order.php', false, null, array('step' => '3')));
			else
				$smarty->assign('redirect', $link->getPageLink('order.php?step=3'));
		}


		$this->_displayValidation();
		if (_PS_VERSION_ < '1.5')
			return $this->display( __FILE__, 'views/templates/hook/payment_top_14x.tpl' );
		return $this->display( __FILE__, 'views/templates/hook/payment_top.tpl' );
	}

	private function _activeVerification()
	{
		if (!$this->active || Configuration::get('FIDBAG_MERCHANT_ACTIVE') != 'on' || !extension_loaded('soap'))
			return false;
		return true;
	}

	public function hookUpdateOrderStatus($params)
	{
		if (!$this->_activeVerification())
			return false;

        if (!Validate::isLoadedObject($params['newOrderStatus']))
            die($this->l('Missing parameters'));

        $order = new Order((int)$params['id_order']);
        if ($order && !Validate::isLoadedObject($order))
            die($this->l('Incorrect Order object.'));

        $new_order_status =$params['newOrderStatus'];
        if ($new_order_status->id == Configuration::get("FIDBAG_ORDER_STATUS"))
        {
        	$fidbag_user = new FidbagUser( $order->id_customer);

            if ($fidbag_user->getFidBagUser()   && $order->id_cart == $fidbag_user->getIdCart())
           {
               $discounts =null;
               $cart = new Cart($order->id_cart);
                  if (_PS_VERSION_ >= '1.5')
                $discounts = $cart->getCartRules();
                     else
                $discounts = $cart->getDiscounts();

                    if (count($discounts))
                    {
            foreach ($discounts as $key => $val)
            {
                if (strcmp($val['name'], 'Fid\'Bag') === 0)
                {
                    if (_PS_VERSION_ >= '1.5')
                    {
                        $discount = new Discount($val['id_discount']);
                        $discount_value = $discount->reduction_amount;
                    }
                    else
                    {
                        $discount = $val;
                        $discount_value = $val['value'];
                    }
                }
            }
        }

        $webService = new FidbagWebService();
        $total_cart = $cart->getOrderTotal(true, Cart::BOTH_WITHOUT_SHIPPING);

        if (isset($discount_value) && ((int)$discount_value > 0))
        {
            $return = $webService->action('ConsumeImmediateRebate', array(
                'CardNumber' => $fidbag_user->getCardNumber(),
                'MerchantCode' => Configuration::get('FIDBAG_MERCHANT_CODE'),
                'Amount' => (int)($total_cart),
                'RebateUsed' => (int)$discount_value,
                'AmountDo' => (int)$total_cart,
            ));

            $json_return = Tools::jsonDecode($return->ConsumeImmediateRebateResult);
        }
        else
        {
            $return = $webService->action('CreditFidCard', array(
                'MerchantCode' => Configuration::get('FIDBAG_MERCHANT_CODE'),
                'FidCardNumber' => $fidbag_user->getCardNumber(),
                'PurchaseOrderAmountTTC' => (int)$total_cart
            ));

            $json_return = Tools::jsonDecode($return->CreditFidCardResult);
        }
        $fidbag_user->setPayed(true);
    }
    }
	}

	public function hookOrderDetailDisplayed($params)
	{

		 $this->loadTPLVars($params);
		if (!$this->_activeVerification())
			return false;

		$fidBagUser = new FidbagUser($params['order']->id_customer);
		if (!$fidBagUser)
			return false;

		$smarty = Context::getContext()->smarty;
		$webService = new FidbagWebService();
		$fidBagUser->getFidBagUser();
		$return = $webService->action('GetFidBagCardInformations',
			array(
				'MerchantCode' => Configuration::get('FIDBAG_MERCHANT_CODE'),
				'FidCardNumber' => $fidBagUser->getCardNumber()
			)
		);

		if ($return != null)
		{
			$json_return = Tools::jsonDecode($return->GetFidBagCardInformationsResult);
			$smarty->assign('fidbag', $json_return);
		}
		return $this->display( __FILE__, 'views/templates/hook/order.tpl' );
	}

	public function hookExtraRight($params)
	{
		$product = new Product((int)Tools::getValue('id_product'));
 		if ($product->getPrice() <= 0)
			return false;
		$points = (int)round(10 * $product->getPrice());
		if (_PS_VERSION_ < '1.5')
			$this->smarty->assign('base_dir', Tools::getProtocol().Tools::getHttpHost().__PS_BASE_URI__);
		$this->smarty->assign(
			array(
				'points' => (int)$points
 			)
		);

		return $this->display(__FILE__, 'views/templates/hook/product.tpl');
	}

	public function hookCreateAccountForm($param)
	{
		$this->loadTPLVars($param);
		$link = new Link();
		$smarty = Context::getContext()->smarty;


		if ((int)Configuration::get('PS_ORDER_PROCESS_TYPE')==1)
			{$smarty->assign('redirect', $link->getPageLink('order-opc.php') );}
        else
        {
            if (_PS_VERSION_ >= '1.5')
                $smarty->assign('redirect', $link->getPageLink('order.php', false, null, array('step' => '3')));
            else
                $smarty->assign('redirect', $link->getPageLink('order.php?step=3'));
        }

        return $this->display( __FILE__, 'views/templates/hook/displayCustomerAccountForm.tpl' );
	}

	public function hookCreateAccount($params){
             $this->loadTPLVars($params);
        if(Tools::getValue("ajax")==true && (int)Configuration::get('PS_ORDER_PROCESS_TYPE')== 1)
        {

            $argCreateUser = array();
            $argCreateUser['MerchantCode']= Configuration::get('FIDBAG_MERCHANT_CODE');
            $argCreateUser['Civility']= Tools::getValue("fidbag_subs_civility");
            $argCreateUser['Email']	=Tools::getValue("email");
            $argCreateUser['LastName']= Tools::getValue("customer_lastname");
            $argCreateUser['FirstName']= Tools::getValue("customer_firstname");
            $argCreateUser['Address']= Tools::getValue("fidbag_subs_address");
            $argCreateUser['ZipCode']= Tools::getValue("fidbag_subs_zip_code");
            $argCreateUser['City']= Tools::getValue("fidbag_subs_city");
            $argCreateUser['Password']= Tools::getValue("passwd");
            if(empty($argCreateUser['Password']))
            {
                $argCreateUser['Password']='azerty0123';
                //useful for guest accounts
            }
            $argCreateUser['FidCardNumber']= Tools::getValue("fidbag_subs_card_number");
            if(empty($argCreateUser['FidCardNumber']))
            {
                unset($argCreateUser['FidCardNumber']);
                //useful for typos
            }
            $argCreateUser['LanguageCode']=Tools::getValue("fidbag_subs_language_code");

            $webService = new FidbagWebService();
            $return= Tools::jsonDecode( $webService->CreateFidBagAccountWithTempCardAndFullAddressAndExternalToken($argCreateUser));
            if($return->returnInfos->mMessage == "Success")
            {
              $argLogin = array();
              $argLogin ['Login']=$return->eMail;
              $argLogin['Password']=$return->ExternalToken;
              $argLogin['ExternalToken']=$return->ExternalToken;
              $webService->LoginFidbag($argLogin,$this->_parsedVar['id_customer'],$this->_parsedVar['id_cart']);
             }

        }

	}

}
