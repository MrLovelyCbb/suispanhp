package com.tc.tool;

import android.content.Context;
import android.telephony.TelephonyManager;

/**
 * @see <b>主要作用：用来获取SIM卡信息</b>
 * @author baidu
 */
public class SIMCardInfo {
	/**
	 * TelephonyManager提供设备上获取通讯服务信息的入口。 应用程序可以使用这个类方法确定的电信服务商和国家 以及某些类型的用户访问信息。 <BR>
	 * 应用程序也可以注册一个监听器到电话收状态的变化。不需要直接实例化这个类 <BR>
	 * 使用Context.getSystemService(Context.TELEPHONY_SERVICE)来获取这个类的实例。
	 */
	private TelephonyManager telephonyManager;
	/**
	 * 国际移动用户识别码
	 */
	private String IMSI = "";

	public SIMCardInfo(Context context) {
		telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
	}

	/**
	 * Role:获取当前设置的电话号码 <BR>
	 * Date:2012-3-12 <BR>
	 * @author CODYY)peijiangping
	 */
	public String getNativePhoneNumber() {
		String NativePhoneNumber = null;
		NativePhoneNumber = telephonyManager.getLine1Number();
		return NativePhoneNumber;
	}

	/**
	 * Role:Telecom service providers获取手机服务商信息 <BR>
	 * 需要加入权限<uses-permission
	 * android:name="android.permission.READ_PHONE_STATE"/> <BR>
	 * Date:2012-3-12 <BR>
	 * 
	 * @author CODYY)peijiangping
	 */
	public String getProvidersName() {
		String ProvidersName = "";
		// 返回唯一的用户ID;就是这张卡的编号神马的
		IMSI = telephonyManager.getSubscriberId();
		if (IMSI == null)
			IMSI = "";
		// IMSI号前面3位460是国家，紧接着后面2位00 02是中国移动，01是中国联通，03是中国电信。
		// System.out.println(IMSI);
		if (IMSI.startsWith("46000") || IMSI.startsWith("46002") || IMSI.startsWith("46007")) {
			ProvidersName = "中国移动";
		} else if (IMSI.startsWith("46001") || IMSI.startsWith("46006")) {
			ProvidersName = "中国联通";
		} else if (IMSI.startsWith("46003") || IMSI.startsWith("46005")) {
			ProvidersName = "中国电信";
		} else {
			ProvidersName = "";
		}
		return ProvidersName;
	}
	
	
	/**
	 * Role:Telecom service providers获取手机服务商信息 <BR>
	 * 需要加入权限<uses-permission
	 * android:name="android.permission.READ_PHONE_STATE"/> <BR>
	 * Date:2012-3-12 <BR>
	 * 
	 * @author CODYY)peijiangping
	 */
	public int getProvidersName_int() {
		int ProvidersName ;
		// 返回唯一的用户ID;就是这张卡的编号神马的
		IMSI = telephonyManager.getSubscriberId();
		if (IMSI == null)
			IMSI = "";
		//返回唯一的用户ID;就是这张卡的编号神马的
		//IMSI号前面3位460是国家，紧接着后面2位00 02 07是中国移动，01 06是中国联通，03 05是中国电信。
		// System.out.println(IMSI);
		if (IMSI.startsWith("46000") || IMSI.startsWith("46002") || IMSI.startsWith("46007")) {
			ProvidersName = 1;
		} else if (IMSI.startsWith("46001") || IMSI.startsWith("46006")) {
			ProvidersName = 2;
		} else if (IMSI.startsWith("46003") || IMSI.startsWith("46005")) {
			ProvidersName = 3;
		} else {
			ProvidersName = 0;
		}
		return ProvidersName;
	}

	public String getSIM_IMSI() {
		return telephonyManager.getSubscriberId();
	}

	public String getPhoneNumber(Context context) {
		TelephonyManager mTelephonyMgr;
		mTelephonyMgr = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		return mTelephonyMgr.getLine1Number();
	}
}
