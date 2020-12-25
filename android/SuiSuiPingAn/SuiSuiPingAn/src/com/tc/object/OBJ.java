package com.tc.object;

import java.io.Serializable;
import java.util.ArrayList;

public class OBJ {

	/**
	 * ******************主界面信息对象************************************************
	 */
	@SuppressWarnings("serial")
	public static class Main_info implements Serializable {
		private String title; // 主界面标题
		private ArrayList<AD_Info> adList;// 主界面广告图片地址
		private ArrayList<Service_Info_Mini> serList;// 主界面服务列表
		private boolean insur;// 手机串号是否参保
		private String info;// 主界面返回信息
		private String status;// 主界面返回状态码

		/**
		 * 获取-----主界面标题
		 */
		public String getTitle() {
			return title;
		}

		/**
		 * 设置-----主界面标题
		 */
		public void setTitle(String title) {
			this.title = title;
		}

		/**
		 * 获取-----主界面广告图片地址
		 */
		public ArrayList<AD_Info> getAD_List() {
			return adList;
		}

		/**
		 * 设置-----主界面广告图片地址
		 */
		public void setAD_List(ArrayList<AD_Info> adList) {
			this.adList = adList;
		}

		/**
		 * 获取-----主界面服务列表
		 */
		public ArrayList<Service_Info_Mini> getSerList() {
			return serList;
		}

		/**
		 * 设置-----主界面服务列表
		 */
		public void setSerList(ArrayList<Service_Info_Mini> serList) {
			this.serList = serList;
		}

		/**
		 * 获取-----主界面返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----主界面返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----主界面返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----主界面返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

		/**
		 * 设置-----手机串号是否参保
		 */
		public boolean getInsur() {
			return insur;
		}

		/**
		 * 设置-----手机串号是否参保
		 */
		public void setInsur(boolean insur) {
			this.insur = insur;
		}

	}

	@SuppressWarnings("serial")
	public static class Service_Info_Mini implements Serializable {
		private String id;
		private String name;

		/**
		 * 获取-----服务名称
		 */
		public String getName() {
			return name;
		}

		/**
		 * 設置-----服务名称
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----服务id
		 */
		public String getId() {
			return id;
		}

		/**
		 * 設置-----服务id
		 */
		public void setId(String id) {
			this.id = id;
		}
	}

	@SuppressWarnings("serial")
	public static class AD_Info implements Serializable {
		private String img;
		private String url;

		/**
		 * 获取-----广告图片地址
		 */
		public String getImg() {
			return img;
		}

		/**
		 * 設置-----广告图片地址
		 */
		public void setImg(String img) {
			this.img = img;
		}

		/**
		 * 获取-----广告连接地址
		 */
		public String getUrl() {
			return url;
		}

		/**
		 * 設置-----广告连接地址
		 */
		public void setUrl(String url) {
			this.url = url;
		}
	}

	/*****************************************************************************************************************/
	/**
	 * 服务对象
	 */
	@SuppressWarnings("serial")
	public static class Service_Info implements Serializable {
		private String id;// 服务ID
		private String name;// 服务名称
		private String expire;// 有效期（月）
		private String price;// 价格（分）
		private String serdes;// 服务说明
		private ArrayList<Pay_Info> payinfos;// 支付类型
		private String info;// 主界面返回信息
		private String status;// 主界面返回状态码

		/**
		 * 获取-----服务对象返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----服务对象返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----服务对象返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----服务对象返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

		/**
		 * 获取-----服務ID
		 */
		public String getId() {
			return id;
		}

		/**
		 * 设置-----服務ID
		 */
		public void setId(String id) {
			this.id = id;
		}

		/**
		 * 获取-----服務名稱
		 */
		public String getName() {
			return name;
		}

		/**
		 * 设置-----服務名稱
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----服務有效期
		 */
		public String getExpire() {
			return expire;
		}

		/**
		 * 设置-----服務有效期
		 */
		public void setExpire(String expire) {
			this.expire = expire;
		}

		/**
		 * 获取-----服務價格
		 */
		public String getPrice() {
			return price;
		}

		/**
		 * 设置-----服務價格
		 */
		public void setPrice(String price) {
			this.price = price;
		}

