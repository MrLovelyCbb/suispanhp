package com.tc.activity;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import com.tc.in.InfoMation;
import com.tc.myview.MyOrderSpinner;
import com.tc.myview.MyProgressBar;
import com.tc.myview.MySpinner2;
import com.tc.myview.View_Claim_Full;
import com.tc.myview.View_Pay_Full;
import com.tc.myview.View_Share_Full;
import com.tc.object.OBJ.Service_Info;
import com.tc.object.OBJ.Service_Info_Mini;
import com.tc.object.OBJ.Service_Info_Order;
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
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
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
 * 用户已登录。 且 【有已订购服务】 的界面。
 * 
 * @author 罗超 2014-09-09 15:10
 */
public class Activity_Login_YES extends Activity implements View.OnClickListener {

	// 用户的姓名
	private static String name = null;
	// 用户的手机号码
	private static String phone = null;
	// 处理续保支付
	private static Handler handler = null;
	// 续保按钮
	private Button xubaoBTN = null;
	// 服务按钮
	private Button claimBTN = null;
	// 参保本机按钮
	private Button canbaobenji_BTN = null;
	// 商城
	private Button shop_BTN = null;

	private static Activity activity = null;
	// 服务的订购时间textview
	private TextView startTime = null;
	private TextView outTime = null;
	private TextView login_yes_imei = null;
	// 显示此手机号购买了服务的手机串号列表
	private MyOrderSpinner spinner = null;
	//
	private MySpinner2 fuwuspinner = null;
	// 显示此手机剩余购机款
	public static TextView shengyurmb = null;
	// 需要服务进行续保时，进行查询的那个服务
	private Service_Info service_Info = null;
	private boolean benji_Flag = false;
	public static int benji = 0;
	private String sdPath = "";
	private MyProgressBar myProgressBar;

	private Service_Info_Order order;
	private ArrayList<Service_Info_Order> service_Info_List;
	ArrayList<Service_Info_Mini> service_Info_Minis;

	private String canbaoIMEI = "";
	
	private TextView loginInfo;	//zhang.hx add on 2015/1/23 增加登录提示信息

