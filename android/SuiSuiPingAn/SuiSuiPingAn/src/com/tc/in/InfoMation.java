package com.tc.in;

import android.os.Environment;

public class InfoMation {
	public static String T = "http://app.youmsj.cn/";
	/** SP名称 */
	public static String SPNAME = "SuiPinB";
	/** 日志开关 */
	public static boolean LOG_TYPE = true;
	/** 商户编号 */
	public final static String SP = "0";
	/** 续保服务的id号 */
	public static String XUBAO_ID = "1";
	/** 支付 */
	public static boolean PAY_FLAG = false;
	/** 檢測更新接口 */
	public static String URL_UPDATA = T + "updata/index.html";
	/** 主界面接口 */
	public static String URL_MAIN = T + "index.html";
	/** 协议地址 */
	public static String URL_XIEYI = T + "info/about.html";
	/** 注册登录接口 */
	public static String URL_LOGIN = T + "login.html";
	/** 获取单个服务接口 */
	public static String URL_SER = T + "index/content.html";
	/** 反馈信息接口 */
	public static String URL_SEND = T + "feedBack/index.html";
	/** 点卡接口 */
	public static String URL_PAY_CARD = T + "ordern/cardCallBack.html";
	/** 生成订单接口 */
	public static String URL_PAYORDER = T + "ordern/index.html";
	/** 订单查询接口 */
	public static String URL_PAYO_QUERY = T + "ordern/searchorder.html";
	/** 支付宝回调接口 */
	public static String URL_ALI_NOTIFY = T + "ordern/alipaymobilenotify.html";
	/**话费代付通知接口*/
	public static String URL_PAY_MOBILE = T + "HfOrder.html";
	/** 私有KEY */
	public static String PrivateKEY = "#i-aola+youx@a.d|bwid_1s*ds&d^ada%da!as~iph(asdn?ak}g";
	/** SD卡位置 **/
	public final static String SD_PATH_ROOT = Environment.getExternalStorageDirectory().getAbsolutePath() + "/";
	public final static String APP_PATH = SD_PATH_ROOT + "SuiPinB/";
	public final static String APP_IMG_PATH = APP_PATH + "img/";
	public final static String APP_APP_PATH = APP_PATH + "app/";
	public final static String APP_DOWN_PATH = APP_PATH + "down/";
}
