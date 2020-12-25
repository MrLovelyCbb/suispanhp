package com.tc.thread;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.http.client.ClientProtocolException;

import com.tc.in.InfoMation;
import com.tc.tool.MSG_TYPE;


import android.os.Handler;
import android.os.Message;

public class Thread_DownApk extends Thread {
	private Handler handler;
	private String apkUrl;
	private String saveApkPath;
	private int size;

	public Thread_DownApk(Handler handler, String apkUrl, String saveApkPath) {
		this.apkUrl = apkUrl;
		this.handler = handler;
		this.saveApkPath = saveApkPath;
	}

	@Override
	public void run() {

		try {
			URL downUrl = new URL(apkUrl);
			HttpURLConnection conn = (HttpURLConnection) downUrl.openConnection();
			// 获取文件大小，然后用消息发送
			size = conn.getContentLength();
			// 获得输入流.把文件下载到本地
			InputStream is = conn.getInputStream();
			// 开始下载,用tmp记录
			File tmpFile = new File(InfoMation.APP_APP_PATH + apkUrl.hashCode() + ".tmp");
			FileOutputStream fos = new FileOutputStream(tmpFile);

			Message startMsg = handler.obtainMessage();
			startMsg.arg1 = 100;
			startMsg.arg2 = size / (1024 * 1024);
			startMsg.what = MSG_TYPE.THREAD_DOWN_APK_START;
			handler.sendMessage(startMsg);

			byte[] data = new byte[1024];
			int i = -1;
			int to = 0;
			while ((i = is.read(data)) != -1) {
				fos.write(data, 0, i);
				to += i;
				Message msg = handler.obtainMessage();
				msg.arg1 = (int) (intTofloat(to) * 100 / size);
				msg.arg2 = to / (1024 * 1024);
				msg.what = MSG_TYPE.THREAD_DOWN_APK_LOADING;
				handler.sendMessage(msg);
				try {
					Thread.sleep(15);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			// 下载完成，修改文件名
			File newFile = new File(saveApkPath);
			tmpFile.renameTo(newFile);
			// 下载完成,发送消息
			Message msg = handler.obtainMessage();
			msg.obj = saveApkPath;
			msg.what = MSG_TYPE.THREAD_DOWN_APK_END;
			handler.sendMessage(msg);
			// handler.sendEmptyMessage(MessageType.downApk_End);
			is.close();
			fos.close();

		} catch (ClientProtocolException e) {
			handler.sendEmptyMessage(MSG_TYPE.THREAD_HTTP_ERROR);
		} catch (UnsupportedEncodingException e) {
			handler.sendEmptyMessage(MSG_TYPE.THREAD_UTF8_ERROR);
		} catch (IOException e) {
			handler.sendEmptyMessage(MSG_TYPE.THREAD_IO_ERROR);
		} catch (Exception e) {
			handler.sendEmptyMessage(MSG_TYPE.THREAD_ERROR);
		}
	}

	public Float intTofloat(int i) {
		return Float.parseFloat(i + "");
	}
}
