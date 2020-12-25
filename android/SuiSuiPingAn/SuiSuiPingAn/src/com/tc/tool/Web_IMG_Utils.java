package com.tc.tool;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.tc.adapter.WebServiceItem;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;


public class Web_IMG_Utils {

	public static Object getData(String url_address, Class<?> c)
			throws Exception {
		URL url = new URL(url_address);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setConnectTimeout(5000);
		conn.setRequestMethod("GET");
		if (conn.getResponseCode() == 200) {
			byte[] b = readInputStream(conn.getInputStream());
			if (c == String.class) {
				String temp = new String(b);
				return temp;
			} else {
				Bitmap temp = BitmapFactory.decodeByteArray(b, 0, b.length);
				return temp;
			}
		}
		return null;
	}

	private static byte[] readInputStream(InputStream in) throws Exception {
		// TODO Auto-generated method stub
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		byte[] b = new byte[1024];
		int len = 0;
		while ((len = in.read(b)) != -1) {
			baos.write(b, 0, len);
		}
		in.close();
		return baos.toByteArray();
	}

	public static String toJson(Object object) {
		Gson gson = new Gson();
		String temp = gson.toJson(object);
		return temp;
	}

	public static List<WebServiceItem> fromJson(String jsonStr)
			throws Exception {
		Gson gson = new Gson();
		Type list = new TypeToken<List<WebServiceItem>>() {
		}.getType();
		List<WebServiceItem> data = gson.fromJson(jsonStr, list);
		return data;
	}

}
