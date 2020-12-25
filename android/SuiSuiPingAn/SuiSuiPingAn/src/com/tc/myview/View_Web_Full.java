package com.tc.myview;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.impl.client.DefaultHttpClient;

import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;


/**
 * 支付方式列表界面
 * 
 * @author 罗超
 * 
 */
@SuppressLint({ "ViewConstructor", "HandlerLeak", "SetJavaScriptEnabled" })
public class View_Web_Full extends LinearLayout implements View.OnClickListener {
	public static final int WEB_UPDATA = 56321;
	public static final int WEB_ERROR = 56404;
	public static final int WEB_SUCCESS = 56200;
	static View_Web_Full view_Web_Full;
	public static Dialog dialog_web;
	private Handler handler;
	private MyProgressBar bar;
	private Activity activity;
	private Button ok_BTN;
	private WebView webView;
	private HttpGet httpGet;

	public View_Web_Full(final Context context, final String url) {
		super(context);
		V(context);
		activity = (Activity) context;
		initView();
		handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				case WEB_UPDATA:
					break;
				case WEB_SUCCESS:
					webView.loadUrl(url);
					break;
				case WEB_ERROR:
					break;
				}
			}
		};

		httpGet = new HttpGet(url);
		// webview_webview.loadUrl(url);
		httpGet.start();
		webView.getSettings().setJavaScriptEnabled(true);
		// webView.setDownloadListener(new MyWebViewDownLoadListener());
		webView.setWebViewClient(new WebViewClient());

	}

	private void V(final Context context) {
		LayoutInflater.from(context).inflate(R.layout.view_web, this, true);

	}

	private void initView() {
		bar = new MyProgressBar(activity);
		ok_BTN = (Button) findViewById(R.id.web_ok_BTN);
		webView = (WebView) findViewById(R.id.web_view);
		ok_BTN.setOnClickListener(this);
		TextView caseT_web_title = (TextView) findViewById(R.id.caseT_web_title);
		/*********************** 适配字体 ***************************/
		if (Utils.dm.widthPixels > 950) {
			Utils.setDisplay_TextSize(caseT_web_title, 16);
		} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
			Utils.setDisplay_TextSize(caseT_web_title, 14);
		} else if (Utils.dm.widthPixels < 820) {
			ok_BTN.setTextSize(16);
			Utils.setDisplay_TextSize(caseT_web_title, 12);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.web_ok_BTN:
			dialog_web.cancel();
			break;
		default:
			break;
		}

	}

	public static void showWeb(final Activity act, final String url) {
		act.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				View_Web_Full.view_Web_Full = new View_Web_Full(act, url);
				dialog_web = new Dialog(act, R.style.DialogSplash1);
				dialog_web.setContentView(View_Web_Full.view_Web_Full);
				dialog_web.show();
				WindowManager.LayoutParams params = dialog_web.getWindow().getAttributes();
				params.width = Utils.dm.widthPixels;
				params.height = Utils.dm.heightPixels;
				dialog_web.getWindow().setAttributes(params);
			}
		});
	}

	private class WebViewClient extends android.webkit.WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			// 这里实现的目标是在网页中继续点开一个新链接，还是停留在当前程序中
			if (url.startsWith("newtab:")) {
				String urls = url.substring(7);
				System.out.println(urls);
				final Uri uri = Uri.parse(urls);
				final Intent it = new Intent(Intent.ACTION_VIEW, uri);
				activity.startActivity(it);
			} else {
				view.loadUrl(url);
			}
			return true;

		}

		// 开始
		@Override
		public void onPageStarted(WebView view, final String url, Bitmap favicon) {
			bar.show("正在加载内容");
			super.onPageStarted(view, url, favicon);
		}

		// 加载完成
		@Override
		public void onPageFinished(WebView view, String url) {
			bar.dismiss();
			super.onPageFinished(view, url);
			// 页面加载完成后加载下面的javascript，修改页面中所有用target="_blank"标记的url（在url前加标记为“newtab”）
			view.loadUrl("javascript: var allLinks = document.getElementsByTagName('a'); if (allLinks) {var i;for (i=0; i<allLinks.length; i++) {var link = allLinks[i];var target = link.getAttribute('target'); if (target && target == '_blank') {link.setAttribute('target','_self');link.href = 'newtab:'+link.href;}}}");
		}

		@Override
		public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
		}
	}

	/**
	 * 内部类，处理网页是否存在
	 * 
	 * @author Administrator
	 * 
	 */
	public class HttpGet extends Thread {
		private String url = null;

		public HttpGet(String url) {
			this.url = url;
		}

		@Override
		public void run() {
			Message msg = new Message();
			// 此处判断主页是否存在，因为主页是通过loadUrl加载的，
			// 此时不会执行shouldOverrideUrlLoading进行页面是否存在的判断
			// 进入主页后，点主页里面的链接，链接到其他页面就一定会执行shouldOverrideUrlLoading方法了
			if (getRespStatus(url) == 200) {
				msg.what = WEB_SUCCESS;
			} else {
				msg.what = WEB_ERROR;
			}
			handler.sendMessage(msg);
			super.run();
		}

	}

	private int getRespStatus(String url) {
		int status = -1;
		try {
			HttpHead head = new HttpHead(url);
			HttpClient client = new DefaultHttpClient();
			HttpResponse resp = client.execute(head);
			status = resp.getStatusLine().getStatusCode();
		} catch (IOException e) {
		}
		return status;
	}

}
