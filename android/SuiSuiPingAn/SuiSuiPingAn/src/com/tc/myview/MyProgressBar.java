package com.tc.myview;

import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

public class MyProgressBar extends LinearLayout {
	private ProgressWheel progress;
	private Activity activity;
	private Dialog dialog;

	public MyProgressBar(Context context) {
		super(context);
		this.activity = (Activity) context;
		View v = LayoutInflater.from(context).inflate(R.layout.progress_wheel, this, true);
		progress = (ProgressWheel) findViewById(R.id.progressBar);
		dialog = new Dialog(activity, R.style.DialogSplash);
		dialog.setCancelable(false);
		dialog.setContentView(v);
	}

	public void setText(String des) {
		progress.setText(des);
	}

	public void show(final String s) {
		String des = s;
		if (dialog != null) {
			progress.resetCount();
			if (TextUtils.isEmpty(des)) {
				des = "Loading...";
			}
			progress.setText(des);
			progress.spin();
			dialog.show();
			Utils.setDialogFullScreen(dialog);
		}
	}

	public void dismiss() {
		if (dialog != null) {
			dialog.cancel();
		}
	}

}
