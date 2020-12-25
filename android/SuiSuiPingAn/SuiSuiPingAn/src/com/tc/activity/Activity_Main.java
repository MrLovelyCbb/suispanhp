package com.tc.activity;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.tc.db.MyPreferencesParam;
import com.tc.in.InfoMation;
import com.tc.myview.MyProgressBar;
import com.tc.myview.PayResult;
import com.tc.myview.View_Claim_Full;
import com.tc.myview.View_Pay_Card;
import com.tc.myview.View_Pay_Mobile;
import com.tc.object.OBJ.AlixPay_Info;
import com.tc.object.OBJ.Order_Info;
import com.tc.object.OBJ.Pay_Card_Info;
import com.tc.object.OBJ.ReCommit_Info;
import com.tc.pay.alipay.AlixPay;
import com.tc.thread.Thread_DownApk;
import com.tc.thread.Thread_Post;
import com.tc.tool.JSONParser;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;
import com.tc.tool.Web_IMG_Utils;
import com.unionpay.UPPayAssistEx;
import com.unionpay.uppay.PayActivity;
import com.zphl.sspa0.R;

import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.LinearLayout.LayoutParams;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;

/**
 * 主界面
 * 
 * @author 罗超 2014-08-15 19:10
 */
public class Activity_Main extends AbstractMyActivityGroup {
	// 记录返回键按下的时间
	private long mExitTime;
	// 广告跳转的时长
	private final int AD_TURN_TIME = 6000;
	// private TextView mArticleTitle = null;
	// private final String HOST_ADDRESS = "http://p.xjdl.net"; // 640x500
	// private final String RESOURCE_ADDRESS = "/lhapp/WebService.txt";
	// private final String SERVER_ADDRESS = HOST_ADDRESS + RESOURCE_ADDRESS;
	// 用来处理主界面的请求
	private Handler handler = null;
	// 用来处理界面跳转和支付的请求
	private Handler mHandler = null;
	private Activity activity = null;
	private TextView main_title = null;
	private ImageView main_title_img1 = null;
	private ViewPager mViewPager = null;
	private List<View> mViewList = null;
	private MyPagerAdapter adapter = null;
	private boolean loopPlayState = false;
	@SuppressWarnings("unused")
	// 下方显示界面_容器
	private LinearLayout otherlayout = null;
	private LinearLayout mCustomSpace = null;
	public static Handler main_Handler = null;
	public static Activity main_Activity = null;
	private List<ImageView> mImageViewList = null;
	private MyProgressBar myProgressBar;
	private String sdPath;
	private boolean AD_imgFlag = true;

