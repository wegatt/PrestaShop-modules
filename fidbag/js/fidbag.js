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

function fidbagModule() {

	if (fidbagModule.caller != fidbagModule.getInstance) {
		throw new Error("This object cannot be instanciated");
	}
};

fidbagModule.instance = null;
fidbagModule.getInstance = function() {
	if (this.instance == null) {
		this.instance = new fidbagModule();
	}

	return this.instance;
}
//end of singleton pattern

//initialize i18n messages see header
fidbagModule.messages = function() {};

fidbagModule.outPutInformationUser = function(data) {
	var fdbg = fidbagModule.getInstance();
	if (data.returnInfos.mCode == 0) {
		$("#fidbag_log_form").hide();
		$("#fidbag_voucher_form").show();
		$("#fidbag_discount_amount").html(fdbg.discount);
		$("#fidbag_info_form").show();
		$("#fidbag_discount").val(fdbg.discount == 0 ? data.fidcardInformations.ImmediateDiscount : fdbg.discount);
		$("#fidbag_user_earned_money").html(data.fidcardInformations.ImmediateDiscount);
		$("#fidbag_user_earned_point").html(data.fidcardInformations.VerticalCredit);
		$("#fidbag_client_card_number").val(data.fidcardInformations.FidBagCardNumber);
		fdbg.totalDiscount = data.fidcardInformations.ImmediateDiscount;
	}
};

fidbagModule.logOutFidBagAccount   = function() {
	$("#fidbag_user_used_point").html('');
	$("#fidbag_discount").val('');
	$("#fidbag_log_form").show();
	$("#fidbag_voucher_form").hide();
	$("#fidbag_info_form").hide();
};

fidbagModule.getImmediateRebate    = function() {
	var fdbg = fidbagModule.getInstance();
	$.ajax({
		url: fdbg.mainUrl + "/modules/fidbag/consume_immediate_rebate.php",
		type: "POST",
		data: {
			cart: fdbg.cart,
			customer: fdbg.customer,
			rebate: $("#fidbag_discount").val(),
			token: fdbg.token
		},
		dataType: "json",
		success: function(data) {
			if ((data.error != undefined) && (data.type == 'amount')) {
				$("#fidbag_discount_error").html(fidbagModule.messages.discountAmountIncoherence + " " + data.value);
				$("#fidbag_discount_error").show();
                $("p#fidbag_loyalty").hide();
			} else if ((data.error != undefined) && (data.type == 'user')) {
				$("#fidbag_discount_error").html(fidbagModule.messages.userNotVerified);
				$("#fidbag_discount_error").show();
			} else if (data.error == undefined) {
                $("#fidbag_voucher_form.fidbag_rebate").html("<h3>"+fidbagModule.messages.rebateApplied +"</h3>");
			}
            else{
                window.location = fdbg.fidbagRedirect;
            }
		},
		error: function(er) { window.location = fdbg.fidbagRedirect;}
	});
};

fidbagModule.connectUserFidBag 	   = function() {
	var fdbg = fidbagModule.getInstance();
    var cur_passwd =$("#fidbag_client_password").val();
    var cur_login =$("#fidbag_client_login").val();
    if(cur_login == null || cur_login.length ==0)
    {
        alert(fidbagModule.messages.cur_login);
        return false;
    }
    if(cur_passwd == null || cur_passwd.length ==0)
    {
        alert(fidbagModule.messages.cur_passwd);
        return false;
    }
	$.ajax({
		url: fdbg.mainUrl + "/modules/fidbag/login.php",
		type: "POST",
		data: {
			login: cur_login,
			password: cur_passwd,
			remind: true,
			customer: fdbg.customer,
			cart: fdbg.cart,
			token: fdbg.token
		},
		dataType: "html",
		success: function(data) {
			var obj = jQuery.parseJSON(data);
			if ((obj.mCode != undefined) && (obj.mCode != '0'))
				$("#fidbag_submit_connect_result").html(obj.mMessage);
			else if (data != '0') {
				fidbagModule.outPutInformationUser(obj);
				$("#fidbag_submit_connect_result").html();
			} else
				$("#fidbag_submit_connect_result").html(fidbagModule.messages.technical);

		},
		error: function(er) {
			$("#fidbag_submit_connect_result").html(fidbagModule.messages.technical);
		}
	});

};

