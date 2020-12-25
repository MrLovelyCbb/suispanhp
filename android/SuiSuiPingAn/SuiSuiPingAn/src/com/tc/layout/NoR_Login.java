package com.tc.layout;

import com.zphl.sspa0.R;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.WindowManager;
import android.widget.LinearLayout;

@SuppressLint("ViewConstructor")
public class NoR_Login extends LinearLayout {
	static Activity activity;

	@SuppressLint("HandlerLeak")
	public NoR_Login(final Context context) {
		super(context);
		
		// 屏幕常亮
		((Activity) context).getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		LayoutInflater.from(context).inflate(R.layout._nologin, this, true);
	}
}
