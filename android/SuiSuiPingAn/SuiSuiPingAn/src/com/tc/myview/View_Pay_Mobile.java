package com.tc.myview;

import java.util.HashMap;

import com.tc.activity.Activity_Main;
import com.tc.in.InfoMation;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;
import com.tc.thread.Thread_Post;
import com.zphl.sspa0.R;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class View_Pay_Mobile extends LinearLayout implements OnClickListener {
	
	static View_Pay_Mobile view_pay_mobile;
	public static Dialog dialog_pay_mobile;
	private Button pay_mobile_ok;
	private Button pay_mobile_cancel;
	private TextView pay_mobile_info;
	public static Activity activity;

	public View_Pay_Mobile(final Context context) {
		super(context);
		initview(context);
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.pay_mobile_ok:
			System.out.println("press ok");
			InfoMation.PAY_FLAG = true;
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.POST_PAY_MOBILE, Utils.user_Info.getPhone(),Utils.user_Info.getId(), Utils.user_Info.getName(), Utils.user_Info.getPhone(), null, null);
			new Thread_Post(activity, Activity_Main.main_Handler, InfoMation.URL_PAY_MOBILE, map, MSG_TYPE.POST_PAY_MOBILE_FINISH).start();
			dialog_pay_mobile.cancel();
			break;
		case R.id.pay_mobile_cancel:
			System.out.println("press cancel");
			dialog_pay_mobile.cancel();
			break;

		default:
			break;
		}
	}
	
	private void initview(final Context context) {
		LayoutInflater.from(context).inflate(R.layout.view_pay_mobile, this, true);
		pay_mobile_ok = (Button) findViewById(R.id.pay_mobile_ok);
		pay_mobile_cancel = (Button) findViewById(R.id.pay_mobile_cancel);
		pay_mobile_ok.setOnClickListener(this);
		pay_mobile_cancel.setOnClickListener(this);
	}
	
	public static void pay(final Activity act) {
		act.runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				activity = act;
				View_Pay_Mobile.view_pay_mobile = new View_Pay_Mobile(act);
				dialog_pay_mobile = new Dialog(act, R.style.DialogSplash1);
				dialog_pay_mobile.setContentView(View_Pay_Mobile.view_pay_mobile);
				dialog_pay_mobile.show();
				WindowManager.LayoutParams params = dialog_pay_mobile.getWindow().getAttributes();
				params.width = (int) (Utils.dm.widthPixels / 1.2);
				params.height = (int) (Utils.dm.heightPixels / 3);
				dialog_pay_mobile.getWindow().setAttributes(params);
				
			}
		});
	}
	
	public static void cancel() {
		if (dialog_pay_mobile != null) {
			dialog_pay_mobile.cancel();
		}
	}

}