fidbagModule.passwordUserFidBag	   =function () {

	var fdbg = fidbagModule.getInstance();
	if ($("#fidbag_client_login").val() == '') {
		alert(fidbagModule.messages.loginError );
		return false;
	}
	$.ajax({
		url: fdbg.mainUrl + "/modules/fidbag/lost_password.php?action=LostPassword&token=" + fdbg.token,
		type: "POST",
		data: {
			Login: $("#fidbag_client_login").val(),
			LanguageCode: "fr-FR",
			Token: fdbg.token
		},
		dataType: "json",
		success: function(data) {
			if (data.mCode == 0)
				$("#fidbag_password_result").html(fidbag.messages.emailSent);
			else
				$("#fidbag_password_result").html(fidbagModule.messages.error);
		},
		error: function(er) {
			$("#fidbag_password_result").html(fidbagModule.messages.technical);
		}
	});
};

fidbagModule.subscribeUserFidBag   =function (){
	var fdbg = fidbagModule.getInstance();
	if ($("#fidbag_subs_password").val() != $("#fidbag_subs_repassword").val() || $("#fidbag_subs_password").val() == '')
	{
		$("#fidbag_submit_subscription_result").html(fidbagModule.messages.passwordNotTheSame );
		return false;
	}

	$.ajax({
		url: fdbg.mainUrl+"/modules/fidbag/subscription.php",
		type: "POST",
		data: {
			Civility : $("#fidbag_subs_civility").val(),
			LastName : $("#fidbag_subs_last_name").val(),
			FirstName : $("#fidbag_subs_first_name").val(),
			Email : $("#fidbag_subs_Email").val(),
			Address : $("#fidbag_subs_address").val(),
			ZipCode : $("#fidbag_subs_zip_code").val(),
			City : $("#fidbag_subs_city").val(),
			Password : $("#fidbag_subs_password").val(),
			FidcardNumber : $("#fidbag_subs_card_number").val(),
			LanguageCode : $("#fidbag_subs_language_code").val(),
			customer : fdbg.customer,
			token:  fdbg.token
		},
		dataType: "json",
		success: function(data)
				{

					if ((data.returnInfos != undefined) && (data.returnInfos.mCode == 0)) {
						$('#fidbag_menuTab2').trigger('click');
						$(".fidbag_button").removeAttr("disabled");
						$("#fidbag_client_login").val($("#fidbag_subs_Email").val());
						$("#fidbag_client_password").val( data.ExternalToken);
						$("input[name=submitSave]").trigger('click');
					} else if (data == '0') {
						$("#fidbag_submit_subscription_result").html( fidbagModule.messages.technical);
					} else {
						$("#fidbag_submit_subscription_result").html('<span style="color:red">'+data.returnInfos.mMessage+'</span>');
					}

							return false;

				},
		error: function(er)
		{
			$("#fidbag_submit_subscription_result").html( fidbagModule.messages.technical);
				$(".fidbag_button").removeAttr("disabled");
					return false;

		}
	});
	$(".fidbag_button").attr("disabled","disabled");
		return false;

};

fidbagModule.toggleSubscription = function(){
	$("#customer_lastname , #customer_firstname, #email, #passwd, [name$=id_gender],#address1,#postcode,#city").keyup(
		   function(){
		   	$("#fidbag_subs_last_name").attr("value", $("#customer_lastname").attr("value"));
		   	$("#fidbag_subs_first_name").attr("value", $("#customer_firstname").attr("value"));
		   	$("#fidbag_subs_Email").attr("value", $("#email").attr("value"));
		   	$("#fidbag_subs_password").attr("value", $("#passwd").attr("value"));
		   	$("#fidbag_subs_repassword").attr("value", $("#passwd").attr("value"));
		   	$("#fidbag_subs_civility").attr("value",   $("[name$=id_gender]:radio:checked").attr("value"));
		   	$("#fidbag_subs_address").attr("value", $("#address1").attr("value"));
		   	$("#fidbag_subs_zip_code").attr("value", $("#postcode").attr("value"));
		   	$("#fidbag_subs_city").attr("value", $("#city").attr("value"));
			}
		   );
		$("[name$=id_gender]").click(function(){
			$("#fidbag_subs_civility").attr("value",   $("[name$=id_gender]:radio:checked").attr("value"));
 }) ;
    //display artefact fixes
    $("#email").trigger("keyup");

    if( $("[name$=createFidbagAccountRadioShow]:radio:checked").attr("value")==0)
    {
        $("#fidbag_module_subscription_p").css("display","none");
    } else{
        $("#fidbag_module_subscription_p").css("display","block");
    }
};

fidbagModule.toggleTabButton = function(){
    $(".fidbag_menuTabButton").click(function () {
            $(".fidbag_menuTabButton.selected").removeClass("selected");
            $(this).addClass("selected");
            $(".fidbag_tabList.selected").removeClass("selected");
            $("#" + this.id + "Sheet").addClass("selected");
        });
    };


