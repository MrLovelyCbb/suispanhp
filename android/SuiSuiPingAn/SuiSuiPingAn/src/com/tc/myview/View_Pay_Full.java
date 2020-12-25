package com.tc.myview;

import java.util.HashMap;

import com.tc.thread.Thread_Post;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.tc.activity.Activity_Main;
import com.tc.adapter.PayList_Adapter;
import com.tc.in.InfoMation;
import com.tc.object.OBJ.AlixPay_Info;
import com.tc.object.OBJ.Pay_Info;
import com.tc.object.OBJ.Service_Info;
import com.zphl.sspa0.R;

/**
 * 支付方式列表界面
 * 
 * @author 罗超
 * 
 */
@SuppressLint({ "ViewConstructor", "HandlerLeak" })
public class View_Pay_Full extends LinearLayout {
	static View_Pay_Full view_Pay_Full;
	public static Dialog dialog_pay;
	static int pay_Moeny_type;
	private TextView pay_name;
	private Button pay_payBTN;
	private Button pay_cancelBTN;
	private TextView pay_price;
	private TextView pay_title1;
	private TextView pay_title2;
	private TextView pay_xieyi;
	private ListView pay_list;
	private PayList_Adapter adapter;
	private Service_Info service_Info;
	private Pay_Info my_payInfo;
	public static String _imei;

	public View_Pay_Full(final Context context, final Service_Info service_Info) {
		super(context);
		this.service_Info = service_Info;
		V(context);
		pay_payBTN.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// 点击支付后，设置可以更新用户信息
				System.out.println("Utils.Pay_Mobile_Flag:"+Utils.Pay_Mobile_Flag);
				
				if (Utils.Pay_Mobile_Flag) {
					InfoMation.PAY_FLAG = true;
					Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.POST_PAY_MOBILE);
					dialog_pay.cancel();
				} else {
					InfoMation.PAY_FLAG = true;
					HashMap<String, String> map = new HashMap<String, String>();
					map = Utils.Get_Map(MSG_TYPE.MAP_PAY_ORDER, Utils.user_Info.getPhone(), Utils.user_Info.getId(), service_Info.getId(), service_Info.getPrice(), my_payInfo.getId(), _imei);
					new Thread_Post((Activity) context, Activity_Main.main_Handler, InfoMation.URL_PAYORDER, map, MSG_TYPE.POST_PAY).start();
					dialog_pay.cancel();
				}
			}
		});

		pay_cancelBTN.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				dialog_pay.cancel();
			}
		});

	}

	private void V(final Context context) {
		LayoutInflater.from(context).inflate(R.layout.view_pay, this, true);
		pay_name = (TextView) findViewById(R.id.pay_name);
		pay_price = (TextView) findViewById(R.id.pay_price);
		pay_xieyi = (TextView) findViewById(R.id.pay_xieyi);
		pay_title1 = (TextView) findViewById(R.id.caseT_Pay_title);
		pay_title2 = (TextView) findViewById(R.id.caseT_Pay_title2);
		pay_xieyi.setText(Html.fromHtml("<u>" + ((Activity) context).getApplication().getString(R.string.login_text_xieyi) + "</u>"));
		pay_payBTN = (Button) findViewById(R.id.pay_payBTN);
		pay_cancelBTN = (Button) findViewById(R.id.pay_cancelBTN);
		pay_list = (ListView) findViewById(R.id.pay_type_list);

		pay_title2.setText(Utils.main_info.getTitle());
		adapter = new PayList_Adapter(service_Info.getPayInfos(), context);

		pay_list.setAdapter(adapter);
		pay_xieyi.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				View_Web_Full.showWeb((Activity) context, InfoMation.URL_XIEYI);
			}
		});
		pay_list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
				my_payInfo = adapter.selected(arg2);
			}
		});

		my_payInfo = adapter.setFirstChose();
		pay_name.setText(service_Info.getName());
		int price = Integer.parseInt(service_Info.getPrice()) / 100;
		//price = 1;
		pay_price.setText("功能服务费 "+price+"元");

		if (Utils.dm.widthPixels > 950) {
			Utils.setDisplay_TextSize(pay_title1, 16);
		} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
			Utils.setDisplay_TextSize(pay_title1, 14);
		} else if (Utils.dm.widthPixels < 820) {
			Utils.setDisplay_TextSize(pay_title1, 12);
		}

	}

	public static void pay(final Activity act, final Service_Info service, final String imei) {
		act.runOnUiThread(new Runnable() {
			@SuppressWarnings("static-access")
			@Override
			public void run() {
				_imei = imei;
				view_Pay_Full.view_Pay_Full = new View_Pay_Full(act, service);
				dialog_pay = new Dialog(act, R.style.DialogSplash1);
				dialog_pay.setContentView(view_Pay_Full.view_Pay_Full);
				dialog_pay.show();
				WindowManager.LayoutParams params = dialog_pay.getWindow().getAttributes();
				params.width = Utils.dm.widthPixels;
				params.height = Utils.dm.heightPixels;
				dialog_pay.getWindow().setAttributes(params);
			}
		});
	}

	public static AlixPay_Info getAli_Info(String title, String price, String infos, String orderid) {
		AlixPay_Info alixPay_Info = new AlixPay_Info();
		alixPay_Info.setTitle(title);
		alixPay_Info.setPrice(price);
		alixPay_Info.setInfos(infos);
		alixPay_Info.setOrderid(orderid);
		alixPay_Info.setNotifyUrl(InfoMation.URL_ALI_NOTIFY);
		return alixPay_Info;
	}

}