	@SuppressLint("HandlerLeak")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Utils.setPhoneInfo(this);
		setContentView(R.layout.activity_main);
		main_Activity = this;
		activity = this;
		handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				String res = null;
				switch (msg.what) {
				case MSG_TYPE.POST_MAIN:
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {// 开始必须加载的主界面信息
							Utils.main_info = JSONParser.ParseJson_Main(handler, res);
							main_title.setText(Utils.main_info.getTitle());
							loadData();
							adapter = new MyPagerAdapter();
							mViewPager.setAdapter(adapter);
							// 设置一个监听器，当ViewPager中的页面改变时调用
							mViewPager.setOnPageChangeListener(new MyPageChangeListener());
							setContainerView(getString(R.string._login), Activity_Login.class);
						}
						upData();
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_MAIN_ERROR);
					}

					break;
				// 更新信息
				case MSG_TYPE.POST_UPDATA:
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							Utils.updata_Info = JSONParser.ParseJson_Updata(res);
							if (Integer.parseInt(Utils.updata_Info.getMaxver()) > Integer.parseInt(Utils.app_Info.getVcode())) {
								doUpdate(activity, 1);// 强制
							}
						}
					} catch (Exception e) {

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
				case MSG_TYPE.THREAD_ERROR:
					Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.THREAD_ERROR);
					break;
				case MSG_TYPE.JSON_MAIN_OVER:

					break;

				default:
					break;
				}
			}
		};

		main_Handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				String res = null;
				switch (msg.what) {
				case MSG_TYPE.CANBAO_OK:
					InfoMation.PAY_FLAG = true;
//					setContainerView(getString(R.string._login_yes), Activity_Login_YES.class);
					// setContainerView(getString(R.string._login),
					// Activity_Login.class);
					HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_LOGIN, Utils.user_Info.getPhone(), Utils.user_Info.getName(), null, null, null, null);
					new Thread_Post(activity, main_Handler, InfoMation.URL_LOGIN, map, MSG_TYPE.POST_LOGIN).start();
					Utils.Toast(activity, "参保成功");
					
					break;
				case MSG_TYPE.ACTIVITY_REGIST:
					setContainerView(getString(R.string._regist), Activity_Regist.class);
					break;
				case MSG_TYPE.ACTIVITY_LOGIN:
					setContainerView(getString(R.string._login), Activity_Login.class);
					break;
				case MSG_TYPE.ACTIVITY_LOGIN_YES:
					setContainerView(getString(R.string._login_yes), Activity_Login_YES.class);
					break;
				case MSG_TYPE.POST_LOGIN:
					try {
						res = msg.obj.toString();
						// 登录过的用户，直接加载用户信息
						if (!TextUtils.isEmpty(res)) {
							Utils.user_Info = JSONParser.ParseJson_User(res);
							// 登录成功后，保存用户姓名和手机号
							String mobile = Utils.user_Info.getPhone();
							String name = Utils.user_Info.getName();
							if ((mobile != null) && (name != null) && (!mobile.equals("")) && (!name.equals(""))) {
								MyPreferencesParam.setLoginParam(activity, Utils.user_Info.getPhone(), Utils.user_Info.getName());
							}
							// 当用户有参保信息的时候，转到显示服务剩余时间界面
							if (Utils.user_Info.getOrders() != null) {
								System.out.println("已参保");
								Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_LOGIN_YES);
//								Activity_Login_YES.shengyurmb.setText(Utils.user_Info.getShengyuRMB() + "元");//zhang.hx add on 2015/1/26 刷新剩余购机款
							} else {
								System.out.println("未参保");
								Activity_Main.main_Handler.sendEmptyMessage(MSG_TYPE.ACTIVITY_LOGIN);
							}
						}
					} catch (Exception e) {
						System.out.println("Activity_Main");
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_LOGIN_ERROR);
					}

					break;
				case MSG_TYPE.POST_PAY:
					/* 点击支付后，用户选择的支付方式。1、银联.2、支付宝 */
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							Order_Info order_Info = new Order_Info();
							order_Info = JSONParser.ParseJson_Order(res);
							if (order_Info.getStatus().equals("0")) {
								// 私有订单号，方便查询
								PayResult.privateOrderID = order_Info.getOrderid();
								// 启动银联支付
								if (order_Info.getUsp().equals("1")) {
									UPPayAssistEx.startPayByJAR(activity, PayActivity.class, null, null, order_Info.getOrderidrn(), "00");
									// 启动支付宝支付
								} else if (order_Info.getUsp().equals("2")) {
									AlixPay_Info alixPay_info = new AlixPay_Info();
									alixPay_info.setTitle(order_Info.getName());
									alixPay_info.setInfos(order_Info.getName());
									alixPay_info.setOrderid(order_Info.getOrderid());
									alixPay_info.setNotifyUrl(InfoMation.URL_ALI_NOTIFY);
									alixPay_info.setPrice(Integer.parseInt(order_Info.getPrize()) / 100 + "");
									// alixPay_info.setPrice(0.01 + "");
									AlixPay alixPay = new AlixPay(activity, alixPay_info);
									alixPay.pay();
								} else if (order_Info.getUsp().equals("3")) {
									View_Pay_Card.pay(activity, PayResult.privateOrderID);
								} 
							}
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_PAY_ERROR);
					}

					break;
				case MSG_TYPE.POST_PAY_CARD:
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							Pay_Card_Info card_Info = JSONParser.ParseJson_PayCard(res);
							if (card_Info.getStatus().equals("0")) {
								InfoMation.PAY_FLAG = true;
								View_Pay_Card.cancel();
								PayResult.PayRes(activity, 0);
							} else {
								PayResult.PayRes(activity, 1);
							}
							Utils.Toast(activity, card_Info.getInfo());
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_PAY_CARD_ERROR);
					}

					break;
				case MSG_TYPE.POST_SEND:
					try {
						res = msg.obj.toString();
						if (!TextUtils.isEmpty(res)) {
							ReCommit_Info commit_Info = new ReCommit_Info();
							commit_Info = JSONParser.ParseJson_ReCommit(res);
							if (commit_Info.getStatus().equals("0")) {
								Utils.Toast(activity, "发送成功，等待客服人员与你联系");
								View_Claim_Full.dismiss();
							} else {
								Utils.Toast(activity, "发送失败，等重新发送");
							}
						}
					} catch (Exception e) {
						Utils.Toast(activity, getString(R.string.post_ERROR) + MSG_TYPE.POST_SEND_ERROR);
					}

					break;
				case MSG_TYPE.POST_PAY_MOBILE:
					//话费代付
					System.out.println("话费代付");
					View_Pay_Mobile.pay(activity);
					break;
				case MSG_TYPE.POST_PAY_MOBILE_FINISH:
					res = msg.obj.toString();
					if(res.equals("0")) {
						Utils.Toast(activity, "您已成功办理");
					} else {
						Utils.Toast(activity, "操作失败，请稍后重试");
					}
					break;
				default:
					break;
				}
			}
		};
		initView();
		// 获取主界面信息
		HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_MAIN, null, null, null, null, null, null);
		new Thread_Post(activity, handler, InfoMation.URL_MAIN, map, MSG_TYPE.POST_MAIN).start();

	}

	private void initView() {
		mHandler = new Handler();
		mViewList = new ArrayList<View>();
		mImageViewList = new ArrayList<ImageView>();
		main_title = (TextView) findViewById(R.id.main_title);
		mViewPager = (ViewPager) this.findViewById(R.id.main_viewpager);
		otherlayout = (LinearLayout) findViewById(R.id.main_otherlayout);
		main_title_img1 = (ImageView) findViewById(R.id.main_title_img1);
		// mArticleTitle = (TextView) this.findViewById(R.id.article_title);
		mCustomSpace = (LinearLayout) this.findViewById(R.id.custom_space);
		TextView caseT_main_title = (TextView) findViewById(R.id.caseT_main_title);
		/*********************** 适配字体 ***************************/
		if (Utils.dm.widthPixels > 950) {
			Utils.setDisplay_TextSize(caseT_main_title, 16);
		} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
			Utils.setDisplay_TextSize(caseT_main_title, 14);
		} else if (Utils.dm.widthPixels < 820) {
			Utils.setDisplay_TextSize(caseT_main_title, 12);
		}
		main_title_img1.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// setContainerView(getString(R.string._regist),
				// Activity_Regist.class);
			}
		});
		main_title_img1.setOnLongClickListener(new View.OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				MyPreferencesParam.clearShared(activity);
				Utils.Toast(activity, "0000");
				return false;
			}
		});
	}

	// 在按一次返回登录界面
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {

		if (keyCode == KeyEvent.KEYCODE_BACK) {
			// 如果两次按键时间间隔大于2000毫秒，则不退出
			if ((System.currentTimeMillis() - mExitTime) > 1800) {
				Utils.Toast(activity, "再按一次结束程序");
				// 更新mExitTime
				mExitTime = System.currentTimeMillis();
			} else {
				this.finish();
				android.os.Process.killProcess(android.os.Process.myPid());
				System.exit(0);
			}
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onResume() {
		if (Utils.main_info == null) {
			initView();
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_MAIN, null, null, null, null, null, null);
			new Thread_Post(activity, handler, InfoMation.URL_MAIN, map, MSG_TYPE.POST_MAIN).start();
		}
		super.onResume();

	}

	private void loadData() {
		// TODO Auto-generated method stub
		new DownLoad(null).execute(InfoMation.URL_MAIN);
	}

	private final class MyPagerAdapter extends PagerAdapter {

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return mImageViewList.size();
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object object) {
			// TODO Auto-generated method stub
			((ViewPager) container).removeView(mImageViewList.get(position));
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position) {
			// TODO Auto-generated method stub
			ImageView temp = mImageViewList.get(position);
			new DownLoad(temp).execute(Utils.main_info.getAD_List().get(position).getImg());
			((ViewPager) container).addView(temp);
			return temp;
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			// TODO Auto-generated method stub
			return arg0 == arg1;
		}

	}

	private final class DownLoad extends AsyncTask<String, Void, Bitmap> {

		private ImageView mImageView;

		public DownLoad(ImageView imageView) {
			mImageView = imageView;
		}

		@Override
		protected Bitmap doInBackground(String... params) {
			// TODO Auto-generated method stub
			try {
				if (params[0].equals(InfoMation.URL_MAIN)) {
					mImageViewList.clear();
				} else {
					Bitmap bitmap = (Bitmap) (Web_IMG_Utils.getData(params[0], Bitmap.class));
					return bitmap;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			return null;
		}

		/**
		 * 加载广告图片的View
		 */
		@Override
		protected void onPostExecute(Bitmap result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);
			if (result != null) {
				mImageView.setImageBitmap(result);
				if (!loopPlayState) {
					// mArticleTitle.setText(mData.get(0).getmTitle());
					mViewPager.setCurrentItem(0);
					mHandler.postDelayed(loopPlay, AD_TURN_TIME);
					loopPlayState = true;
				}
			} else {
				try {
					if (Utils.main_info == null) {
						if (Utils.main_info == null) {
							initView();
							HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_MAIN, null, null, null, null, null, null);
							new Thread_Post(activity, handler, InfoMation.URL_MAIN, map, MSG_TYPE.POST_MAIN).start();
						}
					} else {
						if (AD_imgFlag) {
							for (int i = 0; i < Utils.main_info.getAD_List().size(); i++) {
								ImageView imageView = new ImageView(activity);
								imageView.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));
								imageView.setScaleType(ImageView.ScaleType.FIT_XY);
								imageView.setOnClickListener(null);
								mImageViewList.add(imageView);
								View view = new View(activity);
								LayoutParams layoutParams = new LayoutParams(14, 14);
								layoutParams.setMargins(3, 0, 3, 0);
								view.setLayoutParams(layoutParams);
								view.setBackgroundResource(R.drawable.welcome_page_indicator_unfocused);
								mCustomSpace.addView(view);
								mViewList.add(view);
							}
						}
						AD_imgFlag = false;
					}
					adapter.notifyDataSetChanged();
				} catch (Exception e) {
				}

			}

		}

	}

	/**
	 * 当ViewPager中页面的状态发生改变时调用
	 */
	private class MyPageChangeListener implements OnPageChangeListener {

		private int historyPosition = 0;

		/**
		 * 当ViewPager中页面的状态发生改变时调用
		 */
		public void onPageSelected(int position) {
			// mArticleTitle.setText(mData.get(position).getmTitle());
			mViewList.get(historyPosition).setBackgroundResource(R.drawable.welcome_page_indicator_unfocused);
			mViewList.get(position).setBackgroundResource(R.drawable.welcome_page_indicator_focused);
			historyPosition = position;
		}

		public void onPageScrollStateChanged(int arg0) {
		}

		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}
	}

	Runnable loopPlay = new Runnable() {

		@Override
		public void run() {
			// TODO Auto-generated method stub
			int position = mViewPager.getCurrentItem();
			if (position >= (Utils.main_info.getAD_List().size() - 1)) {
				position = 0;
				mViewPager.setCurrentItem(position);
			} else {
				// 防止postion越界
				int p = ++position;
				if (p < 0)
					p = 0;
				mViewPager.setCurrentItem(p);
			}
			mHandler.postDelayed(loopPlay, AD_TURN_TIME);
		}
	};

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
	}

	@Override
	protected ViewGroup getContainer() {
		// TODO Auto-generated method stub
		return (ViewGroup) findViewById(R.id.main_otherlayout);
	}

	@Override
	protected void initRadioBtns() {
		// TODO Auto-generated method stub

	}

	public static void showProgressBar() {

	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		// TODO Auto-generated method stub
		super.onConfigurationChanged(newConfig);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (data == null) {
			return;
		}
		// 银联支付回调
		/* 银联支付控件返回字符串:success、fail、cancel 分别代表支付成功，支付失败，支付取消 */
		String str = data.getExtras().getString("pay_result");
		if (str.equalsIgnoreCase("success")) {
			PayResult.PayRes(activity, 0);
			// "支付成功！";
		} else if (str.equalsIgnoreCase("fail")) {
			PayResult.PayRes(activity, 1);
			// "支付失败！";
		} else if (str.equalsIgnoreCase("cancel")) {
			PayResult.PayRes(activity, 2);
			// "用户取消了支付";
		}
	}

	public void upData() {
		HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_UPDATA, null, Utils.app_Info.getVcode(), null, null, null, null);
		new Thread_Post(activity, handler, InfoMation.URL_UPDATA, map, MSG_TYPE.POST_UPDATA).start();
	}

	/** 提示更新窗口 */
	private void doUpdate(final Activity activity, int type) {
		StringBuffer sb = new StringBuffer();
		sb.append("更新内容：");
		String des = Utils.updata_Info.getDinfo();
		// 切割字符添加更新内容
		String s1[] = des.split("\\+");
		for (String s : s1) {
			sb.append("\r\n" + s);
		}
		// sb.append("\r\n是否更新?");
		if (type == 1) {
			Dialog dialog = new AlertDialog.Builder(activity).setTitle("更新提示").setMessage(sb.toString())
			// 设置内容
					.setPositiveButton("退出",// 设置确定按钮
							new DialogInterface.OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog, int which) {
									activity.finish();
									System.exit(0);
								}
							}).setNegativeButton("猛击更新", new DialogInterface.OnClickListener() {
						@Override
						public void onClick(DialogInterface dialog, int which) {
							sdPath = InfoMation.APP_APP_PATH + Utils.updata_Info.getAppname() + ".apk";
							System.out.println("Utils.updata_Info.getUrl()"+Utils.updata_Info.getUrl());
							new Thread_DownApk(handler, Utils.updata_Info.getUrl(), sdPath).start();

						}
					}).setCancelable(false).create();// 创建
			// 显示对话框
			dialog.show();
		} else if (type == 2) {
			Dialog dialog = new AlertDialog.Builder(activity).setTitle("更新提示").setMessage(sb.toString())
			// 设置内容
					.setPositiveButton("飘过", null).setNegativeButton("确定", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int whichButton) {
							sdPath = InfoMation.APP_APP_PATH + Utils.updata_Info.getAppname() + ".apk";
							new Thread_DownApk(handler, Utils.updata_Info.getUrl(), sdPath).start();
						}
					}).create();// 创建
			// 显示对话框
			dialog.show();
		} else if (type == 0) {
		} else {

		}
	}

}
