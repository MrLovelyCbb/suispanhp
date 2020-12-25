package com.tc.myview;


import com.zphl.sspa0.R;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class MyButton extends LinearLayout {
	private ImageView imageView;
	private TextView textView;
	private View v;

	public MyButton(Context context, AttributeSet attrs) {
		super(context, attrs);
		v = LayoutInflater.from(context).inflate(R.layout.my_button, this, true);
		imageView = (ImageView) findViewById(R.id.my_button_img);
		textView = (TextView) findViewById(R.id.my_button_text);
	}

	public void setBack(int resId) {
		v.setBackgroundResource(resId);
	}

	public void setImage(int resId) {
		imageView.setImageResource(resId);
	}

	public void setText(String text) {
		textView.setText(text);
	}

}
