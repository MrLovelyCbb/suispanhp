/**
 *
 *@author luochao
 *创建日期 2013 06 06 下午05:02:47
 *
 */
package com.tc.tool;

import java.util.List;

import android.content.Context;
import android.telephony.CellLocation;
import android.telephony.NeighboringCellInfo;
import android.telephony.TelephonyManager;

/**
 * @see <b>主要作用：用来获取手机信息</b>
 * @author xxx
 */
public class TelManager {
	TelephonyManager tm;

	public TelManager(Context context) {
		tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
	}
	/**
	 * 电话状态： <BR>
	 * 1.tm.CALL_STATE_IDLE=0 无活动 <BR>
	 * 2.tm.CALL_STATE_RINGING=1 响铃 <BR>
	 * 3.tm.CALL_STATE_OFFHOOK=2 摘机
	 */
	public int getCallState() {
		return tm.getCallState();// int
	};

	/**
	 * 电话方位：
	 */
	public CellLocation getCellLocation() {
		return tm.getCellLocation();// CellLocation
	};

	/**
	 * 唯一的设备ID： GSM手机的 IMEI 和 CDMA手机的 MEID. <BR>
	 * Return null if device ID is not available.
	 */
	public String getDeviceId() {
		return tm.getDeviceId();// String
	}

	/**
	 * 服务商名称： <BR>
	 * 例如：中国移动、联通SIM卡的状态必须是 SIM_STATE_READY(使用getSimState()判断).
	 */
	public String getSimOperatorName() {
		return tm.getSimOperatorName();// String
	}

	/**
	 * SIM的状态信息： <BR>
	 * SIM_STATE_UNKNOWN 未知状态 <BR>
	 * 0 SIM_STATE_ABSENT 没插卡 <BR>
	 * 1 SIM_STATE_PIN_REQUIRED 锁定状态，需要用户的PIN码解锁 <BR>
	 * 2 SIM_STATE_PUK_REQUIRED 锁定状态，需要用户的PUK码解锁 <BR>
	 * 3 SIM_STATE_NETWORK_LOCKED 锁定状态，需要网络的PIN码解锁 <BR>
	 * 4 SIM_STATE_READY 就绪状态 5
	 */
	public int getSimState() {
		return tm.getSimState();// int
	}

	/**
	 * 当前使用的网络类型： 例如： <BR>
	 * NETWORK_TYPE_UNKNOWN 网络类型未知 <BR>
	 * 0 NETWORK_TYPE_GPRS GPRS网络 <BR>
	 * 1 NETWORK_TYPE_EDGE EDGE网络 <BR>
	 * 2 NETWORK_TYPE_UMTS UMTS网络 <BR>
	 * 3 NETWORK_TYPE_HSDPA HSDPA网络 <BR>
	 * 8 NETWORK_TYPE_HSUPA HSUPA网络 <BR>
	 * 9 NETWORK_TYPE_HSPA HSPA网络 <BR>
	 * 10 NETWORK_TYPE_CDMA CDMA网络,IS95A 或 IS95B. <BR>
	 * 4 NETWORK_TYPE_EVDO_0 EVDO网络, revision 0. <BR>
	 * 5 NETWORK_TYPE_EVDO_A EVDO网络, revision A. 6 NETWORK_TYPE_1xRTT 1xRTT网络 7
	 */
	public int getNetworkType() {
		return tm.getNetworkType();// int
	}

	/**
	 * 设备的软件版本号： 例如： <BR>
	 * the IMEI/SV(software version) for GSM phones. <BR>
	 * Return null if the software version is not available.
	 */
	public String getDeviceSoftwareVersion() {
		return tm.getDeviceSoftwareVersion();// String
	}

	/**
	 * 手机号： GSM手机的 MSISDN. Return null if it is unavailable.
	 */
	public String getLine1Number() {
		return tm.getLine1Number();// String
	}

	/**
	 * 唯一的用户ID： <BR>
	 * 例如：IMSI(国际移动用户识别码) for a GSM phone. 需要权限：READ_PHONE_STATE
	 */
	public String getSubscriberId() {
		return tm.getSubscriberId();// String
	}

	/**
	 * 取得和语音邮件相关的标签，即为识别符 需要权限：READ_PHONE_STATE
	 */
	public String getVoiceMailAlphaTag() {
		return tm.getVoiceMailAlphaTag();// String
	}

	/**
	 * 获取ISO国家码，相当于提供SIM卡的国家码。
	 */
	public String getSimCountryIso() {
		return tm.getSimCountryIso();// String
	}

	/**
	 * SIM卡的序列号： 需要权限：READ_PHONE_STATE
	 */
	public String getSimSerialNumber() {
		return tm.getSimSerialNumber();// String
	}

	/**
	 * 获取ISO标准的国家码，即国际长途区号。 <BR>
	 * 注意：仅当用户已在网络注册后有效。 在CDMA网络中结果也许不可靠。
	 */
	public String getNetworkCountryIso() {
		return tm.getNetworkCountryIso();// String
	}

	/**
	 * MCC+MNC(mobile country code + mobile network code) <BR>
	 * 注意：仅当用户已在网络注册时有效。 在CDMA网络中结果也许不可靠。
	 */
	public String getNetworkOperator() {
		return tm.getNetworkOperator();// String
	}

	/**
	 * 获取SIM卡提供的移动国家码和移动网络码. 5或6位的十进制数字. <BR>
	 * SIM卡的状态必须是SIM_STATE_READY(使用getSimState()判断).
	 */
	public String getSimOperator() {
		return tm.getSimOperator();// String
	}

	/**
	 * 获取语音邮件号码： 需要权限：READ_PHONE_STATE
	 */
	public String getVoiceMailNumber() {
		return tm.getVoiceMailNumber();// String
	}

	/**
	 * 按照字母次序的current registered operator(当前已注册的用户)的名字 <BR>
	 * 注意：仅当用户已在网络注册时有效。 在CDMA网络中结果也许不可靠。
	 */
	public String getNetworkOperatorName() {
		return tm.getNetworkOperatorName();// String
	}

	/**
	 * 手机类型： 例如： <BR>
	 * PHONE_TYPE_NONE 无信号 <BR>
	 * PHONE_TYPE_GSM GSM 信号 <BR>
	 * PHONE_TYPE_CDMA CDMA信号<BR>
	 */
	public int getPhoneType() {
		return tm.getPhoneType();// int
	}

	/**
	 * 是否漫游: (在GSM用途下)
	 */
	public boolean isNetworkRoaming() {
		return tm.isNetworkRoaming();// boolean
	}

	/**
	 * ICC卡是否存在
	 */
	public boolean hasIccCard() {
		return tm.hasIccCard();// boolean
	}

	/**
	 * 附近的电话的信息: 类型：List<NeighboringCellInfo> <BR>
	 * 需要权限：android.Manifest.permission#ACCESS_COARSE_UPDATES
	 */
	public List<NeighboringCellInfo> getNeighboringCellInfo() {
		return tm.getNeighboringCellInfo();// List<NeighboringCellInfo>
	}

}
