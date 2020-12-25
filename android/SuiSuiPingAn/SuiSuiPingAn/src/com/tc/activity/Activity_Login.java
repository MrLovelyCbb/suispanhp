package com.tc.activity;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import com.tc.db.MyPreferencesParam;
import com.tc.in.InfoMation;
import com.tc.myview.MyButton;
import com.tc.myview.MyProgressBar;
import com.tc.myview.MySpinner;
import com.tc.myview.View_Claim_Full;
import com.tc.myview.View_Pay_Full;
import com.tc.myview.View_Web_Full;
import com.tc.object.OBJ.Service_Info;
import com.tc.object.OBJ.Service_Info_Mini;
import com.tc.thread.Thread_DownApk;
import com.tc.thread.Thread_Post;
import com.tc.tool.JSONParser;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;

/**
 * 用户【未登录】时的界面
 * 
 * @author 罗超 2014-08-15 19:10
 */
public class Activity_Login extends Activity implements View.OnClickListener {
	private Activity activity;
	ArrayList<Service_Info_Mini> service_Info_Minis;
	private LinearLayout nologin;
	private MyButton nologin_loginBTN;
	private MyButton nologin_shopBTN;
	private MyButton nologin_canbaoBTN;
	private LinearLayout login;
	private MyButton login_shopBTN;
	private MyButton login_canbaoBTN;
	private MyButton login_fuwuBTN;
	private LinearLayout cblogin;
	private MyButton cblogin_loginBTN;
	private MyButton cblogin_shopBTN;
	private MyButton cblogin_fuwuBTN;
	private TextView serDes;
	private TextView nologin_imei;
	private TextView nologin_xieyi;
	private TextView nologin_canbaoflag;
	private MySpinner spinner;

	private ImageView nologin_imei_read;
	public static Handler handler;
	private Service_Info service_Info;
	// 从本地获取的用户姓名
	private String name = "";
	// 从本地获取的用户手机号
	private String mobile = "";
	private String sdPath = "";
	private MyProgressBar myProgressBar;