	@Override
	public void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout._login_yes);
		phone = Utils.user_Info.getPhone();
		name = Utils.user_Info.getName();
		activity = this;
		setHander();
		initView();
	}

	@SuppressLint("HandlerLeak")
	private void setHander() {
		handler = new Handler() {
			@SuppressLint("ResourceAsColor")
			@Override
			public void handleMessage(Message msg) {
				String res = null;
				switch (msg.what) {
				// 显示已购买的信息
				case MSG_TYPE.MESSAGE_ORDER_SER:
					order = (Service_Info_Order) msg.obj;
					startTime.setText(Utils.getStrTime(order.getDtime()));
					outTime.setText(Utils.getStrTime(order.getExpire()));
					break;
				// 支付成功后，刷新用户信息
				case MSG_TYPE.POST_LOGIN:
					// 登录过的用户，直接加载用户信息
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							Utils.user_Info = JSONParser.ParseJson_User(res);
							service_Info_List = Utils.user_Info.getOrders();
							if (service_Info_List != null) {
								spinner.setData(service_Info_List, handler);
								spinner.setOnItemSelectedListener(new SpinnerOnItemSelectedListener());
								// 遍历已订购的imei，查询看有没有本机
								for (Service_Info_Order s : service_Info_List) {
									if (s.getImei().equals(Utils.phone_Info.getIMEI())) {
										benji_Flag = true;
									}
									// 有本机
									if (benji_Flag) {
										spinner.setOrders(s);
										canbaobenji_BTN.setText("好友分享");
									} else {
										spinner.setFirstChose();
									}
								}
								//刷新显示剩余购机款 zhang.hx add on 2015/2/5
								if (Utils.user_Info.getShengyuRMB() != null) {
									shengyurmb.setText(Utils.user_Info.getShengyuRMB() + "元");
								}
							}
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_LOGIN_ERROR);
					}

					break;
				// 获取单个服务，然后进行支付
				case MSG_TYPE.POST_SERVICE:
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							service_Info = JSONParser.ParseJson_Service(res);
							if (benji != 0) {
								canbaoIMEI = spinner.getMyOrder().getImei();
								// View_Pay_Full.pay(Activity_Main.main_Activity,
								// service_Info,
								// spinner.getMyOrder().getImei());
							} else {
								canbaoIMEI = Utils.phone_Info.getIMEI();
								// View_Pay_Full.pay(Activity_Main.main_Activity,
								// service_Info, Utils.phone_Info.getIMEI());
							}
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_SERVICE_ERROR);
					}
					break;
				case MSG_TYPE.POST_XUBAOSERVICE:

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
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, Utils.user_Info.getPhone(), Utils.user_Info.getName(), null, null, null, null);
			new Thread_Post(activity, handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
			InfoMation.PAY_FLAG = false;
		}
		super.onResume();

	}

	public static void updata() {
		HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, Utils.user_Info.getPhone(), Utils.user_Info.getName(), null, null, null, null);
		new Thread_Post(activity, handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
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
			Utils.Log2(activity, service_Info_List.get(arg2).getImei());
			//选择的需要参保的IMEI
			canbaoIMEI = service_Info_List.get(arg2).getImei();
		}

		public void onNothingSelected(AdapterView<?> arg0) {
		}

	}

	class SpinnerOnItemSelectedListener2 implements OnItemSelectedListener {

		public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2, long arg3) {

		}

		public void onNothingSelected(AdapterView<?> arg0) {
		}

	}

	private void initView() {
		//zhang.hx add on 201/1/23 提示用于已经登录
		loginInfo = (TextView) findViewById(R.id.loginInfo);
		loginInfo.setText("尊敬的用户："+Utils.user_Info.getName()+",您已登录！");
		
		login_yes_imei = (TextView) findViewById(R.id.login_yes_imei);
		canbaobenji_BTN = (Button) findViewById(R.id.login_yes_canbaobenjiBTN);
		startTime = (TextView) findViewById(R.id.login_yes_starttime);
		outTime = (TextView) findViewById(R.id.login_yes_outtime);
		spinner = (MyOrderSpinner) findViewById(R.id.login_yes_spinner);
		fuwuspinner = (MySpinner2) findViewById(R.id.login_yes_xuanzefuwu);
		shengyurmb = (TextView) findViewById(R.id.login_yes_shengyurmb);
		claimBTN = (Button) findViewById(R.id.login_yes_claim);
		shop_BTN = (Button) findViewById(R.id.login_yes_shop);
		xubaoBTN = (Button) findViewById(R.id.login_yes_xubaoBTN);
		xubaoBTN.setOnClickListener(this);
		shengyurmb.setOnClickListener(this);
		shop_BTN.setOnClickListener(this);
		claimBTN.setOnClickListener(this);
		canbaobenji_BTN.setOnClickListener(this);
		// 从用户信息里取出已订购的服务列表信息
		service_Info_List = Utils.user_Info.getOrders();
		// 在spinner里设置这些服务列表信息
		System.out.println("service_Info_List:"+service_Info_List);
		spinner.setData(service_Info_List, handler);
		spinner.setOnItemSelectedListener(new SpinnerOnItemSelectedListener());
		// 默认选择第一个
		// 遍历已订购的imei，查询看有没有本机
		for (Service_Info_Order s : service_Info_List) {
			if (s.getImei().equals(Utils.phone_Info.getIMEI())) {
				benji_Flag = true;
			}
			// 有本机
			if (benji_Flag) {
				spinner.setOrders(s);
				canbaobenji_BTN.setText("好友分享");
			} else {
				canbaobenji_BTN.setText("本机未参保");
				canbaobenji_BTN.setClickable(false);
				spinner.setFirstChose();
			}
		}
		service_Info_Minis = Utils.main_info.getSerList();
		fuwuspinner.setData(service_Info_Minis, handler);
		fuwuspinner.setOnItemSelectedListener(new SpinnerOnItemSelectedListener2());
		fuwuspinner.setFirstChose();
		try {
			shengyurmb.setText(Utils.user_Info.getShengyuRMB() + "元");
			login_yes_imei.setText(Utils.phone_Info.getIMEI());
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		// 找到对应的服务id，获取服务信息，进行支付准备
		case R.id.login_yes_xubaoBTN:
			View_Pay_Full.pay(Activity_Main.main_Activity, service_Info, canbaoIMEI);
			// if (spinner.getMyOrder() != null) {
			// benji = 1;
			// Utils.Log2(activity, "canbaoIMEI" + canbaoIMEI);
			// HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_SER_ONE,
			// canbaoIMEI, service_Info.getId(), null, null, null,
			// spinner.getMyOrder().getImei());
			// new Thread_Post(activity, handler, InfoMation.URL_SER, map,
			// MSG_TYPE.POST_XUBAOSERVICE).start();
			// }
			break;
		case R.id.login_yes_claim:
			View_Claim_Full.claim(activity);
			break;
		case R.id.login_yes_canbaobenjiBTN:
			if (!benji_Flag) {
				View_Pay_Full.pay(Activity_Main.main_Activity, service_Info, canbaoIMEI);
				// if (spinner.getMyOrder() != null) {
				// benji = 0;
				// Utils.Log2(activity, "canbaoIMEI" + canbaoIMEI);
				// HashMap<String, String> map =
				// Utils.Get_Map(MSG_TYPE.MAP_SER_ONE,
				// Utils.user_Info.getPhone(), service_Info.getId(), null, null,
				// null, Utils.phone_Info.getIMEI());
				// new Thread_Post(activity, handler, InfoMation.URL_SER, map,
				// MSG_TYPE.POST_XUBAOSERVICE).start();
				// }
			} else {
				View_Share_Full.showShare(activity, Utils.updata_Info.getUrl_img());
			}
			break;
		case R.id.login_yes_shop:
			try {
				if (Utils.checkApkExist(activity, Utils.updata_Info.getMall_pack())) {
					Utils.runApk(activity, Utils.updata_Info.getMall_pack(), Utils.updata_Info.getMall_class(), phone, name);
				} else {
					doUpdate(activity);
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
			System.out.println("BBB");
			break;
		case R.id.login_yes_shengyurmb:
			try {
				if (Utils.checkApkExist(activity, Utils.updata_Info.getMall_pack())) {
					Utils.runApk(activity, Utils.updata_Info.getMall_pack(), Utils.updata_Info.getMall_class(), phone, name);
				} else {
					doUpdate(activity);
				}
			} catch (Exception e) {
				// TODO: handle exception
			}
			System.out.println("CCC");
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
		super.onConfigurationChanged(newConfig);
	}
}