		/**
		 * 获取-----服務說明
		 */
		public String getSerdes() {
			return serdes;
		}

		/**
		 * 设置-----服務說明
		 */
		public void setSerdes(String serdes) {
			this.serdes = serdes;
		}

		/**
		 * 获取-----支付類型
		 */
		public ArrayList<Pay_Info> getPayInfos() {
			return payinfos;
		}

		/**
		 * 设置-----支付類型
		 */
		public void setPaytype(ArrayList<Pay_Info> payinfos) {
			this.payinfos = payinfos;
		}

	}

	@SuppressWarnings("serial")
	public static class Pay_Info implements Serializable {
		private String id;
		private String name;

		/**
		 * 获取-----支付名称
		 */
		public String getName() {
			return name;
		}

		/**
		 * 設置-----支付名称
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----支付id
		 */
		public String getId() {
			return id;
		}

		/**
		 * 設置-----支付id
		 */
		public void setId(String id) {
			this.id = id;
		}
	}

	/**
	 * 用戶信息
	 */
	@SuppressWarnings("serial")
	public static class User_Info implements Serializable {
		private String id; // 用戶id
		private String name; // 用戶姓名
		private String phone; // 用户手机号
		private String imei; // 设备的IMEI
		private String tel; // 服务商0：未知 1：移动 2：电信 3：联通
		private String mach; // 设备编号 安卓11
		private String hb; // 紅包数量
		private String level; // 等級
		private String vippoints; // VIP积分
		private String vippointsot; // VIP积分过期时间
		private String dtime; // 注册时间
		private String ltime; // 最后登录时间
		private String regip; // 注册ip
		private String shengyuRMB; // 剩余购机款
		private String loginnum; // 登录次数
		private String info;// 主界面返回信息
		private String status;// 主界面返回状态码
		private ArrayList<Service_Info_Order> orders;

		/**
		 * 获取-----用户返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----用户返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----用户返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----用户返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

		/**
		 * 获取-----用戶id
		 */
		public String getId() {
			return id;
		}

		/**
		 * 设置-----用戶id
		 */
		public void setId(String id) {
			this.id = id;
		}

		/**
		 * 获取-----用戶姓名
		 */
		public String getName() {
			return name;
		}

		/**
		 * 设置-----用戶姓名
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----用户手机号
		 */

		public String getPhone() {
			return phone;
		}

		/**
		 * 设置-----用户手机号
		 */

		public void setPhone(String phone) {
			this.phone = phone;
		}

		/**
		 * 获取-----设备的IMEI
		 */

		public String getImei() {
			return imei;
		}

		/**
		 * 设置-----设备的IMEI
		 */

		public void setImei(String imei) {
			this.imei = imei;
		}

		/**
		 * 获取-----服务商*--*0：未知 1：移动 2：电信 3：联通
		 */

		public String getTel() {
			return tel;
		}

		/**
		 * 设置-----服务商*--*0：未知 1：移动 2：电信 3：联通
		 */

		public void setTel(String tel) {
			this.tel = tel;
		}

		/**
		 * 获取-----设备编号*--*安卓11
		 */

		public String getMach() {
			return mach;
		}

		/**
		 * 设置-----设备编号*--*安卓11
		 */

		public void setMach(String mach) {
			this.mach = mach;
		}

		/**
		 * 获取-----紅包数量
		 */

		public String getHb() {
			return hb;
		}

		/**
		 * 设置-----紅包数量
		 */

		public void setHb(String hb) {
			this.hb = hb;
		}

		/**
		 * 获取-----等級
		 */

		public String getLevel() {
			return level;
		}

		/**
		 * 设置-----等級
		 */

		public void setLevel(String level) {
			this.level = level;
		}

		/**
		 * 获取-----VIP积分
		 */

		public String getVippoints() {
			return vippoints;
		}

		/**
		 * 设置-----VIP积分
		 */

		public void setVippoints(String vippoints) {
			this.vippoints = vippoints;
		}

		/**
		 * 获取-----VIP积分过期时间
		 */

		public String getVippointsot() {
			return vippointsot;
		}

		/**
		 * 设置-----VIP积分过期时间
		 */

		public void setVippointsot(String vippointsot) {
			this.vippointsot = vippointsot;
		}

		/**
		 * 获取-----注册时间
		 */

