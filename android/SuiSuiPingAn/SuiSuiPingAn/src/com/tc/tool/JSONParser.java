package com.tc.tool;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tc.object.OBJ.AD_Info;
import com.tc.object.OBJ.Main_info;
import com.tc.object.OBJ.Order_Info;
import com.tc.object.OBJ.Order_Query_Info;
import com.tc.object.OBJ.Pay_Card_Info;
import com.tc.object.OBJ.Pay_Info;
import com.tc.object.OBJ.ReCommit_Info;
import com.tc.object.OBJ.Service_Info;
import com.tc.object.OBJ.Service_Info_Mini;
import com.tc.object.OBJ.Service_Info_Order;
import com.tc.object.OBJ.Updata_Info;
import com.tc.object.OBJ.User_Info;

import android.os.Handler;
import android.text.TextUtils;

/**
 * @see <b>主要作用：用来解析用户的XML文件，可以通过getUserInfo获取UserInfo信息</b>
 * @author 罗超
 */
public class JSONParser {
	/**
	 * 解析主界面信息
	 * 
	 * @return MAINobj
	 */
	public static Main_info ParseJson_Main(Handler handler, String jsonString) {
		Main_info mObj = new Main_info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				mObj.setInfo(mainJson.optString("info"));// 设置info
				mObj.setStatus(mainJson.optString("status"));// 设置 status
				JSONObject dataObject = mainJson.getJSONObject("data");
				mObj.setTitle(dataObject.optString("title"));// 设置标题
				if (dataObject.isNull("insur")) {
					mObj.setInsur(false);
				}
				if (dataObject.optString("insur").equals("1")) {
					mObj.setInsur(true);
				} else {
					mObj.setInsur(false);
				}
				JSONArray imgArray = dataObject.getJSONArray("img");
				ArrayList<AD_Info> adList = new ArrayList<AD_Info>();
				for (int i = 0; i < imgArray.length(); i++) {
					JSONObject object = imgArray.getJSONObject(i);
					AD_Info info = new AD_Info();
					info.setImg(object.optString("img"));
					info.setUrl(object.optString("url"));
					adList.add(info);
				}
				mObj.setAD_List(adList);// 设置图片地址array
				JSONArray serArray = dataObject.getJSONArray("services");
				ArrayList<Service_Info_Mini> sers = new ArrayList<Service_Info_Mini>();
				for (int i = 0; i < serArray.length(); i++) {
					Service_Info_Mini ser_mini = new Service_Info_Mini();
					JSONObject s = serArray.getJSONObject(i);
					ser_mini.setName(s.optString("name"));
					ser_mini.setId(s.optString("id"));
					sers.add(ser_mini);
				}
				mObj.setSerList(sers);// 设置服务列表
				Utils.main_info = mObj;
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【主界面】出错");
			}

		}
		return mObj;
	}

	/**
	 * 解析用户信息
	 * 
	 * @return User_Info
	 */
	public static User_Info ParseJson_User(String jsonString) {
		User_Info user_Info = new User_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				user_Info.setInfo(mainJson.optString("info"));// 设置info
				user_Info.setStatus(mainJson.optString("status"));// 设置 status
				JSONObject dataObject = mainJson.getJSONObject("data");
				JSONObject userinfoObject = dataObject.getJSONObject("userinfo");
				user_Info.setId(userinfoObject.optString("id"));
				user_Info.setName(userinfoObject.optString("name"));
				user_Info.setPhone(userinfoObject.optString("phone"));
				user_Info.setImei(userinfoObject.optString("imei"));
				user_Info.setTel(userinfoObject.optString("tel"));
				user_Info.setMach(userinfoObject.optString("mach"));
				user_Info.setHb(userinfoObject.optString("hb"));
				user_Info.setShengyuRMB(userinfoObject.optString("money"));
				user_Info.setLevel(userinfoObject.optString("level"));
				user_Info.setVippoints(userinfoObject.optString("vippoints"));
				user_Info.setVippointsot(userinfoObject.optString("vippointsot"));
				user_Info.setDtime(userinfoObject.optString("dtime"));
				user_Info.setLtime(userinfoObject.optString("ltime"));
				user_Info.setRegip(userinfoObject.optString("regip"));
				user_Info.setLoginnum(userinfoObject.optString("loginnum"));
				if (!dataObject.isNull("insur") && !dataObject.optString("insur").equals("0")) {
					JSONArray myOrders = dataObject.getJSONArray("insur");
					ArrayList<Service_Info_Order> myOrder_Infos = new ArrayList<Service_Info_Order>();
					for (int i = 0; i < myOrders.length(); i++) {
						Service_Info_Order myOrder_Info = new Service_Info_Order();
						JSONObject oder = myOrders.getJSONObject(i);
						myOrder_Info.setImei(oder.optString("imei"));
						myOrder_Info.setDtime(oder.optString("dtime"));
						myOrder_Info.setExpire(oder.optString("expire"));
						myOrder_Infos.add(myOrder_Info);
					}
					user_Info.setOrders(myOrder_Infos);
				} else {

				}
				Utils.user_Info = user_Info;
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_User", "解析【用户】出错");
			}
		}
		return user_Info;
	}

	/**
	 * 解析单个服务信息
	 * 
	 * @return Service_Info
	 */
	public static Service_Info ParseJson_Service(String jsonString) {
		Service_Info service_Info = new Service_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				service_Info.setInfo(mainJson.optString("info"));// 设置info
				service_Info.setStatus(mainJson.optString("status"));// 设置
																		// status
				JSONObject dataObject = mainJson.getJSONObject("data");
				service_Info.setId(dataObject.optString("id"));
				service_Info.setName(dataObject.optString("name"));
				service_Info.setExpire(dataObject.optString("expire"));
				service_Info.setPrice(dataObject.optString("price"));
				service_Info.setSerdes(dataObject.optString("serdes"));
				JSONArray payInfos = dataObject.getJSONArray("paytype");
				ArrayList<Pay_Info> payinfos = new ArrayList<Pay_Info>();
				for (int i = 0; i < payInfos.length(); i++) {
					Pay_Info info = new Pay_Info();
					JSONObject oder = payInfos.getJSONObject(i);
					info.setId(oder.optString("value"));
					info.setName(oder.optString("name"));
					payinfos.add(info);
				}
				service_Info.setPaytype(payinfos);
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【单个服务】出错");
			}

		}
		return service_Info;
	}

	/**
	 * 解析用户反馈返回信息
	 * 
	 * @return Service_Info
	 */
	public static ReCommit_Info ParseJson_ReCommit(String jsonString) {
		ReCommit_Info reCommit_Info = new ReCommit_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				reCommit_Info.setInfo(mainJson.optString("info"));// 设置info
				reCommit_Info.setStatus(mainJson.optString("status"));// 设置
																		// status
				JSONObject dataObject = mainJson.getJSONObject("data");
				reCommit_Info.setUid(dataObject.optString("uid"));
				reCommit_Info.setName(dataObject.optString("name"));
				reCommit_Info.setPhone(dataObject.optString("phone"));
				reCommit_Info.setContent(dataObject.optString("content"));
				reCommit_Info.setAddress(dataObject.optString("address"));
				reCommit_Info.setDtime(dataObject.optString("dtime"));
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【用户反馈返回】出错");
			}

		}
		return reCommit_Info;
	}

	/**
	 * 解析訂單信息
	 * 
	 * @return Service_Info
	 */
	public static Order_Info ParseJson_Order(String jsonString) {
		Order_Info order_Info = new Order_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				order_Info.setInfo(mainJson.optString("info"));// 设置info
				order_Info.setStatus(mainJson.optString("status"));// 设置
																	// status
				JSONObject dataObject = mainJson.getJSONObject("data");
				order_Info.setUid(dataObject.optString("uid"));
				order_Info.setSid(dataObject.optString("sid"));
				order_Info.setImei(dataObject.optString("imei"));
				order_Info.setPrize(dataObject.optString("prize"));
				order_Info.setDtime(dataObject.optString("dtime"));
				order_Info.setState(dataObject.optString("state"));
				order_Info.setSp(dataObject.optString("sp"));
				order_Info.setUsp(dataObject.optString("usp"));
				order_Info.setOrderid(dataObject.optString("orderid"));
				order_Info.setOrderidrn(dataObject.optString("orderidrn"));
				order_Info.setName(dataObject.optString("name"));
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【订单】出错");
			}

		}
		return order_Info;
	}

	/**
	 * 更新
	 * 
	 * @return Service_Info
	 */
	public static Updata_Info ParseJson_Updata(String jsonString) {
		Updata_Info updata_Info = new Updata_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				updata_Info.setInfo(mainJson.optString("info"));// 设置info
				updata_Info.setStatus(mainJson.optString("status"));// 设置
				// status
				JSONObject dataObject = mainJson.getJSONObject("data");
				updata_Info.setId(dataObject.optString("id"));
				updata_Info.setMinver(dataObject.optString("minver"));
				updata_Info.setMaxver(dataObject.optString("maxver"));
				updata_Info.setUprand(dataObject.optString("uprand"));
				updata_Info.setAppname(dataObject.optString("appname"));
				updata_Info.setInvite(dataObject.optString("invite"));
				updata_Info.setUrl_img(dataObject.optString("ewm"));
				updata_Info.setVername(dataObject.optString("vername"));
				updata_Info.setMall_pack(dataObject.optString("mall_pack"));
				updata_Info.setMall_class(dataObject.optString("mall_class"));
				updata_Info.setMall_url(dataObject.optString("mall_url"));
				updata_Info.setUrl(dataObject.optString("url"));
				updata_Info.setDinfo(dataObject.optString("info"));
				updata_Info.setUpstate(dataObject.optString("upstate"));
				updata_Info.setInsur_info(dataObject.optString("insur_info"));
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【更新】出错");
			}

		}
		return updata_Info;
	}

	/**
	 * 点卡充值返回信息
	 * 
	 * @return Service_Info
	 */
	public static Pay_Card_Info ParseJson_PayCard(String jsonString) {
		Pay_Card_Info card_Info = new Pay_Card_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				card_Info.setInfo(mainJson.optString("info"));// 设置info
				card_Info.setStatus(mainJson.optString("status"));// 设置
				// status
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【点卡充值】出错");
			}

		}
		return card_Info;
	}

	/**
	 * 訂單查询信息
	 * 
	 * @return Service_Info
	 */
	public static Order_Query_Info ParseJson_OrderQuery(String jsonString) {
		Order_Query_Info query_Info = new Order_Query_Info();
		if (!TextUtils.isEmpty(jsonString)) {
			JSONObject mainJson = null;
			try {
				mainJson = new JSONObject(jsonString);
				query_Info.setInfo(mainJson.optString("info"));// 设置info
				query_Info.setStatus(mainJson.optString("status"));// 设置
				// status
				JSONObject dataObject = mainJson.getJSONObject("data");
				query_Info.setOrderid(dataObject.optString("orderid"));
				query_Info.setState(dataObject.optString("state"));
			} catch (JSONException e) {
				e.printStackTrace();
				Utils.Log("ParseJson_Main", "解析【订单查询】出错");
			}

		}
		return query_Info;
	}
}
