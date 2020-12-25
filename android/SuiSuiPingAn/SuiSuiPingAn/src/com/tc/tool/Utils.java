package com.tc.tool;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigInteger;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import com.tc.in.InfoMation;
import com.tc.object.OBJ.APP_Info;
import com.tc.object.OBJ.Main_info;
import com.tc.object.OBJ.Phone_Info;
import com.tc.object.OBJ.Updata_Info;
import com.tc.object.OBJ.User_Info;
import com.zphl.sspa0.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.AlertDialog.Builder;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.location.LocationManager;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

public class Utils {
	/** 主界面信息 */
	public static Main_info main_info = new Main_info();
	/** 用户信息 */
	public static User_Info user_Info = new User_Info();
	/** 应用信息 */
	public static APP_Info app_Info = new APP_Info();
	/** 歌迷会像欧美信息 */
	public static Updata_Info updata_Info = new Updata_Info();
	/** 屏幕信息 **/
	public static DisplayMetrics dm;
	/** 手机信息 **/
	public static Phone_Info phone_Info = new Phone_Info();
	/** 相机设置 **/
	public static final String IMAGE_UNSPECIFIED = "image/*";
	public static final int PHOTOZOOM = 201403011; // 缩放
	public static final int PHOTORESOULT = 20140301;// 结果
	
	public static boolean Pay_Mobile_Flag = false;	//话费代扣标志

	/**
	 * 通过流,返回字符串
	 * 
	 * @param is丶InputStream流对象
	 * @return String丶字符串
	 * @throws Exception
	 */
	public static String readInputStream(InputStream is) throws Exception {
		StringBuffer buffer = new StringBuffer("");
		byte[] b = new byte[1024];
		int i = -1;
		while ((i = is.read(b)) != -1) {
			buffer.append(new String(b, 0, i, "utf-8"));
		}
		is.close();
		return buffer.toString();
	}

	/**
	 * 通过post请求,MAP集合可以存放多项数据去请求
	 * 
	 * @param url丶POST地址
	 * @param map丶需要POST的MAP对象
	 *            （键值对）
	 * @return String丶字符串
	 * @throws Exception
	 */
	public static String sendPost(HttpClient hc, String url, Map<String, String> map) throws Exception {
		HttpPost post = new HttpPost(url);
		List<NameValuePair> pairs = new ArrayList<NameValuePair>();
		Set<String> keys = map.keySet();

		for (String key : keys) {// 对set里面的键进行遍历
			String value = map.get(key);// 访问每个键的值
			Log("key...value=", key + "..." + value);
			// System.out.println("key:" + key + "...value:" + value);
			pairs.add(new BasicNameValuePair(key, value));// 向list里面添加BasicNameValuePair
		}
		UrlEncodedFormEntity entity = new UrlEncodedFormEntity(pairs, "UTF-8");
		post.setEntity(entity);// 将数据和请求绑定。
		HttpResponse response = hc.execute(post);
		HttpEntity httpEntity = response.getEntity();
		String result = EntityUtils.toString(httpEntity, "UTF-8");
		return result;
	}

	/**
	 * 通过post请求返回字符串
	 * 
	 * @param url丶POST地址
	 * @return String丶字符串
	 * @throws Exception
	 */
	public static String sendPost2(HttpClient hc, String url) throws Exception {
		HttpPost post = new HttpPost(url);
		List<NameValuePair> pairs = new ArrayList<NameValuePair>();
		UrlEncodedFormEntity entity = new UrlEncodedFormEntity(pairs, "UTF-8");
		post.setEntity(entity);// 将数据和请求绑定。
		HttpResponse response = hc.execute(post);
		HttpEntity httpEntity = response.getEntity();
		String result = EntityUtils.toString(httpEntity, "UTF-8");
		return result;
	}

	/**
	 * 打印日志
	 */
	public static void Log(String clas, String info) {
		if (InfoMation.LOG_TYPE)
			System.out.println("SPB---" + clas + ":" + info);
	}

	/**
	 * 程序Toast日志
	 */
	public static void Log2(Context context, String text) {
		if (InfoMation.LOG_TYPE)
			Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
	}

	/**
	 * 程序Toast
	 */
	public static void Toast(Context context, String text) {
		Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
	}

	/**
	 * 必须的MAP
	 * 
	 * @param phone
	 *            手机号码
	 * @return HashMap
	 */