		public String getDtime() {
			return dtime;
		}

		/**
		 * 设置-----注册时间
		 */

		public void setDtime(String dtime) {
			this.dtime = dtime;
		}

		/**
		 * 获取-----最后登录时间
		 */

		public String getLtime() {
			return ltime;
		}

		/**
		 * 设置-----最后登录时间
		 */

		public void setLtime(String ltime) {
			this.ltime = ltime;
		}

		/**
		 * 获取-----注册ip
		 */

		public String getRegip() {
			return regip;
		}

		/**
		 * 设置-----注册ip
		 */

		public void setRegip(String regip) {
			this.regip = regip;
		}

		/**
		 * 获取-----登录次数
		 */

		public String getLoginnum() {
			return loginnum;
		}

		/**
		 * 设置-----登录次数
		 */
		public void setLoginnum(String loginnum) {
			this.loginnum = loginnum;
		}

		public String getShengyuRMB() {
			return shengyuRMB;
		}

		public void setShengyuRMB(String shengyuRMB) {
			this.shengyuRMB = shengyuRMB;
		}

		public ArrayList<Service_Info_Order> getOrders() {
			System.out.println("orders:"+orders);
			return orders;
		}

		public void setOrders(ArrayList<Service_Info_Order> orders) {
			this.orders = orders;
		}

	}

	@SuppressWarnings("serial")
	public static class Phone_Info implements Serializable {
		private String BOARD; // 主板型号
		private String BRAND; // android系统定制商
		private String CPU_ABI; // cpu指令集
		private String DEVICE; // 设备参数
		private String DISPLAY; // 显示屏参数
		private String FINGERPRINT; // 硬件名称
		private String ID; // 修订版本列表
		private String MANUFACTURER; // 硬件制造商
		private String MODEL; // 版本
		private String PRODUCT; // 手机制造商
		private String TAGS; // 描述build的标签
		private String TYPE; // builder类型
		private String VERSION_CODENAME; // 当前开发代号
		private String VERSION_INCREMENTAL; // 源码控制版本号
		private String VERSION_RELEASE; // 版本字符串
		private String VERSION_SDK; // 版本号
		private String VERSION_SDK_INT; // 版本号
		private String MAC; // MAC地址
		private String IMEI; // IMEI 唯一的设备ID： GSM手机的 IMEI 和 CDMA手机的 MEID
		private String IMSI; // IMSI 国际移动用户识别码
		private String IMSI_NAME; // 运营商
		private String IMSI_NAME_INT; // 运营商
		private String CALL_STATE; // 电话状态
		private String CELL_LOCATION; // 电话方位
		private String NETWORK_TYPE; // 当前使用的网络类型
		private String SIM_SERIAL_NUMBER; // SIM卡的序列号
		private String UUID; // 生成的唯一设备号

		/**
		 * 获取-----主板型号
		 */
		public String getBOARD() {
			return BOARD;
		}

		/**
		 * 设置-----主板型号
		 */
		public void setBOARD(String bOARD) {
			BOARD = bOARD;
		}

		/**
		 * 获取-----android系统定制商
		 */
		public String getBRAND() {
			return BRAND;
		}

		/**
		 * 设置-----android系统定制商
		 */
		public void setBRAND(String bRAND) {
			BRAND = bRAND;
		}

		/**
		 * 获取-----cpu指令集
		 */
		public String getCPU_ABI() {
			return CPU_ABI;
		}

		/**
		 * 设置-----cpu指令集
		 */
		public void setCPU_ABI(String cPU_ABI) {
			CPU_ABI = cPU_ABI;
		}

		/**
		 * 获取-----设备参数
		 */
		public String getDEVICE() {
			return DEVICE;
		}

		/**
		 * 设置-----设备参数
		 */
		public void setDEVICE(String dEVICE) {
			DEVICE = dEVICE;
		}

		/**
		 * 获取-----显示屏参数
		 */
		public String getDISPLAY() {
			return DISPLAY;
		}

		/**
		 * 设置-----显示屏参数
		 */
		public void setDISPLAY(String dISPLAY) {
			DISPLAY = dISPLAY;
		}

		/**
		 * 获取-----硬件名称
		 */
		public String getFINGERPRINT() {
			return FINGERPRINT;
		}