	// private boolean first = true;
	private TextView loginInfo;	//zhang.hx add on 2015/1/23 增加登录提示信息
	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		/* 获取之前登录的账号 */
		String[] account = MyPreferencesParam.getLoginParam(this);
		mobile = account[0];
		name = account[1];
		setContentView(R.layout._nologin);
		activity = this;
		setHander();
		initView();
		Utils.Log("Activity_Login", "onCreate");
	}

	@SuppressLint("HandlerLeak")
	private void setHander() {
		handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				case MSG_TYPE.POST_SERVICE:
					String res = msg.obj.toString();
					if (!TextUtils.isEmpty(res)) {
						service_Info = JSONParser.ParseJson_Service(res);
					}
					serDes.setText(getSerDes(service_Info.getSerdes()));
					break;
				case MSG_TYPE.POST_LOGIN:
					try {
						res = msg.obj.toString();
						// 登录过的用户，直接加载用户信息
						if (!TextUtils.isEmpty(res)) {
							Utils.user_Info = JSONParser.ParseJson_User(res);
							// 登录成功后，保存用户姓名和手机号
							mobile = Utils.user_Info.getPhone();
							name = Utils.user_Info.getName();
							if ((mobile != null) && (name != null) && (!mobile.equals("")) && (!name.equals(""))) {
								MyPreferencesParam.setLoginParam(activity, Utils.user_Info.getPhone(), Utils.user_Info.getName());
							}
							// 当用户有参保信息的时候，转到显示服务剩余时间界面
							if (Utils.user_Info.getOrders() != null) {
								Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_LOGIN_YES);
							} else {
								// if (Utils.main_info.getInsur()) {
								// nologin.setVisibility(View.GONE);
								// login.setVisibility(View.GONE);
								// cblogin.setVisibility(View.VISIBLE);
								// login_woyaofuwuBTN.setVisibility(View.VISIBLE);
								// } else {
								if (Utils.user_Info.getName() != null)
									loginInfo.setText("尊敬的用户："+Utils.user_Info.getName()+",您已登录！");
								nologin.setVisibility(View.GONE);
								login.setVisibility(View.VISIBLE);
								cblogin.setVisibility(View.GONE);
								// }
							}
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_LOGIN_ERROR);
					}
					break;
				case MSG_TYPE.THREAD_DOWN_APK_START:
					myProgressBar = new MyProgressBar(activity);
					myProgressBar.show("建立下载链接");
					break;
				case MSG_TYPE.THREAD_DOWN_APK_LOADING:
					int a = msg.arg1;// 当前进度
					myProgressBar.setText("下载:" + a + "%");
					break;
				case MSG_TYPE.THREAD_DOWN_APK_END:
					myProgressBar.dismiss();
					String fileName = sdPath;
					Intent intent = new Intent(Intent.ACTION_VIEW);
					intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.setDataAndType(Uri.fromFile(new File(fileName)), "application/vnd.android.package-archive");
					activity.startActivity(intent);
					break;
				case MSG_TYPE.THREAD_DOWN_APK_ERROR:
					Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.THREAD_DOWN_APK_ERROR);
					break;
				default:
					break;
				}
			}
		};
	}

	@Override
	protected void onResume() {
		if (InfoMation.PAY_FLAG) {
			nologin.setVisibility(View.GONE);
			login.setVisibility(View.GONE);
			cblogin.setVisibility(View.GONE);
			// 否则,直接登录,进入相对应的界面
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, Utils.user_Info.getPhone(), Utils.user_Info.getName(), null, null, null, null);
			new Thread_Post(activity, handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
			InfoMation.PAY_FLAG = false;
		}
		if ((mobile != null) && (name != null) && (!mobile.equals("")) && (!name.equals(""))) {
			nologin.setVisibility(View.GONE);
			login.setVisibility(View.GONE);
			cblogin.setVisibility(View.GONE);
			// 否则,直接登录,进入相对应的界面
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, mobile, name, null, null, null, null);
			new Thread_Post(activity, handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
		}

		if (Utils.main_info.getAD_List() == null || (Utils.main_info.getAD_List().equals(""))) {
			Intent intent = new Intent(activity, Activity_Main.class);
			startActivity(intent);
		}
		Utils.Log("Activity_Login", "onResume");
		super.onResume();
	}

	@Override
	protected void onRestart() {
		super.onRestart();
	};

	@Override
	protected void onPostResume() {
		super.onPostResume();
	}

	class SpinnerOnItemSelectedListener implements OnItemSelectedListener {

		public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
			Utils.Log2(activity, service_Info_Minis.get(arg2).getName());
		}

		public void onNothingSelected(AdapterView<?> arg0) {
		}

	}

	private StringBuffer getSerDes(String des) {
		StringBuffer sb = new StringBuffer();
		String s1[] = des.split("\\|");
		for (int i = 0; i < s1.length; i++) {
			sb.append(i + 1 + "、" + s1[i] + "\r\n");
		}
		return sb;
	}

	private void initView() {
		//zhang.hx add on 201/1/23 提示用于已经登录
		loginInfo = (TextView) findViewById(R.id.notlogin);
		
		nologin = (LinearLayout) findViewById(R.id.nologin_layout);
		nologin_loginBTN = (MyButton) findViewById(R.id.nologin_loginBTN);
		nologin_shopBTN = (MyButton) findViewById(R.id.nologin_shopBTN);
		nologin_canbaoBTN = (MyButton) findViewById(R.id.nologin_canbaoBTN);
		login = (LinearLayout) findViewById(R.id.login_layout);
		login_shopBTN = (MyButton) findViewById(R.id.login_shopBTN);
		login_canbaoBTN = (MyButton) findViewById(R.id.login_canbaoBTN);
		login_fuwuBTN = (MyButton) findViewById(R.id.login_fuwuBTN);
		cblogin = (LinearLayout) findViewById(R.id.cblogin_layout);
		cblogin_shopBTN = (MyButton) findViewById(R.id.cblogin_shopBTN);
		cblogin_fuwuBTN = (MyButton) findViewById(R.id.cblogin_fuwuBTN);
		cblogin_loginBTN = (MyButton) findViewById(R.id.cblogin_loginBTN);

		nologin_loginBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_login));
		nologin_loginBTN.setImage(R.drawable.ic_login);
		nologin_shopBTN.setText(getApplication().getResources().getString(R.string.login_btn_goto_shop));
		nologin_shopBTN.setImage(R.drawable.ic_shop);
		nologin_canbaoBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_canbao));
		nologin_canbaoBTN.setImage(R.drawable.ic_canbao);
		login_shopBTN.setText(getApplication().getResources().getString(R.string.login_btn_goto_shop));
		login_shopBTN.setImage(R.drawable.ic_shop);
		login_canbaoBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_canbao));
		login_canbaoBTN.setImage(R.drawable.ic_canbao);

		login_fuwuBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_woyaofuwu));
		login_fuwuBTN.setImage(R.drawable.ic_xiuping);

		cblogin_shopBTN.setText(getApplication().getResources().getString(R.string.login_btn_goto_shop));
		cblogin_shopBTN.setImage(R.drawable.ic_shop);
		cblogin_fuwuBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_fuwu));
		cblogin_fuwuBTN.setImage(R.drawable.ic_xiuping);
		cblogin_loginBTN.setText(getApplication().getResources().getString(R.string.nologin_btn_login));
		cblogin_loginBTN.setImage(R.drawable.ic_login);

		nologin_loginBTN.setOnClickListener(this);
		nologin_shopBTN.setOnClickListener(this);
		nologin_canbaoBTN.setOnClickListener(this);
		login_shopBTN.setOnClickListener(this);
		login_canbaoBTN.setOnClickListener(this);
		login_fuwuBTN.setOnClickListener(this);
		cblogin_shopBTN.setOnClickListener(this);
		cblogin_fuwuBTN.setOnClickListener(this);
		cblogin_loginBTN.setOnClickListener(this);
		nologin_canbaoBTN.setOnClickListener(this);

		serDes = (TextView) findViewById(R.id.nologin_serdes);
		spinner = (MySpinner) findViewById(R.id.nologin_spinner);
		nologin_imei = (TextView) findViewById(R.id.nologin_imei);
		nologin_xieyi = (TextView) findViewById(R.id.nologin_xieyi);
		nologin_imei_read = (ImageView) findViewById(R.id.nologin_imei_read);
		nologin_canbaoflag = (TextView) findViewById(R.id.nologin_canbaoflag);

		nologin_xieyi.setOnClickListener(this);
		login_canbaoBTN.setOnClickListener(this);
		nologin_imei_read.setOnClickListener(this);
		nologin_canbaoflag.setOnClickListener(this);

		nologin_xieyi.setText(Html.fromHtml("<u>" + getApplication().getString(R.string.login_text_xieyi) + "</u>"));

		nologin_imei.setText(Utils.phone_Info.getIMEI());
		service_Info_Minis = Utils.main_info.getSerList();
		spinner.setData(service_Info_Minis, handler);
		spinner.setOnItemSelectedListener(new SpinnerOnItemSelectedListener());
		spinner.setFirstChose();

		if (Utils.main_info.getInsur()) {
			nologin_canbaoflag.setText(getApplication().getString(R.string.login_text_yicanbao));
		} else {
			nologin_canbaoflag.setText(getApplication().getString(R.string.login_text_weicanbao));
		}
		// 当没有登录过的时候显示的界面
		if (TextUtils.equals("", mobile) || TextUtils.isEmpty(mobile) || TextUtils.equals("", name) || TextUtils.isEmpty(name)) {
			// 当手机串号参保或没参保，显示按钮不同
			if (Utils.main_info.getInsur()) {// 参保了
				nologin.setVisibility(View.GONE);
				login.setVisibility(View.GONE);
				cblogin.setVisibility(View.VISIBLE);
			} else {// 没参保，初始化用户
				nologin.setVisibility(View.VISIBLE);
				login.setVisibility(View.GONE);
				cblogin.setVisibility(View.GONE);
			}
		} else {
			// 否则,直接登录,进入相对应的界面
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, mobile, name, null, null, null, null);
			new Thread_Post(activity, handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
		}
	}

	@Override
	public void onClick(View v) {
		System.out.println("Activity_Login--pressed:"+v.getId());
		switch (v.getId()) {
		case R.id.nologin_loginBTN:
			View_Web_Full.showWeb(activity, InfoMation.URL_XIEYI);	//zhang.hx add on 2015/1/28 登陆前显示用户协议
			Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_REGIST);
			break;
		case R.id.nologin_shopBTN:
			// View_Pay_Full.pay(Activity_Main.main_Activity, service_Info,
			// Utils.phone_Info.getIMEI());
			try {
				if (Utils.checkApkExist(activity, Utils.updata_Info.getMall_pack())) {
					Utils.runApk(activity, Utils.updata_Info.getMall_pack(), Utils.updata_Info.getMall_class(), mobile, name);
				} else {
					doUpdate(activity);
				}
			} catch (Exception e) {

			}
			break;
		case R.id.nologin_canbaoBTN:
			View_Web_Full.showWeb(activity, InfoMation.URL_XIEYI);	//zhang.hx add on 2015/1/28 登陆前显示用户协议
			Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_REGIST);
			// View_Pay_Full.pay(Activity_Main.main_Activity, service_Info,
			// Utils.phone_Info.getIMEI());
			break;
		case R.id.login_shopBTN:
			try {
				if (Utils.checkApkExist(activity, Utils.updata_Info.getMall_pack())) {
					Utils.runApk(activity, Utils.updata_Info.getMall_pack(), Utils.updata_Info.getMall_class(), mobile, name);
				} else {
					doUpdate(activity);
				}
			} catch (Exception e) {

			}
			break;
		case R.id.login_canbaoBTN:
			View_Pay_Full.pay(Activity_Main.main_Activity, service_Info, Utils.phone_Info.getIMEI());
			break;
		case R.id.cblogin_loginBTN:
			View_Web_Full.showWeb(activity, InfoMation.URL_XIEYI);	//zhang.hx add on 2015/1/28 登陆前显示用户协议
			Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_REGIST);
			break;
		case R.id.cblogin_shopBTN:
			try {
				if (Utils.checkApkExist(activity, Utils.updata_Info.getMall_pack())) {
					Utils.runApk(activity, Utils.updata_Info.getMall_pack(), Utils.updata_Info.getMall_class(), mobile, name);
				} else {
					doUpdate(activity);
				}
			} catch (Exception e) {

			}
			break;
		case R.id.cblogin_fuwuBTN:
			View_Claim_Full.claim(activity);
			break;
		case R.id.nologin_xieyi:
			View_Web_Full.showWeb(activity, InfoMation.URL_XIEYI);
			break;
		case R.id.nologin_imei_read:

			break;
		case R.id.login_fuwuBTN:
			View_Claim_Full.claim(activity);
			break;
		default:
			break;
		}

	}

	/** 提示更新窗口 */
	private void doUpdate(final Activity activity) {
		Dialog dialog = new AlertDialog.Builder(activity).setTitle("下载提示").setMessage("检测到进还未安装商城.\n请点击'确定'按钮下载!")
		// 设置内容
				.setPositiveButton("取消", null).setNegativeButton("确定", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int whichButton) {
						sdPath = InfoMation.APP_APP_PATH + Utils.updata_Info.getMall_url().hashCode() + ".apk";
						new Thread_DownApk(handler, Utils.updata_Info.getMall_url(), sdPath).start();
					}
				}).create();// 创建
		// 显示对话框
		dialog.show();
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		// TODO Auto-generated method stub
		super.onConfigurationChanged(newConfig);
	}
}