	public static HashMap<String, String> get_POSTmap(String phone) {
		// TODO 发送的参数
		String mPhone = "";
		String date = "0";
		String fuwushang = "0";
		if (!TextUtils.isEmpty(phone)) {
			mPhone = phone;
		}
		date = (System.currentTimeMillis() / 1000) + "";
		HashMap<String, String> map = new HashMap<String, String>();
		if (!TextUtils.isEmpty(phone_Info.getIMSI_NAME_INT())) {
			fuwushang = phone_Info.getIMSI_NAME_INT();
		}
		// if(phone_Info.getIMSI_NAME_INT()==null){
		//
		// }
		map.put("arr100", phone_Info.getUUID()); //
		map.put("arr0", InfoMation.SP); // sp
		map.put("arr1", "1");// 设备类型 0:未知 1:安卓 2:IOS
		map.put("arr2", fuwushang);// 服务商0：未知 1：移动 2：电信 3：联通
		map.put("arr3", date);// 客户端时序
		// map.put("arr4", "123456789");// 客户端设备号
		map.put("arr4", phone_Info.getIMEI());// 客户端设备号
		map.put("arr5", phone_Info.getMAC());// 客户端mac地址
		map.put("arr6", mPhone);// 用户手机号
		map.put("arr7", getMD5(InfoMation.SP + "1" + phone_Info.getIMSI_NAME_INT() + date + "11" + phone_Info.getMAC() + phone + InfoMation.PrivateKEY));// 效验码
		return map;
		// 验证加密方式：arr7=md5(arr0+arr1+arr2+arr3+arr4+arr5+arr6+md5key)
	}

	/**
	 * 将时间戳转为字符串(时间戳精确到秒)
	 */
	@SuppressLint("SimpleDateFormat")
	public static String getStrTime(String cc_time) {
		String re_StrTime = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日HH时");
		long lcc_time = Long.valueOf(cc_time);
		re_StrTime = sdf.format(new Date(lcc_time * 1000L));
		return re_StrTime;
	}

	/**
	 * 把HashMap转换成json
	 */
	@SuppressWarnings("rawtypes")
	public static String hashMapToJson(HashMap map) {
		String string = "{";
		for (Iterator it = map.entrySet().iterator(); it.hasNext();) {
			Entry e = (Entry) it.next();
			string += "'" + e.getKey() + "':";
			string += "'" + e.getValue() + "',";
		}
		string = string.substring(0, string.lastIndexOf(","));
		string += "}";
		return string;
	}

	/** 地址 */
	public static String URL4(String[] url) {
		int num = (int) (4 * Math.random());
		return url[num];
	}

	/**
	 * 通过字符串生成MD5
	 */
	public static String getMD5(String str) {
		StringBuffer hexString = new StringBuffer();
		if (str != null && str.trim().length() != 0) {
			try {
				MessageDigest md = MessageDigest.getInstance("MD5");
				md.update(str.getBytes());
				byte[] hash = md.digest();
				for (int i = 0; i < hash.length; i++) {
					if ((0xff & hash[i]) < 0x10) {
						hexString.append("0" + Integer.toHexString((0xFF & hash[i])));
					} else {
						hexString.append(Integer.toHexString(0xFF & hash[i]));
					}
				}
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			}
		}
		return hexString.toString();
	}

	/************************************** 获取单个文件的MD5值！ ****************************************/