		/**
		 * 设置-----硬件名称
		 */
		public void setFINGERPRINT(String fINGERPRINT) {
			FINGERPRINT = fINGERPRINT;
		}

		/**
		 * 获取-----修订版本列表
		 */
		public String getID() {
			return ID;
		}

		/**
		 * 设置-----修订版本列表
		 */
		public void setID(String iD) {
			ID = iD;
		}

		/**
		 * 获取-----硬件制造商
		 */
		public String getMANUFACTURER() {
			return MANUFACTURER;
		}

		/**
		 * 设置-----硬件制造商
		 */
		public void setMANUFACTURER(String mANUFACTURER) {
			MANUFACTURER = mANUFACTURER;
		}

		/**
		 * 获取-----版本
		 */
		public String getMODEL() {
			return MODEL;
		}

		/**
		 * 设置-----版本
		 */
		public void setMODEL(String mODEL) {
			MODEL = mODEL;
		}

		/**
		 * 获取----- 手机制造商
		 */
		public String getPRODUCT() {
			return PRODUCT;
		}

		/**
		 * 设置----- 手机制造商
		 */
		public void setPRODUCT(String pRODUCT) {
			PRODUCT = pRODUCT;
		}

		/**
		 * 获取-----描述build的标签
		 */
		public String getTAGS() {
			return TAGS;
		}

		/**
		 * 设置-----描述build的标签
		 */
		public void setTAGS(String tAGS) {
			TAGS = tAGS;
		}

		/**
		 * 获取-----builder类型
		 */
		public String getTYPE() {
			return TYPE;
		}

		/**
		 * 设置-----builder类型
		 */
		public void setTYPE(String tYPE) {
			TYPE = tYPE;
		}

		/**
		 * 获取-----当前开发代号
		 */
		public String getVERSION_CODENAME() {
			return VERSION_CODENAME;
		}

		/**
		 * 设置-----当前开发代号
		 */
		public void setVERSION_CODENAME(String vERSION_CODENAME) {
			VERSION_CODENAME = vERSION_CODENAME;
		}

		/**
		 * 获取-----源码控制版本号
		 */
		public String getVERSION_INCREMENTAL() {
			return VERSION_INCREMENTAL;
		}

		/**
		 * 设置-----源码控制版本号
		 */
		public void setVERSION_INCREMENTAL(String vERSION_INCREMENTAL) {
			VERSION_INCREMENTAL = vERSION_INCREMENTAL;
		}

		/**
		 * 获取-----版本字符串
		 */
		public String getVERSION_RELEASE() {
			return VERSION_RELEASE;
		}

		/**
		 * 设置-----版本字符串
		 */
		public void setVERSION_RELEASE(String vERSION_RELEASE) {
			VERSION_RELEASE = vERSION_RELEASE;
		}

		/**
		 * 获取-----版本号
		 */
		public String getVERSION_SDK() {
			return VERSION_SDK;
		}

		/**
		 * 设置-----版本号
		 */
		public void setVERSION_SDK(String vERSION_SDK) {
			VERSION_SDK = vERSION_SDK;
		}

		/**
		 * 获取-----版本号
		 */
		public String getVERSION_SDK_INT() {
			return VERSION_SDK_INT;
		}

		/**
		 * 设置-----版本号
		 */
		public void setVERSION_SDK_INT(String vERSION_SDK_INT) {
			VERSION_SDK_INT = vERSION_SDK_INT;
		}

		/**
		 * 获取-----MAC地址
		 */
		public String getMAC() {
			return MAC;
		}

		/**
		 * 设置-----MAC地址
		 */
		public void setMAC(String mAC) {
			MAC = mAC;
		}

		/**
		 * 获取-----IMEI 唯一的设备ID： GSM手机的 IMEI 和 CDMA手机的 MEID
		 */
		public String getIMEI() {
			return IMEI;
		}

		/**
		 * 设置-----IMEI 唯一的设备ID： GSM手机的 IMEI 和 CDMA手机的 MEID
		 */
		public void setIMEI(String iMEI) {
			IMEI = iMEI;
		}

		/**
		 * 获取-----IMSI 国际移动用户识别码
		 */
		public String getIMSI() {
			return IMSI;
		}

