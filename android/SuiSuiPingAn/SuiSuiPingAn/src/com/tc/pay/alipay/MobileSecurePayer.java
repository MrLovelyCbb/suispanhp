/*
 * Copyright (C) 2010 The MobileSecurePay Project
 * All right reserved.
 * author: shiqun.shi@alipay.com
 */

package com.tc.pay.alipay;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.RemoteException;

import com.alipay.android.app.IAlixPay;
import com.alipay.android.app.IRemoteServiceCallback;

/**
 * 鍜屽畨鍏ㄦ敮浠樻湇锷￠?淇★紝鍙戦?璁㈠崟淇℃伅杩涜鏀粯锛屾帴鏀舵敮浠桦疂杩斿洖淇℃伅
 * 
 */
public class MobileSecurePayer {
	static String TAG = "MobileSecurePayer";

	Integer lock = 0;
	IAlixPay mAlixPay = null;
	boolean mbPaying = false;

	Activity mActivity = null;

	// 鍜屽畨鍏ㄦ敮浠樻湇锷″缓绔嬭繛鎺?
	private ServiceConnection mAlixPayConnection = new ServiceConnection() {

		public void onServiceConnected(ComponentName className, IBinder service) {
			//
			// wake up the binder to continue.
			// 銮峰缑阃氢俊阃氶亾
			synchronized (lock) {
				mAlixPay = IAlixPay.Stub.asInterface(service);
				lock.notify();
			}
		}

		public void onServiceDisconnected(ComponentName className) {
			mAlixPay = null;
		}
	};

	/**
	 * 鍚戞敮浠桦疂鍙戦?鏀粯璇锋眰
	 * 
	 * @param strOrderInfo
	 *            璁㈠崟淇℃伅
	 * @param callback
	 *            锲炶皟handler
	 * @param myWhat
	 *            锲炶皟淇℃伅
	 * @param activity
	 *            鐩爣activity
	 * @return
	 */
	public boolean pay(final String strOrderInfo, final Handler callback,
			final int myWhat, final Activity activity) {
		if (mbPaying)
			return false;
		mbPaying = true;

		//
		mActivity = activity;

		// bind the service.
		// 缁戝畾链嶅姟
		if (mAlixPay == null) {
			// 缁戝畾瀹夊叏鏀粯链嶅姟闇?銮峰彇涓娄笅鏂囩幆澧冿紝
			// 濡傛灉缁戝畾涓嶆垚锷熶娇鐢╩Activity.getApplicationContext().bindService
			// 瑙ｇ粦镞跺悓鐞?
			mActivity.getApplicationContext().bindService(
					new Intent(IAlixPay.class.getName()), mAlixPayConnection,
					Context.BIND_AUTO_CREATE);
		}
		// else ok.

		// 瀹炰緥涓?釜绾跨▼鏉ヨ繘琛屾敮浠?
		new Thread(new Runnable() {
			public void run() {
				try {
					// wait for the service bind operation to completely
					// finished.
					// Note: this is important,otherwise the next mAlixPay.Pay()
					// will fail.
					// 绛夊緟瀹夊叏鏀粯链嶅姟缁戝畾鎿崭綔缁撴潫
					// 娉ㄦ剰锛氲繖閲屽緢閲嶈锛屽惁鍒檓AlixPay.Pay()鏂规硶浼氩け璐?
					synchronized (lock) {
						if (mAlixPay == null)
							lock.wait();
					}

					// register a Callback for the service.
					// 涓哄畨鍏ㄦ敮浠樻湇锷℃敞鍐屼竴涓洖璋?
					mAlixPay.registerCallback(mCallback);

					// call the MobileSecurePay service.
					// 璋幂敤瀹夊叏鏀粯链嶅姟镄刾ay鏂规硶
					String strRet = mAlixPay.Pay(strOrderInfo);
					BaseHelper.log(TAG, "After View_Pay_Full: " + strRet);

					// set the flag to indicate that we have finished.
					// unregister the Callback, and unbind the service.
					// 灏唌bPaying缃负false锛岃〃绀烘敮浠樼粨鏉?
					// 绉婚櫎锲炶皟镄勬敞鍐岋紝瑙ｇ粦瀹夊叏鏀粯链嶅姟
					mbPaying = false;
					mAlixPay.unregisterCallback(mCallback);
					mActivity.getApplicationContext().unbindService(
							mAlixPayConnection);

					// send the result back to caller.
					// 鍙戦?浜ゆ槗缁撴灉
					Message msg = new Message();
					msg.what = myWhat;
					msg.obj = strRet;
					callback.sendMessage(msg);
				} catch (Exception e) {
					e.printStackTrace();

					// send the result back to caller.
					// 鍙戦?浜ゆ槗缁撴灉
					Message msg = new Message();
					msg.what = myWhat;
					msg.obj = e.toString();
					callback.sendMessage(msg);
				}
			}
		}).start();

		return true;
	}

	/**
	 * This implementation is used to receive callbacks from the remote service.
	 * 瀹炵幇瀹夊叏鏀粯镄勫洖璋?
	 */
	private IRemoteServiceCallback mCallback = new IRemoteServiceCallback.Stub() {
		/**
		 * This is called by the remote service regularly to tell us about new
		 * values. Note that IPC calls are dispatched through a thread pool
		 * running in each process, so the code executing here will NOT be
		 * running in our main thread like most other things -- so, to update
		 * the UI, we need to use a Handler to hop over there. 阃氲绷IPC链哄埗鍚姩瀹夊叏鏀粯链嶅姟
		 */
		public void startActivity(String packageName, String className,
				int iCallingPid, Bundle bundle) throws RemoteException {
			Intent intent = new Intent(Intent.ACTION_MAIN, null);

			if (bundle == null)
				bundle = new Bundle();
			// else ok.

			try {
				bundle.putInt("CallingPid", iCallingPid);
				intent.putExtras(bundle);
			} catch (Exception e) {
				e.printStackTrace();
			}

			intent.setClassName(packageName, className);
			mActivity.startActivity(intent);
		}

		/**
		 * when the msp loading dialog gone, call back this method.
		 */
		@Override
		public boolean isHideLoadingScreen() throws RemoteException {
			return false;
		}

		/**
		 * when the current trade is finished or cancelled, call back this method.
		 */
		@Override
		public void payEnd(boolean arg0, String arg1) throws RemoteException {

		}

	};
}