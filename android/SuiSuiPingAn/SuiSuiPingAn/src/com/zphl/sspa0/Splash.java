package com.zphl.sspa0;

import com.tc.activity.Activity_Main;
import com.tc.db.MyPreferencesParam;
import com.tc.tool.FileUtils;
import com.tc.tool.NetManager;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.app.AlertDialog.Builder;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Animation.AnimationListener;

/**
 * 加载图片 ，第一个界面
 * 
 * @author 罗超 2014-08-15 18:29
 * 
 */
public class Splash extends Activity {
	private NetManager splash_NetManager; // 判断网络有没打开
	private boolean start_first; // 判断是否第一次打开应用
	private View splash_View; // 启动界面的View
	private Activity activity; // 上下文
	private Animation splash_animation; // 动画效果
	private static int SPLASH_TIME = 300; // 进入主程序的延迟时间 毫秒

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		splash_View = View.inflate(this, R.layout.activity_splash, null);
		setContentView(splash_View);
		activity = this;
		splash_NetManager = new NetManager(activity); // 得到网络管理器
		FileUtils.creatDir();
	}

	@Override
	protected void onResume() {
		Utils.setAppInfo(this);
		into();
		super.onResume();
	}

	public void onPause() {
		super.onPause();
	}

	// 进入主程序的方法
	private void into() {
		if (splash_NetManager.isOpenNetwork()) {
			// 如果网络可用则判断是否第一次进入，如果是第一次则进入欢迎界面
			start_first = MyPreferencesParam.getLoginFirst(this, Utils.app_Info.getVcode());
			
			start_first = false;	//去掉第一次启动的广告页面 zhang.hx add on 2015/6/23

			// 设置动画效果是alpha，在anim目录下的alpha.xml文件中定义动画效果
			splash_animation = AnimationUtils.loadAnimation(this, R.anim.alpha);
			// 给view设置动画效果
			splash_View.startAnimation(splash_animation);
			splash_animation.setAnimationListener(new AnimationListener() {
				@Override
				public void onAnimationStart(Animation arg0) {
				}

				@Override
				public void onAnimationRepeat(Animation arg0) {
				}

				// 这里监听动画结束的动作，在动画结束的时候开启一个线程，这个线程中绑定一个Handler,并
				// 在这个Handler中调用goHome方法，而通过postDelayed方法使这个方法延迟500毫秒执行，达到
				// 达到持续显示第一屏500毫秒的效果
				@Override
				public void onAnimationEnd(Animation arg0) {
					new Handler().postDelayed(new Runnable() {
						@Override
						public void run() {
							Intent intent;
							// 如果第一次，则进入引导页WelcomeActivity
							if (start_first) {
								MyPreferencesParam.setLoginFirst(activity, false, Utils.app_Info.getVcode());
								intent = new Intent(activity, Welcome.class);
							} else {
								intent = new Intent(activity, Activity_Main.class);
							}

							startActivity(intent);
							// 设置Activity的切换效果
							overridePendingTransition(R.anim.in_from_right, R.anim.out_to_left);
							activity.finish();
						}
					}, SPLASH_TIME);
				}
			});
		} else {
			// 如果网络不可用，则弹出对话框，对网络进行设置
			Builder builder = new Builder(activity);
			builder.setTitle("没有可用的网络");
			builder.setMessage("是否对网络进行设置?");
			builder.setPositiveButton("确定", new android.content.DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					Intent intent = null;
					try {
						String sdkVersion = android.os.Build.VERSION.SDK;
						if (Integer.valueOf(sdkVersion) > 10) {
							intent = new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS);
						} else {
							intent = new Intent();
							ComponentName comp = new ComponentName("com.android.settings", "com.android.settings.WirelessSettings");
							intent.setComponent(comp);
							intent.setAction("android.intent.action.VIEW");
						}
						Splash.this.startActivity(intent);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			});
			builder.setNegativeButton("取消", new android.content.DialogInterface.OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					Splash.this.finish();
				}
			});
			builder.show();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

}