		/**
		 * 设置-----IMSI 国际移动用户识别码
		 */
		public void setIMSI(String iMSI) {
			IMSI = iMSI;
		}

		/**
		 * 获取-----运营商
		 */
		public String getIMSI_NAME() {
			return IMSI_NAME;
		}

		/**
		 * 设置-----运营商
		 */
		public void setIMSI_NAME(String iMSI_NAME) {
			IMSI_NAME = iMSI_NAME;
		}

		/**
		 * 获取-----电话状态
		 */
		public String getCALL_STATE() {
			return CALL_STATE;
		}

		/**
		 * 设置-----电话状态
		 */
		public void setCALL_STATE(String cALL_STATE) {
			CALL_STATE = cALL_STATE;
		}

		/**
		 * 获取-----电话方位
		 */
		public String getCELL_LOCATION() {
			return CELL_LOCATION;
		}

		/**
		 * 设置-----电话方位
		 */
		public void setCELL_LOCATION(String cELL_LOCATION) {
			CELL_LOCATION = cELL_LOCATION;
		}

		/**
		 * 获取-----当前使用的网络类型
		 */
		public String getNETWORK_TYPE() {
			return NETWORK_TYPE;
		}

		/**
		 * 设置-----当前使用的网络类型
		 */
		public void setNETWORK_TYPE(String nETWORK_TYPE) {
			NETWORK_TYPE = nETWORK_TYPE;
		}

		/**
		 * 获取-----SIM卡的序列号
		 */
		public String getSIM_SERIAL_NUMBER() {
			return SIM_SERIAL_NUMBER;
		}

		/**
		 * 设置-----SIM卡的序列号
		 */
		public void setSIM_SERIAL_NUMBER(String sIM_SERIAL_NUMBER) {
			SIM_SERIAL_NUMBER = sIM_SERIAL_NUMBER;
		}

		/**
		 * 获取-----运营商
		 */

		public String getIMSI_NAME_INT() {
			return IMSI_NAME_INT;
		}

		/**
		 * 设置-----运营商
		 */
		public void setIMSI_NAME_INT(String iMSI_NAME_INT) {
			IMSI_NAME_INT = iMSI_NAME_INT;
		}

		public String getUUID() {
			return UUID;
		}

		public void setUUID(String uUID) {
			UUID = uUID;
		}

	}

	/**
	 * 订单对象
	 */
	@SuppressWarnings("serial")
	public static class Order_Info implements Serializable {
		private String uid;// 用户ID
		private String sid;// 服务ID
		private String imei;// 设备imei号
		private String prize;// 充值金额
		private String dtime;// 支付时间
		private String state;// 订单状态（0：未支付，1：已支付）
		private String sp;// 来源
		private String usp;// 充值渠道(1:银联 2：支付宝)
		private String orderid;// 订单号
		private String orderidrn;// 第三方订单号
		private String info;// 订单返回信息
		private String status;// 订单返回状态码
		private String name;// 订单名称
		private ArrayList<Service_Info_Order> orders;

		/**
		 * 获取-----订单名称
		 */
		public String getName() {
			return name;
		}

		/**
		 * 设置-----订单名称
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----用户ID
		 */
		public String getUid() {
			return uid;
		}

		/**
		 * 设置-----用户ID
		 */
		public void setUid(String uid) {
			this.uid = uid;
		}

		/**
		 * 获取-----服务ID
		 */
		public String getSid() {
			return sid;
		}

		/**
		 * 设置-----服务ID
		 */
		public void setSid(String sid) {
			this.sid = sid;
		}

		/**
		 * 获取-----设备imei号
		 */
		public String getImei() {
			return imei;
		}

		/**
		 * 设置-----设备imei号
		 */
		public void setImei(String imei) {
			this.imei = imei;
		}

		/**
		 * 获取-----充值金额
		 */
		public String getPrize() {
			return prize;
		}

		/**
		 * 设置-----充值金额
		 */
		public void setPrize(String prize) {
			this.prize = prize;
		}

		/**
		 * 获取-----支付时间
		 */
		public String getDtime() {
			return dtime;
		}

		/**
		 * 设置-----支付时间
		 */
		public void setDtime(String dtime) {
			this.dtime = dtime;
		}

