package com.tc.myview;

import java.util.HashMap;

import com.tc.thread.Thread_Post;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.tc.activity.Activity_Main;
import com.tc.in.InfoMation;
import com.zphl.sspa0.R;

/**
 * 支付方式列表界面
 * 
 * @author 罗超
 * 
 */
@SuppressLint({ "ViewConstructor", "HandlerLeak" })
public class View_Claim_Full extends LinearLayout implements View.OnClickListener {
	static View_Claim_Full claim;
	public static Dialog dialog_claim;
	private Button send_BTN;
	private Button return_BTN;
	private TextView claim_title;
	private TextView claim_title2;
	private TextView claim_xieyi;
	private TextView tel_TEXT;
	private EditText add_EDIT;
	private EditText tel_EDIT;
	private EditText miaosu_EDIT;
	private ImageView phone_IMG;
	// 用户输入的地址
	private String add;
	// 用户输入的手机号码
	private String tel;
	// 用户输入的描述信息
	private String miaosu;
	private Activity activity;

	public View_Claim_Full(final Context context) {
		super(context);
		activity = (Activity) context;
		V(context);
		initView();

	}

	private void V(final Context context) {
		LayoutInflater.from(context).inflate(R.layout.view_claim, this, true);

	}

	private void initView() {
		claim_xieyi = (TextView) findViewById(R.id.claim_xieyi);
		send_BTN = (Button) findViewById(R.id.claim_send_BTN);
		add_EDIT = (EditText) findViewById(R.id.claim_add_EDIT);
		tel_EDIT = (EditText) findViewById(R.id.claim_tel_EDIT);
		tel_TEXT = (TextView) findViewById(R.id.claim_tel);
		return_BTN = (Button) findViewById(R.id.claim_return_BTN);
		phone_IMG = (ImageView) findViewById(R.id.claim_phone_IMG);
		claim_title = (TextView) findViewById(R.id.caseT_claim_title);
		claim_title2 = (TextView) findViewById(R.id.caseT_claim_title2);
		miaosu_EDIT = (EditText) findViewById(R.id.claim_miaosu_EDIT);
		claim_title2.setText(Utils.main_info.getTitle());
		claim_xieyi.setText(Html.fromHtml("<u>" + activity.getApplication().getString(R.string.claim_text_xieyi) + "</u>"));

		send_BTN.setOnClickListener(this);
		phone_IMG.setOnClickListener(this);
		claim_xieyi.setOnClickListener(this);
		return_BTN.setOnClickListener(this);
		if (!TextUtils.isEmpty(Utils.user_Info.getPhone()))
			tel_EDIT.setText(Utils.user_Info.getPhone());

		StringBuffer sb = new StringBuffer();
		sb.append("(必填)请输入故障描述\n\n\n温馨提示：");
		String des = Utils.updata_Info.getInsur_info();
		// 切割字符添加更新内容
		String s1[] = des.split("\\+");
		for (String s : s1) {
			sb.append("\r\n" + s);
		}
		miaosu_EDIT.setHint(sb);

		/*********************** 适配字体 ***************************/
		if (Utils.dm.widthPixels > 950) {
			Utils.setDisplay_TextSize(claim_title, 16);
		} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
			Utils.setDisplay_TextSize(claim_title, 14);
		} else if (Utils.dm.widthPixels < 820) {
			Utils.setDisplay_TextSize(claim_title, 12);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.claim_send_BTN:
			miaosu = miaosu_EDIT.getText().toString();
			tel = tel_EDIT.getText().toString();
			add = add_EDIT.getText().toString();
			if (tel.length() < 7) {
				Utils.Toast(activity, "请输入正确的电话号码");
			} else if (add.length() < 2) {
				Utils.Toast(activity, "请输入详细的地址");
			} else if (miaosu.length() < 2) {
				Utils.Toast(activity, "请输入正确的描述信息");
			} else {
				HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_USER_COMMIT, Utils.user_Info.getPhone(), Utils.user_Info.getId(), Utils.user_Info.getName(), tel, miaosu, add);
				new Thread_Post(activity, Activity_Main.main_Handler, InfoMation.URL_SEND, map, MSG_TYPE.POST_SEND).start();
			}
			break;
		case R.id.claim_return_BTN:
			dialog_claim.dismiss();
			break;
		case R.id.claim_xieyi:
			View_Web_Full.showWeb(activity, InfoMation.URL_XIEYI);
			break;
		case R.id.claim_phone_IMG:
			// 用intent启动拨打电话
			Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + tel_TEXT.getText().toString()));
			activity.startActivity(intent);
			break;
		default:
			break;
		}

	}

	public static void dismiss() {
		if (dialog_claim != null) {
			if (dialog_claim.isShowing()) {
				dialog_claim.cancel();
			}
		}
	}

	public static void claim(final Activity act) {
		act.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				View_Claim_Full.claim = new View_Claim_Full(act);
				dialog_claim = new Dialog(act, R.style.DialogSplash1);
				dialog_claim.setContentView(View_Claim_Full.claim);
				dialog_claim.show();
				WindowManager.LayoutParams params = dialog_claim.getWindow().getAttributes();
				params.width = Utils.dm.widthPixels;
				params.height = Utils.dm.heightPixels;
				dialog_claim.getWindow().setAttributes(params);
			}
		});
	}

}
