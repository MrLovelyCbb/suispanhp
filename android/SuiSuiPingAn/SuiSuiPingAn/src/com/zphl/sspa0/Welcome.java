package com.zphl.sspa0;

import java.util.ArrayList;

import com.tc.activity.Activity_Main;
import com.tc.adapter.ViewPager_Adapter;
import com.zphl.sspa0.R;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.app.Activity;
import android.content.Intent;

/**
 * 第一次运行的引导页代码
 * 
 * @author 罗超 2014-08-15 18:29
 * 
 */
public class Welcome extends Activity {
	// 定义ViewPager对象
	private ViewPager viewPager;
	// 定义ViewPager适配器
	private ViewPager_Adapter vpAdapter;
	// 定义一个ArrayList来存放View
	private ArrayList<View> views;
	// 定义各个界面View对象
	private View view1, view2, view3, view4,view5;
	// 定义底部小点图片
	private ImageView pointImage0, pointImage1, pointImage2, pointImage3, pointImage4;
	// 定义开始按钮对象
	private Button startBt;
	// 当前的位置索引值
	//private int currIndex = 0;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_welcome);
		initView();
		initData();
	}

	/**
	 * 初始化组件
	 */
	private void initView() {
		// 实例化各个界面的布局对象
		LayoutInflater mLi = LayoutInflater.from(this);
		view1 = mLi.inflate(R.layout.welcome_guide_view01, null);
		view2 = mLi.inflate(R.layout.welcome_guide_view02, null);
		view3 = mLi.inflate(R.layout.welcome_guide_view03, null);
		view4 = mLi.inflate(R.layout.welcome_guide_view04, null);
		view5 = mLi.inflate(R.layout.welcome_guide_view05, null);

		// 实例化ViewPager
		viewPager = (ViewPager) findViewById(R.id.welcome_viewpager);

		// 实例化ArrayList对象
		views = new ArrayList<View>();

		// 实例化ViewPager适配器
		vpAdapter = new ViewPager_Adapter(views);

		// 实例化底部小点图片对象
		pointImage0 = (ImageView) findViewById(R.id.welcome_page0);
		pointImage1 = (ImageView) findViewById(R.id.welcome_page1);
		pointImage2 = (ImageView) findViewById(R.id.welcome_page2);
		pointImage3 = (ImageView) findViewById(R.id.welcome_page3);
		pointImage4 = (ImageView) findViewById(R.id.welcome_page4);

		// 实例化开始按钮
		startBt = (Button) view5.findViewById(R.id.welcome_startBtn);
	}

	/**
	 * 初始化数据
	 */
	private void initData() {
		// 设置监听
		viewPager.setOnPageChangeListener(new MyOnPageChangeListener());
		// 设置适配器数据
		viewPager.setAdapter(vpAdapter);

		// 将要分页显示的View装入数组中
		views.add(view1);
		views.add(view2);
		views.add(view3);
		views.add(view4);
		views.add(view5);

		// 给开始按钮设置监听
		startBt.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				startbutton();
			}
		});
	}

	public class MyOnPageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageSelected(int position) {
			switch (position) {
			case 0:
				pointImage0.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_focused));
				pointImage1.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				break;
			case 1:
				pointImage1.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_focused));
				pointImage0.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				pointImage2.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				break;
			case 2:
				pointImage2.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_focused));
				pointImage1.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				pointImage3.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				break;
			case 3:
				pointImage3.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_focused));
				pointImage2.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				pointImage4.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				break;
			case 4:
				pointImage4.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_focused));
				pointImage3.setImageDrawable(getResources().getDrawable(R.drawable.welcome_page_indicator_unfocused));
				break;
			}
			//currIndex = position;
			// animation.setFillAfter(true);// True:图片停在动画结束位置
			// animation.setDuration(300);
			// mPageImg.startAnimation(animation);
		}

		@Override
		public void onPageScrollStateChanged(int arg0) {

		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {

		}
	}

	/**
	 * 相应按钮点击事件
	 */
	private void startbutton() {
		 Intent intent = new Intent();
		 intent.setClass(this,Activity_Main.class);
		 startActivity(intent);
		 this.finish();
	}

}