		/**
		 * 获取-----订单状态（0：未支付，1：已支付）
		 */
		public String getState() {
			return state;
		}

		/**
		 * 设置-----订单状态（0：未支付，1：已支付）
		 */
		public void setState(String state) {
			this.state = state;
		}

		/**
		 * 获取-----用户来源
		 */
		public String getSp() {
			return sp;
		}

		/**
		 * 设置-----用户来源
		 */
		public void setSp(String sp) {
			this.sp = sp;
		}

		/**
		 * 获取-----充值渠道(1:银联 2：支付宝)
		 */
		public String getUsp() {
			return usp;
		}

		/**
		 * 设置-----充值渠道(1:银联 2：支付宝)
		 */
		public void setUsp(String usp) {
			this.usp = usp;
		}

		/**
		 * 获取-----订单号
		 */
		public String getOrderid() {
			return orderid;
		}

		/**
		 * 设置-----订单号
		 */
		public void setOrderid(String orderid) {
			this.orderid = orderid;
		}

		/**
		 * 获取-----第三方订单号
		 */
		public String getOrderidrn() {
			return orderidrn;
		}

		/**
		 * 设置-----第三方订单号
		 */
		public void setOrderidrn(String orderidrn) {
			this.orderidrn = orderidrn;
		}

		/**
		 * 获取-----订单返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----订单返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----订单返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----订单返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

		public ArrayList<Service_Info_Order> getOrders() {
			return orders;
		}

		public void setOrders(ArrayList<Service_Info_Order> orders) {
			this.orders = orders;
		}

	}

	/**
	 * 用户反馈返回对象
	 */
	@SuppressWarnings("serial")
	public static class ReCommit_Info implements Serializable {
		private String uid;// 用户ID
		private String name;// 用户姓名
		private String phone;// 联系方式
		private String content;// 反馈内容
		private String address;// 联系地址
		private String dtime;// 产生时间
		private String info;// 用户反馈返回信息
		private String status;// 用户反馈返回状态码

		/**
		 * 获取-----用户ID
		 */
		public String getUid() {
			return uid;
		}

		/**
		 * 设置-----用户ID
		 */
		public void setUid(String uid) {
			this.uid = uid;
		}

		/**
		 * 获取-----用户姓名
		 */
		public String getName() {
			return name;
		}

		/**
		 * 设置-----用户姓名
		 */
		public void setName(String name) {
			this.name = name;
		}

		/**
		 * 获取-----联系方式
		 */
		public String getPhone() {
			return phone;
		}

		/**
		 * 设置-----联系方式
		 */
		public void setPhone(String phone) {
			this.phone = phone;
		}

		/**
		 * 获取----- 反馈内容
		 */
		public String getContent() {
			return content;
		}

		/**
		 * 设置----- 反馈内容
		 */
		public void setContent(String content) {
			this.content = content;
		}

		/**
		 * 获取-----联系地址
		 */
		public String getAddress() {
			return address;
		}

		/**
		 * 设置-----联系地址
		 */
		public void setAddress(String address) {
			this.address = address;
		}

		/**
		 * 获取-----产生时间
		 */
		public String getDtime() {
			return dtime;
		}

		/**
		 * 设置-----产生时间
		 */
		public void setDtime(String dtime) {
			this.dtime = dtime;
		}

		/**
		 * 获取----- 用户反馈返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置----- 用户反馈返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----用户反馈返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----用户反馈返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

	}

	/**
	 * 更新信息对象
	 */
	@SuppressWarnings("serial")
	public static class Updata_Info implements Serializable {
		private String id;// 设备类型mach
		private String minver;// 最低版本
		private String maxver;// 最高版本
		private String uprand;// 兼容更新概率
		private String appname;// 应用包名
		private String vername;// 更新版本
		private String url;// 下载包地址
		private String url_img;// 二维码下载地址
		private String invite;// 短信分享内容
		private String mall_pack;// 商城包名
		private String mall_class;// 商城启动类名
		private String mall_url;// 商城下载地址
		private String dinfo;// 更新说明
		private String upstate;// 更新类型（0:不更新1：强制更新）
		private String info;// 订单返回信息
		private String status;// 订单返回状态码
		private String insur_info;// 用户须知