	public static String getFileMD5(File file) {
		String str = null;
		if (!file.isFile()) {
			return null;
		}
		MessageDigest digest = null;
		FileInputStream in = null;
		byte buffer[] = new byte[1024];
		int len;
		try {
			digest = MessageDigest.getInstance("MD5");
			in = new FileInputStream(file);
			while ((len = in.read(buffer, 0, 1024)) != -1) {
				digest.update(buffer, 0, len);
			}
			in.close();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		BigInteger bigInt = new BigInteger(1, digest.digest());
		str = bigInt.toString(16);
		try {
			if (str.length() < 32) {
				str = addZeroForNum(str, 32);
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		return str;
	}

	/**
	 * 数字不足位数左补0
	 */
	public static String addZeroForNum(String str, int strLength) {
		int strLen = str.length();
		if (strLen < strLength) {
			while (strLen < strLength) {
				StringBuffer sb = new StringBuffer();
				sb.append("0").append(str);// 左补0
				// sb.append(str).append("0");//右补0
				str = sb.toString();
				strLen = str.length();
			}
		}
		return str;
	}

	/************************************** 获取单个文件的MD5值！ ****************************************/

	/**
	 * 获取WIFI本机IP
	 */
	public static String get_IP(Activity activity) {
		WifiManager wifiManager = (WifiManager) activity.getSystemService(Context.WIFI_SERVICE);
		// 判断wifi是否开启
		if (wifiManager.isWifiEnabled()) {
			WifiInfo wifiInfo = wifiManager.getConnectionInfo();
			int ipAddress = wifiInfo.getIpAddress();
			if (ipAddress == 0)
				return "000000000000";
			return ((ipAddress & 0xff) + "." + (ipAddress >> 8 & 0xff) + "." + (ipAddress >> 16 & 0xff) + "." + (ipAddress >> 24 & 0xff));
		} else {
			return getLocIP();
		}
	}

	/**
	 * 获取本机IP,非WIFI
	 */
	private static String getLocIP() {
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						return inetAddress.getHostAddress().toString();
					}
				}
			}
		} catch (SocketException ex) {
			// Log.e("WifiPreference IpAddress", ex.toString());
		}
		return "0";
	}

	/**
	 * 获取本机MAC
	 */
	public static String getLocalMacAddress(Context context) {
		WifiInfo info = null;
		try {
			WifiManager wifi = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
			info = wifi.getConnectionInfo();
			return info.getMacAddress();
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "0";
	}

	/**
	 * 打开相册
	 */
	public static void startPICK(Activity activity) {
		// Intent picture = new Intent(Intent.ACTION_PICK,
		// android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		// activity.startActivityForResult(picture, PHOTORESOULT);
		Intent intent = new Intent(Intent.ACTION_PICK, null);
		intent.setDataAndType(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
		activity.startActivityForResult(intent, PHOTORESOULT);
	}

	/**
	 * 剪切相片
	 * */
	public static void startPhotoZoom(Activity activity, Uri uri) {
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(uri, IMAGE_UNSPECIFIED);
		intent.putExtra("crop", "true");
		// aspectX aspectY 是宽高的比例
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);
		// outputX outputY 是裁剪图片宽高
		intent.putExtra("outputX", 64);
		intent.putExtra("outputY", 64);
		intent.putExtra("return-data", true);
		activity.startActivityForResult(intent, PHOTORESOULT);
	}

	/**
	 * 调起系统发短信功能
	 * 
	 * @param phoneNumber
	 * @param message
	 */
	public static void SendSMSTo(Context activity, String message) {
		Uri smsToUri = Uri.parse("smsto:");
		Intent sendIntent = new Intent(Intent.ACTION_VIEW, smsToUri);
		sendIntent.putExtra("sms_body", message);
		sendIntent.setType("vnd.android-dir/mms-sms");
		activity.startActivity(sendIntent);

	}

	/**
	 * 设置Dialog为全屏显示
	 */
	public static void setDialogFullScreen(Dialog dialog) {
		try {
			WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
			params.width = dm.widthPixels;
			params.height = dm.heightPixels;
			dialog.getWindow().setAttributes(params);
		} catch (Exception e) {
			Utils.Log("setDialogFullScreen", "ERROR");
		}

	}

	/**
	 * 判断应用是否存在
	 */
	public static boolean checkApkExist(Context context, String packageName) {
		if (packageName == null || "".equals(packageName))
			return false;
		try {
			PackageManager packageManager = context.getPackageManager();
			packageManager.getApplicationInfo(packageName, PackageManager.GET_UNINSTALLED_PACKAGES);
			return true;
		} catch (NameNotFoundException e) {
			return false;
		}
	}

	/**
	 * 运行apk
	 * 
	 * @param context
	 * @param appPackageName
	 * @param appPackageActivity
	 * @param name
	 * @param pwd
	 */
	public static void runApk(Context context, String appPackageName, String appPackageActivity, String name, String pwd) {
		Intent i = new Intent();
		i.putExtra("userid", name);
		i.putExtra("pwd", pwd);
		i.putExtra("packageName", context.getPackageName());
		i.putExtra("packageActivity", "com.activity.Activity_Hall");
		// i.setFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT);
		i.setComponent(new ComponentName(appPackageName, appPackageActivity));
		context.startActivity(i);
	}

	/**
	 * 退出弹窗界面
	 */
	public static void exitApp(final Activity activity) {
		activity.runOnUiThread(new Runnable() {
			public void run() {
				Builder dialog = new AlertDialog.Builder(activity);
				dialog.setTitle(R.string.app_name);
				dialog.setMessage(R.string.my_exit);
				dialog.setNeutralButton(R.string.my_yes, new DialogInterface.OnClickListener() {

					public void onClick(DialogInterface dialog, int which) {
						activity.finish();
						System.exit(0);
					}
				});
				dialog.setNegativeButton(R.string.my_no, null);
				dialog.show();
			}
		});
	}

	/**
	 * 获取设备UUID
	 * 
	 * @param activity
	 * @return
	 */
	public static String get_UUID(Activity activity) {
		String uuid = "";
		final TelephonyManager tm = (TelephonyManager) activity.getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);
		final String tmDevice, tmSerial, androidId;
		tmDevice = "" + tm.getDeviceId();// 所有的设备都可以返回一个
											// TelephonyManager.getDeviceId()
		tmSerial = "" + tm.getSimSerialNumber();// 所有的GSM设备
												// 可以返回一个TelephonyManager.getSimSerialNumber()&&所有的CDMA
												// 设备对于 getSimSerialNumber()
												// 却返回一个空值！
		androidId = "" + android.provider.Settings.Secure.getString(activity.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);// 所有添加有谷歌账户的设备可以返回一个
																																				// ANDROID_ID
		UUID deviceUuid = new UUID(androidId.hashCode(), ((long) tmDevice.hashCode() << 32) | tmSerial.hashCode());
		String uniqueId = deviceUuid.toString();
		String[] s = uniqueId.split("-");
		for (int i = 0; i < s.length; i++) {
			if (i != 0) {
				uuid += s[i];
			}
		}
		return uuid;
	}

	/**
	 * 验证邮箱地址是否正确
	 * 
	 * @param email
	 * @return
	 */
	public static boolean isEmail(String email) {
		boolean flag = false;
		try {
			String check = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
			Pattern regex = Pattern.compile(check);
			Matcher matcher = regex.matcher(email);
			flag = matcher.matches();
		} catch (Exception e) {
			flag = false;
		}

		return flag;
	}

	/**
	 * 验证手机号码
	 * 
	 * @param mobiles
	 * @return [0-9]{5,9}
	 */
	public static boolean isMobile(String mobiles) {
		boolean flag = false;
		try {
			Pattern p = Pattern.compile("^1(([3][0123456789])|([4][0123456789])|([5][0123456789])|([8][0123456789]))[0-9]{8}$");
			Matcher m = p.matcher(mobiles);
			flag = m.matches();
		} catch (Exception e) {
			flag = false;
		}
		return flag;
	}

	/**
	 * 判定输入汉字
	 * 
	 * @param c
	 * @return
	 */
	public static boolean isChinese(char c) {
		Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
		if (ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
				|| ub == Character.UnicodeBlock.GENERAL_PUNCTUATION || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS) {
			return true;
		}
		return false;
	}

	/**
	 * 检测String是否全是中文
	 * 
	 * @param name
	 * @return
	 */
	public boolean isChinese(String name) {
		boolean res = true;
		char[] cTemp = name.toCharArray();
		for (int i = 0; i < name.length(); i++) {
			if (!isChinese(cTemp[i])) {
				res = false;
				break;
			}
		}
		return res;
	}

	/**
	 * 获取需要POST的参数MAP
	 * 
	 * @param type
	 *            1、检测更新，2、主界面 ，3、用户登录， 4、获取单个服务 ，5、生成订单 ，6、用户反馈，7、订单查询
	 * @return
	 */
	public static HashMap<String, String> Get_Map(int type, String phone, String arr8, String arr9, String arr10, String arr11, String arr12) {
		HashMap<String, String> map = new HashMap<String, String>();
		map = get_POSTmap(phone);
		switch (type) {
		case MSG_TYPE.MAP_UPDATA:
			map.put("arr8", arr8);// 当前安卓版本数字
			break;
		case MSG_TYPE.MAP_MAIN:

			break;
		case MSG_TYPE.MAP_LOGIN:
			map.put("arr8", arr8);// 用户姓名
			break;
		case MSG_TYPE.MAP_SER_ONE:
			map.put("arr8", arr8);// 请求服务ID
			break;
		case MSG_TYPE.MAP_PAY_ORDER:
			map.put("arr8", arr8);// 用户id
			map.put("arr9", arr9);// 服务id
			map.put("arr10", arr10);// 充值金额（单位分）
			map.put("arr11", arr11);// 充值渠道(1:银联 2：支付宝)
			map.put("arr12", arr12);// 充值的IMEI
			break;
		case MSG_TYPE.MAP_USER_COMMIT:
			map.put("arr8", arr8);// 用户ID
			map.put("arr9", arr9);// 联系人
			map.put("arr10", arr10);// 联系电话
			map.put("arr11", arr11);// 内容
			map.put("arr12", arr12);// 地址
			break;
		case MSG_TYPE.MAP_PAY_CARD:
			map.put("arr8", arr8);// 订单号
			map.put("arr9", arr9);// 兑换卡号
			break;
		case MSG_TYPE.MAP_ORDER_QUERY:
			map.put("arr8", arr8);// 订单号
			break;
		case MSG_TYPE.POST_PAY_MOBILE:
			map.put("arr8", arr8);// 用户ID
			map.put("arr9", arr9);// 联系人
			map.put("arr10", arr10);// 联系电话
			break;

		default:
			break;
		}
		return map;
	}

	/**
	 * 设置应用信息
	 * 
	 * @param activity
	 */
	public static void setAppInfo(Activity activity) {
		String packageName = activity.getPackageName();
		try {
			PackageManager packageManager = activity.getPackageManager();
			PackageInfo packageInfo = packageManager.getPackageInfo(packageName, 0);
			Utils.app_Info.setVcode(packageInfo.versionCode + "");
			Utils.app_Info.setVname(packageInfo.versionName);
			Utils.app_Info.setPname(packageName);
			Utils.app_Info.setAppname((String) packageManager.getApplicationLabel(activity.getApplicationInfo()));
		} catch (NameNotFoundException e1) {
			e1.printStackTrace();
		}
	}

	/**
	 * 获取手机信息
	 * 
	 * @param activity
	 */
	@SuppressWarnings("static-access")
	public static void setPhoneInfo(Activity activity) {
		Utils.dm = new DisplayMetrics();
		Utils.dm = activity.getResources().getDisplayMetrics();
		TelManager telManager = new TelManager(activity);
		SIMCardInfo simCardInfo = new SIMCardInfo(activity);
		Build b = new Build();
		Utils.phone_Info.setUUID(Utils.get_UUID(activity));
		Utils.phone_Info.setBOARD(b.BOARD);
		Utils.phone_Info.setBRAND(b.BRAND);
		Utils.phone_Info.setCALL_STATE(telManager.getCallState() + "");
		Utils.phone_Info.setCELL_LOCATION(telManager.getCellLocation() + "");
		Utils.phone_Info.setCPU_ABI(b.CPU_ABI);
		Utils.phone_Info.setDEVICE(b.DEVICE);
		Utils.phone_Info.setDISPLAY(b.DISPLAY);
		Utils.phone_Info.setFINGERPRINT(b.FINGERPRINT);
		Utils.phone_Info.setID(b.ID);
		Utils.phone_Info.setIMEI(telManager.getDeviceId());
		Utils.phone_Info.setIMSI(simCardInfo.getSIM_IMSI());
		Utils.phone_Info.setIMSI_NAME(simCardInfo.getProvidersName());
		Utils.phone_Info.setMAC(Utils.getLocalMacAddress(activity));
		Utils.phone_Info.setMANUFACTURER(b.MANUFACTURER);
		Utils.phone_Info.setMODEL(b.MODEL);
		Utils.phone_Info.setNETWORK_TYPE(telManager.getNetworkType() + "");
		Utils.phone_Info.setPRODUCT(b.PRODUCT);
		Utils.phone_Info.setSIM_SERIAL_NUMBER(telManager.getSimSerialNumber());
		Utils.phone_Info.setTAGS(b.TAGS);
		Utils.phone_Info.setTYPE(b.TYPE);
		Utils.phone_Info.setVERSION_CODENAME(Build.VERSION.CODENAME);
		Utils.phone_Info.setVERSION_INCREMENTAL(Build.VERSION.INCREMENTAL);
		Utils.phone_Info.setVERSION_SDK(Build.VERSION.SDK);
		Utils.phone_Info.setVERSION_SDK_INT(Build.VERSION.SDK_INT + "");
		if (TextUtils.equals(Utils.phone_Info.getIMSI_NAME(), "中国移动")) {
			Utils.phone_Info.setIMSI_NAME_INT("1");
		} else if (TextUtils.equals(Utils.phone_Info.getIMSI_NAME(), "中国电信")) {
			Utils.phone_Info.setIMSI_NAME_INT("2");
		} else if (TextUtils.equals(Utils.phone_Info.getIMSI_NAME(), "中国联通")) {
			Utils.phone_Info.setIMSI_NAME_INT("3");
		}
	}

	/**
	 * 打开GPS
	 */
	public static void openGPSSettings(Activity activity) {
		LocationManager alm = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
		if (alm.isProviderEnabled(android.location.LocationManager.GPS_PROVIDER)) {
			Log2(activity, "GPS模块正常");
			return;
		}
		Log2(activity, "请开启GPS！");
		Intent intent = new Intent(Settings.ACTION_SECURITY_SETTINGS);
		activity.startActivityForResult(intent, 88555);
	}

	public static void setDisplay_TextSize(TextView v, float size) {
		v.setTextSize(size);
	}

}
