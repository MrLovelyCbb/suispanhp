package com.tc.myview;

import java.util.HashMap;

import com.tc.activity.Activity_Login_YES;
import com.tc.activity.Activity_Main;
import com.tc.in.InfoMation;
import com.tc.object.OBJ.Order_Query_Info;
import com.tc.thread.Thread_Post;
import com.tc.tool.JSONParser;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;

import android.app.Activity;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;

public class PayResult {
	/**
	 * 支付回调
	 * 
	 * @param type
	 *            0、支付成功,1、支付失败,2、支付取消
	 */
	static MyProgressBar bar;
	static Handler handler;
	public static String privateOrderID;
	static Order_Query_Info query_Info;

	public static void PayRes(final Activity act, int type) {
		bar = new MyProgressBar(act);
		handler = new Handler() {

			@Override
			public void handleMessage(Message msg) {
				String res = null;
				switch (msg.what) {
				case MSG_TYPE.POST_QUERY_ORDER:
					res = msg.obj.toString();
					if (!TextUtils.isEmpty(res)) {
						query_Info = JSONParser.ParseJson_OrderQuery(res);
						try {
							if (query_Info.getStatus().equals("0")) {
								// Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_LOGIN);
								Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.CANBAO_OK);
								Activity_Login_YES.updata();
							}
						} catch (Exception e) {
							// TODO: handle exception
						}

					}
					bar.dismiss();
					break;

				default:
					break;
				}
			}
		};

		switch (type) {
		case 0:
			new CountDownTimer(5000, 1000) {
				@Override
				public void onTick(long millisUntilFinished) {
					InfoMation.PAY_FLAG = true;
					bar.show("正在查询订单");
				}

				@Override
				public void onFinish() {
					HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_ORDER_QUERY, Utils.user_Info.getPhone(), privateOrderID, null, null, null, null);
					new Thread_Post(act, handler, InfoMation.URL_PAYO_QUERY, map, MSG_TYPE.POST_QUERY_ORDER).start();
				}
			}.start();
			break;
		case 1:
			Utils.Toast(act, "支付失败");
			break;

		default:
			break;
		}

	}
}