		/**
		 * 获取-----设备类型mach
		 */
		public String getId() {
			return id;
		}

		/**
		 * 设置-----设备类型mach
		 */
		public void setId(String id) {
			this.id = id;
		}

		/**
		 * 获取-----最低版本
		 */
		public String getMinver() {
			return minver;
		}

		/**
		 * 设置-----最低版本
		 */
		public void setMinver(String minver) {
			this.minver = minver;
		}

		/**
		 * 获取-----最高版本
		 */
		public String getMaxver() {
			return maxver;
		}

		/**
		 * 设置-----最高版本
		 */
		public void setMaxver(String maxver) {
			this.maxver = maxver;
		}

		/**
		 * 获取-----兼容更新概率
		 */
		public String getUprand() {
			return uprand;
		}

		/**
		 * 设置-----兼容更新概率
		 */
		public void setUprand(String uprand) {
			this.uprand = uprand;
		}

		/**
		 * 获取-----应用包名
		 */
		public String getAppname() {
			return appname;
		}

		/**
		 * 设置-----应用包名
		 */
		public void setAppname(String appname) {
			this.appname = appname;
		}

		/**
		 * 获取-----更新版本
		 */
		public String getVername() {
			return vername;
		}

		/**
		 * 设置-----更新版本
		 */
		public void setVername(String vername) {
			this.vername = vername;
		}

		/**
		 * 获取-----下载地址
		 */
		public String getUrl() {
			return url;
		}

		/**
		 * 设置-----下载地址
		 */
		public void setUrl(String url) {
			this.url = url;
		}

		/**
		 * 获取-----更新说明
		 */
		public String getDinfo() {
			return dinfo;
		}

		/**
		 * 设置-----更新说明
		 */
		public void setDinfo(String dinfo) {
			this.dinfo = dinfo;
		}

		/**
		 * 获取-----更新类型（0:不更新1：强制更新）
		 */
		public String getUpstate() {
			return upstate;
		}

		/**
		 * 设置-----更新类型（0:不更新1：强制更新）
		 */
		public void setUpstate(String upstate) {
			this.upstate = upstate;
		}

		/**
		 * 获取-----更新返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----更新返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----更新返回状态码
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----更新返回状态码
		 */
		public void setStatus(String status) {
			this.status = status;
		}

		/**
		 * 获取-----二维码下载地址
		 */
		public String getUrl_img() {
			return url_img;
		}

		/**
		 * 设置-----二维码下载地址
		 */
		public void setUrl_img(String url_img) {
			this.url_img = url_img;
		}

		/**
		 * 获取-----短信分享内容
		 */
		public String getInvite() {
			return invite;
		}

		/**
		 * 设置-----二维码下载地址
		 */
		public void setInvite(String invite) {
			this.invite = invite;
		}

		public String getMall_pack() {
			return mall_pack;
		}

		public void setMall_pack(String mall_pack) {
			this.mall_pack = mall_pack;
		}

		public String getMall_class() {
			return mall_class;
		}

		public void setMall_class(String mall_class) {
			this.mall_class = mall_class;
		}

		public String getMall_url() {
			return mall_url;
		}

		public void setMall_url(String mall_url) {
			this.mall_url = mall_url;
		}

		public String getInsur_info() {
			return insur_info;
		}

		public void setInsur_info(String insur_info) {
			this.insur_info = insur_info;
		}

	}

	/**
	 * 支付宝提交对象
	 */
	@SuppressWarnings("serial")
	public static class AlixPay_Info implements Serializable {
		private String title;// 标题
		private String infos;// 内容
		private String price;// 价钱
		private String notifyUrl;// 回调地址
		private String orderid;// 订单号

		/**
		 * 获取----- 标题
		 */
		public String getTitle() {
			return title;
		}

		/**
		 * 设置----- 标题
		 */
		public void setTitle(String title) {
			this.title = title;
		}

		/**
		 * 获取-----内容
		 */
		public String getInfos() {
			return infos;
		}

		/**
		 * 设置-----内容
		 */
		public void setInfos(String infos) {
			this.infos = infos;
		}

		/**
		 * 获取----- 价钱
		 */
		public String getPrice() {
			return price;
		}

