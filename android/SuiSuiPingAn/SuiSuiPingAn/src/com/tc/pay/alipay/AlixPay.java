package com.tc.pay.alipay;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.tc.myview.PayResult;
import com.tc.object.OBJ.AlixPay_Info;
import com.zphl.sspa0.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.widget.Toast;

@SuppressLint({ "SimpleDateFormat", "HandlerLeak" })
public class AlixPay {

	static String TAG = "AlixPay";
	private Activity mActivity;
	private AlixPay_Info alixPay_info;

	public AlixPay(Activity activity, AlixPay_Info alixPay_info) {
		this.mActivity = activity;
		this.alixPay_info = alixPay_info;
	}

	private ProgressDialog mProgress = null;

	// the handler use to receive the view_Pay_Full result.
	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			try {
				String strRet = (String) msg.obj;

				switch (msg.what) {
				case AlixId.RQF_PAY: {

					closeProgress();

					BaseHelper.log(TAG, strRet);

					try {
						/*
						 * / strRet范例: resultStatus={9000}; memo={};
						 * result={partner="2088201564809153"
						 * &seller="2088201564809153"
						 * &out_trade_no="050917083121576" &subject="10元充值"
						 * &body="来游戏10元来豆！" &total_fee="0.01"
						 * &notify_url="http://notify.java.jpxx.org/index.jsp"
						 * &success="true" &sign_type="RSA" &sign=
						 * "d9pdkfy75G997NiPS1yZoYNCmtRbdOP0usZIMmKCCMVqbSG1P44ohvqMYRztrB6ErgEecIiPj9UldV5nSy9CrBVjV54rBGoT6VSUF/ufjJeCSuL510JwaRpHtRPeURS1LXnSrbwtdkDOktXubQKnIMg2W0PreT1mRXDSaeEECzc="
						 * }
						 */
						// 获取交易状态码，具体状态代码请参看文档
						String tradeStatus = "resultStatus={";
						int imemoStart1 = strRet.indexOf("resultStatus=");
						imemoStart1 += tradeStatus.length();
						int imemoEnd1 = strRet.indexOf("};memo=");
						tradeStatus = strRet.substring(imemoStart1, imemoEnd1);

						String subject = "body=";
						int imemoStart2 = strRet.indexOf("body=");
						imemoStart2 += subject.length();
						int imemoEnd2 = strRet.indexOf("&total_fee=");
						subject = strRet.substring(imemoStart2, imemoEnd2);

						String total_fee = "total_fee=\"";
						int imemoStart3 = strRet.indexOf("total_fee=\"");
						imemoStart3 += total_fee.length();
						int imemoEnd3 = strRet.indexOf("\"&notify_url=");
						total_fee = strRet.substring(imemoStart3, imemoEnd3);

						String out_trade_no = "out_trade_no=\"";
						int imemoStart4 = strRet.indexOf("out_trade_no=\"");
						imemoStart4 += out_trade_no.length();
						int imemoEnd4 = strRet.indexOf("\"&subject=");
						out_trade_no = strRet.substring(imemoStart4, imemoEnd4);

						ResultChecker resultChecker = new ResultChecker(strRet);

						int retVal = resultChecker.checkSign();
						// 验签失败
						if (retVal == ResultChecker.RESULT_CHECK_SIGN_FAILED) {
							// BaseHelper.payDialog(mActivity,"提示",mActivity.getResources().getString(R.string.check_sign_failed));
							// 验签成功。验签成功后再判断交易状态码
						} else {
							// 判断交易状态码，只有9000表示交易成功
							if (tradeStatus.equals("9000")) {
								PayResult.PayRes(mActivity, 0);
							} else {
								PayResult.PayRes(mActivity, 1);
							}
						}

					} catch (Exception e) {
						PayResult.PayRes(mActivity, 1);
						e.printStackTrace();
						// BaseHelper.payDialog(mActivity, "支付失败。", "请重试");
					}
				}
					break;
				}

				super.handleMessage(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};

	// close the progress bar
	void closeProgress() {
		try {
			if (mProgress != null) {
				mProgress.dismiss();
				mProgress = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void pay() {
		MobileSecurePayHelper mspHelper = new MobileSecurePayHelper(mActivity);
		boolean isMobile_spExist = mspHelper.detectMobile_sp();
		if (!isMobile_spExist)
			return;

		if (!checkInfo()) {
			// Utils.payDialog(mActivity,Pay_LineraLayout.dialog_Pay);
			return;
		}

		try {
			// prepare the order info.
			String orderInfo = getOrderInfo();
			String signType = getSignType();
			String strsign = sign(signType, orderInfo);
			strsign = URLEncoder.encode(strsign);
			String info = orderInfo + "&sign=" + "\"" + strsign + "\"" + "&" + getSignType();

			// start the view_Pay_Full.
			MobileSecurePayer msp = new MobileSecurePayer();
			boolean bRet = msp.pay(info, mHandler, AlixId.RQF_PAY, mActivity);

			if (bRet) {
				// show the progress bar to indicate that we have started
				// paying.
				closeProgress();
				mProgress = BaseHelper.showProgress(mActivity, null, "正在支付", false, true);
			} else
				;
		} catch (Exception ex) {
			Toast.makeText(mActivity, R.string.ali_remote_call_failed, Toast.LENGTH_SHORT).show();
		}

	}

	private boolean checkInfo() {
		String partner = PartnerConfig.PARTNER;
		String seller = PartnerConfig.SELLER;
		if (partner == null || partner.length() <= 0 || seller == null || seller.length() <= 0)
			return false;

		return true;
	}

	// get the selected order info for view_Pay_Full.
	String getOrderInfo() {
		String strOrderInfo = "partner=" + "\"" + PartnerConfig.PARTNER + "\"";
		strOrderInfo += "&";
		strOrderInfo += "seller=" + "\"" + PartnerConfig.SELLER + "\"";
		strOrderInfo += "&";
		strOrderInfo += "out_trade_no=" + "\"" + getOutTradeNo() + "\"";
		strOrderInfo += "&";
		// 这笔交易标题
		strOrderInfo += "subject=" + "\"" + alixPay_info.getTitle() + "\"";
		strOrderInfo += "&";
		// 这笔交易内容
		strOrderInfo += "body=" + "\"" + alixPay_info.getInfos() + "\"";
		strOrderInfo += "&";
		// 这笔交易价钱
		// strOrderInfo += "total_fee=" + "\"" + 0.01 + "\"";
		strOrderInfo += "total_fee=" + "\"" + alixPay_info.getPrice() + "\"";
		strOrderInfo += "&";
		strOrderInfo += "notify_url=" + "\"" + alixPay_info.getNotifyUrl() + "?orderid=" + alixPay_info.getOrderid() + "\"";
		// strOrderInfo += "notify_url=" + "\"" +
		// "http://ttjb.laiyouxi.com/charge/zfbreceive?uid=45&gameid=2&mach=11&type=1\"";
		return strOrderInfo;
	}

	// get the out_trade_no for an order.
	String getOutTradeNo() {
		SimpleDateFormat format = new SimpleDateFormat("MMddHHmmss");
		Date date = new Date();
		String strKey = format.format(date);

		java.util.Random r = new java.util.Random();
		strKey = strKey + r.nextInt();
		strKey = strKey.substring(0, 15);
		return strKey;
	}

	// get the sign type we use.
	String getSignType() {
		String getSignType = "sign_type=" + "\"" + "RSA" + "\"";
		return getSignType;
	}

	// sign the order info.
	String sign(String signType, String content) {
		return Rsa.sign(content, PartnerConfig.RSA_PRIVATE);
	}

	// the OnCancelListener for lephone platform.
	static class AlixOnCancelListener implements DialogInterface.OnCancelListener {
		Activity mcontext;

		AlixOnCancelListener(Activity context) {
			mcontext = context;
		}

		public void onCancel(DialogInterface dialog) {
			mcontext.onKeyDown(KeyEvent.KEYCODE_BACK, null);
		}
	}
}
