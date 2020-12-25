package com.tc.activity;

import java.util.HashMap;

import com.tc.in.InfoMation;
import com.tc.myview.MyEditText;
import com.tc.thread.Thread_Post;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.res.Configuration;

/**
 * 用户的【登录】界面
 * 
 * @author 罗超 2014-08-15 19:10
 */
public class Activity_Regist extends Activity implements View.OnClickListener {
	private Activity activity;
	private Button regist_login;
	private Button regist_retrurn;
	private MyEditText nameEdit;
	private MyEditText phoneEdit;
	private String name;
	private String phone;
	private TextView regist_imei;
	@SuppressWarnings("unused")
	private ImageView regist_imei_read;

	@SuppressLint("HandlerLeak")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout._regist);
		activity = this;
		regist_login = (Button) findViewById(R.id.regist_login);
		regist_retrurn = (Button) findViewById(R.id.regist_retrurn);
		nameEdit = (MyEditText) findViewById(R.id.regist_name);
		phoneEdit = (MyEditText) findViewById(R.id.regist_phone);
		regist_imei = (TextView) findViewById(R.id.regist_imei);
		regist_imei.setText(Utils.phone_Info.getIMEI());
		regist_imei_read = (ImageView) findViewById(R.id.regist_imei_read);
		regist_login.setOnClickListener(this);
		regist_retrurn.setOnClickListener(this);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.regist_login:
			name = nameEdit.getText().toString();
			phone = phoneEdit.getText().toString();
			if (name.length() < 2) {
				Utils.Toast(activity, "请输入正确的姓名");
			 } else if (phone.length() < 11) {
			 Utils.Toast(activity, "请输入正确的手机号");
			 } else if (!Utils.isMobile(phone)) {
			 Utils.Toast(activity, "请输入正确的手机号");
			} else {
				InfoMation.PAY_FLAG = true;
				HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, phone, name, null, null, null, null);
				new Thread_Post(activity, Activity_Main.main_Handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
			}
			break;
		case R.id.regist_retrurn:
			Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_LOGIN);
			break;

		default:
			break;
		}

	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		// TODO Auto-generated method stub
		super.onConfigurationChanged(newConfig);
	}
}