		/**
		 * 设置----- 价钱
		 */
		public void setPrice(String price) {
			this.price = price;
		}

		/**
		 * 获取-----回调地址
		 */
		public String getNotifyUrl() {
			return notifyUrl;
		}

		/**
		 * 设置-----回调地址
		 */
		public void setNotifyUrl(String notifyUrl) {
			this.notifyUrl = notifyUrl;
		}

		/**
		 * 获取-----订单号
		 */
		public String getOrderid() {
			return orderid;
		}

		/**
		 * 设置-----订单号
		 */

		public void setOrderid(String orderid) {
			this.orderid = orderid;
		}

	}

	/**
	 * 查询订单对象
	 */
	@SuppressWarnings("serial")
	public static class Order_Query_Info implements Serializable {
		private String orderid;// 返回的订单号
		private String state;// 订单状态码，暂时无用
		private String info;// 订单返回信息
		private String status;// 订单返回状态码 0、已支付，1、订单状态为：未支付

		/**
		 * 获取-----返回的订单号
		 */
		public String getOrderid() {
			return orderid;
		}

		/**
		 * 设置-----返回的订单号
		 */
		public void setOrderid(String orderid) {
			this.orderid = orderid;
		}

		/**
		 * 获取-----订单状态码
		 */
		public String getState() {
			return state;
		}

		/**
		 * 设置-----订单状态码
		 */
		public void setState(String state) {
			this.state = state;
		}

		/**
		 * 获取-----订单返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----订单返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----订单返回状态码 0、已支付，1、订单状态为：未支付
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----订单返回状态码 0、已支付，1、订单状态为：未支付
		 */
		public void setStatus(String status) {
			this.status = status;
		}

	}

	/**
	 * 充值卡充值成功对象
	 */
	@SuppressWarnings("serial")
	public static class Pay_Card_Info implements Serializable {
		private String info;// 充值卡返回信息
		private String status;// 充值卡返回状态码 0、已支付，1、订单状态为：未支付

		/**
		 * 获取-----充值卡返回信息
		 */
		public String getInfo() {
			return info;
		}

		/**
		 * 设置-----充值卡返回信息
		 */
		public void setInfo(String info) {
			this.info = info;
		}

		/**
		 * 获取-----充值卡返回状态码 0、已支付，1、订单状态为：未支付
		 */
		public String getStatus() {
			return status;
		}

		/**
		 * 设置-----充值卡返回状态码 0、已支付，1、订单状态为：未支付
		 */
		public void setStatus(String status) {
			this.status = status;
		}

	}

	/**
	 * 应用信息对象
	 */
	@SuppressWarnings("serial")
	public static class APP_Info implements Serializable {
		private String vcode;// 版本号
		private String vname;// 版本代号
		private String pname;// 包名
		private String appname;// 应用名称

		/**
		 * 获取-----版本号
		 */
		public String getVcode() {
			return vcode;
		}

		/**
		 * 设置-----版本号
		 */
		public void setVcode(String vcode) {
			this.vcode = vcode;
		}

		/**
		 * 获取----- 版本代号
		 */
		public String getVname() {
			return vname;
		}

		/**
		 * 设置----- 版本代号
		 */
		public void setVname(String vname) {
			this.vname = vname;
		}

		/**
		 * 获取-----包名
		 */
		public String getPname() {
			return pname;
		}

		/**
		 * 设置-----包名
		 */
		public void setPname(String pname) {
			this.pname = pname;
		}

		/**
		 * 获取-----应用名称
		 */
		public String getAppname() {
			return appname;
		}

		/**
		 * 设置-----应用名称
		 */
		public void setAppname(String appname) {
			this.appname = appname;
		}
	}

	/**
	 * 应用信息对象
	 */
	@SuppressWarnings("serial")
	public static class Service_Info_Order implements Serializable {
		private String expire;// 结束时间
		private String imei;// 参保的imei
		private String dtime;// 开始时间

		public String getExpire() {
			return expire;
		}

		public void setExpire(String expire) {
			this.expire = expire;
		}

		public String getImei() {
			return imei;
		}

		public void setImei(String imei) {
			this.imei = imei;
		}

		public String getDtime() {
			return dtime;
		}

		public void setDtime(String dtime) {
			this.dtime = dtime;
		}

	}

}
