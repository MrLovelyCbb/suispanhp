package com.tc.activity;

import android.app.ActivityGroup;
import android.app.LocalActivityManager;
import android.content.Intent;
import android.os.Bundle;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.CompoundButton.OnCheckedChangeListener;

public abstract class AbstractMyActivityGroup extends ActivityGroup implements OnCheckedChangeListener {

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		initRadioBtns();
	}

	// 加载Activity的View容器，容器应该是ViewGroup的子类

	private ViewGroup container;
	private LocalActivityManager localActivityManager;

	/**
	 * 加载Activity的View容器的id并不是固定的，将命名规则交给开发者
	 * 可以在布局文件中自定义其id，通过重写这个方法获得这个View容器的对象
	 * 
	 * @return
	 */
	abstract protected ViewGroup getContainer();

	/**
	 * 供实现类调用，根据导航按钮id初始化按钮
	 * 
	 * @param id
	 */
	protected void initRadioBtn(int id) {
		RadioButton btn = (RadioButton) findViewById(id);
		btn.setOnCheckedChangeListener(this);
	}

	/**
	 * 开发者必须重写这个方法，来遍历并初始化所有的导航按钮
	 */
	abstract protected void initRadioBtns();

	/**
	 * 为启动Activity初始化Intent信息
	 * 
	 * @param cls
	 * @return
	 */
	private Intent initIntent(Class<?> cls) {
		return new Intent(this, cls).addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
	}

	/**
	 * 供开发者在实现类中调用，能将Activity容器内的Activity移除，再将指定的某个Activity加入
	 * 
	 * @param activityName
	 *            加载的Activity在localActivityManager中的名字
	 * @param activityClassTye
	 *            要加载Activity的类型
	 */
	protected void setContainerView(String activityName, Class<?> activityClassTye) {
		if (null == localActivityManager) {
			localActivityManager = getLocalActivityManager();
		}

		if (null == container) {
			container = getContainer();
		}

		// 移除内容部分全部的View
		container.removeAllViews();
		// Activity contentActivity =
		// localActivityManager.getActivity(activityName);
		// if (null == contentActivity) {
		localActivityManager.startActivity(activityName, initIntent(activityClassTye).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP));
		// }
		// 加载Activity
		container.addView(localActivityManager.getActivity(activityName).getWindow().getDecorView(), new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT));

	}

	protected void leftRemoveAllView() {
		if (container != null) {
			container.removeAllViews();
		}

	}

	protected String getName() {
		return localActivityManager.getCurrentId();
	}

}
