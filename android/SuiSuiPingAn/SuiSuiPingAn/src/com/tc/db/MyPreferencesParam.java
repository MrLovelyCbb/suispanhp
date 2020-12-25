package com.tc.db;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

/**
 * 保存和获取应用系统的参数配置信息
 * 
 * @author 罗超 2014 09 01
 * 
 */
public class MyPreferencesParam {
	static String parmsName = "loginParam";

	/**
	 * 记录用户首次登陆 0、首次， 1、非首次
	 */
	public static void setLoginFirst(Context context, boolean state, String ver) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		sp.edit().putBoolean("isFirst" + ver, state).commit();
	}

	/**
	 * 获取用户登录状况
	 */
	public static boolean getLoginFirst(Context context, String ver) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		return sp.getBoolean("isFirst" + ver, true);
	}

	/**
	 * 保存登录参数
	 * 
	 * @param mobile
	 *            手机号
	 * @param pwd
	 *            姓名
	 */
	public static void setLoginParam(Context context, String mobile, String pwd) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		sp.edit().putString("mobile", mobile).putString("pwd", pwd).commit();

	}

	/**
	 * 获取登录参数
	 */
	public static String[] getLoginParam(Context context) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		String[] params = new String[2];
		params[0] = sp.getString("mobile", "");
		params[1] = sp.getString("pwd", "");
		return params;
	}

	/**
	 * 获取登录账户
	 */
	public static String getLoginAccount(Context context) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		return sp.getString("mobile", "");
	}

	/**
	 * 记录用户登录状况 0、未登录， 1、登录
	 */
	public static void setLoginState(Context context, int state) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		sp.edit().putInt("isLogin", state).commit();
	}

	/**
	 * 获取用户登录状况
	 */
	public static int getLoginState(Context context) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		return sp.getInt("isLogin", 0);
	}

	/**
	 * 清除数据
	 */
	public static void clearShared(Context context) {
		SharedPreferences sp = context.getSharedPreferences(parmsName, Activity.MODE_PRIVATE);
		Editor et = sp.edit();
		et.clear();
		et.commit();
	}
}