package com.tc.myview;

import java.net.MalformedURLException;
import java.net.URL;


import com.tc.thread.Thread_DownImage;
import com.tc.thread.Thread_DownImage.OnLoadImageListener;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;


/**
 * 支付方式列表界面
 * 
 * @author 罗超
 * 
 */
@SuppressLint({ "ViewConstructor", "HandlerLeak", "SetJavaScriptEnabled" })
public class View_Share_Full extends LinearLayout implements View.OnClickListener {
	static View_Share_Full view_Share_Full;
	public static Dialog dialog_share;
	private ImageView share_IMG;
	private Activity activity;
	private Button ok_BTN;

	public View_Share_Full(final Context context, final String url) {
		super(context);
		V(context);
		activity = (Activity) context;
		initView();
		URL URLS = null;
		try {
			URLS = new URL(url);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} // path图片的网络地址
		Thread_DownImage.onLoadImage(URLS, new OnLoadImageListener() {
			@Override
			public void OnLoadImage(Bitmap bitmap, String bitmapPath) {
				// TODO Auto-generated method stub
				share_IMG.setImageBitmap(bitmap);
			}

		});

	}

	private void V(final Context context) {
		LayoutInflater.from(context).inflate(R.layout.view_share, this, true);

	}

	private void initView() {
		share_IMG = (ImageView) findViewById(R.id.share_IMG);
		ok_BTN = (Button) findViewById(R.id.share_BTN);
		ok_BTN.setOnClickListener(this);
		TextView caseT_share_title = (TextView) findViewById(R.id.caseT_share_title);
		/*********************** 适配字体 ***************************/
		if (Utils.dm.widthPixels > 950) {
			Utils.setDisplay_TextSize(caseT_share_title, 16);
		} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
			Utils.setDisplay_TextSize(caseT_share_title, 14);
		} else if (Utils.dm.widthPixels < 820) {
			Utils.setDisplay_TextSize(caseT_share_title, 12);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.share_BTN:
			Utils.SendSMSTo(activity, Utils.updata_Info.getInvite());
			dialog_share.cancel();
			break;
		default:
			break;
		}

	}

	public static void showShare(final Activity act, final String url) {
		act.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				View_Share_Full.view_Share_Full = new View_Share_Full(act, url);
				dialog_share = new Dialog(act, R.style.DialogSplash1);
				dialog_share.setContentView(View_Share_Full.view_Share_Full);
				dialog_share.show();
				WindowManager.LayoutParams params = dialog_share.getWindow().getAttributes();
				params.width = Utils.dm.widthPixels;
				params.height = Utils.dm.heightPixels;
				dialog_share.getWindow().setAttributes(params);
			}
		});
	}

}
