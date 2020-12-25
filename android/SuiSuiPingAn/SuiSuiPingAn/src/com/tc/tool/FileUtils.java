package com.tc.tool;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import com.tc.in.InfoMation;


import android.os.Environment;

/**
 * @see <b>主要作用：用于创建SD卡目录或文件,判断目录或文件是否存在</b>
 * @author 罗超
 */
public class FileUtils {

	private String SDPATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/";

	/**
	 * 在SD卡上创建文件
	 * 
	 * @param fileName
	 *            需要创建的文件名
	 * @return File
	 * @throws IOException
	 */
	public File creatSDFile(String fileName) throws IOException {
		File file = new File(SDPATH + fileName);
		file.createNewFile();
		return file;
	}

	/**
	 * 在SD卡上删除文件
	 * 
	 * @param fileName
	 *            需要删除的文件名
	 * @return boolean true删除成功 false删除失败
	 * @throws IOException
	 */
	public static boolean delSDFile(String fileName) throws IOException {
		File file = new File(fileName);
		boolean b = file.delete();
		return b;
	}

	/**
	 * 在SD卡上创建目录
	 * 
	 * @param dirName
	 *            需要创建的目录名
	 * @return File
	 */
	public File creatSDDir(String dirName) {
		File dir = new File(SDPATH + dirName);
		dir.mkdir();
		return dir;
	}

	/**
	 * 判断SD卡上的目录是否存在
	 * 
	 * @param fileName
	 *            需要查找的目录名
	 * @return boolean true有，false无
	 */
	public static boolean isFileYES(String fileName) {
		File SDimg = new File(fileName);
		return SDimg.exists();
	}

	/**
	 * 将一个InputStream里面的数据写入到SD卡中
	 * 
	 * @param path
	 *            需要写入的地址
	 * @param fileName
	 *            需要写入的文件名
	 * @param input
	 *            InputStream流
	 * @return File
	 */
	public File write2SDFromInput(String path, String fileName, InputStream input) {
		File file = null;
		OutputStream output = null;
		try {
			creatSDDir(path);
			file = creatSDFile(path + fileName);
			output = new FileOutputStream(file);
			byte buffer[] = new byte[4 * 1024];
			while ((input.read(buffer)) != -1) {
				output.write(buffer);
			}
			output.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				output.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return file;
	}

	/**
	 * 创建目录/mnt/sdcard/xxx
	 */
	public static void creatDir() {
		// 当下载到SD卡的目录不存在的时候，就创建 （/mnt/sdcard/xxx）
		File SDRoot = new File(InfoMation.APP_PATH);
		if (!SDRoot.exists()) {
			SDRoot.mkdir();
		} else {
			SDRoot = null;
		}
		// 创建SP文件夹
		File SDDir = new File(InfoMation.APP_DOWN_PATH);
		if (!SDDir.exists()) {
			SDDir.mkdir();
		} else {
			SDDir = null;
		}

		File SDPic = new File(InfoMation.APP_IMG_PATH);
		if (!SDPic.exists()) {
			SDPic.mkdir();
		} else {
			SDPic = null;
		}
		File SDApp = new File(InfoMation.APP_APP_PATH);
		if (!SDApp.exists()) {
			SDApp.mkdir();
		} else {
			SDApp = null;
		}

	}

	public void downImage(String imageURL, String saveImagePath) {
		try {
			URL downUrl = new URL(imageURL);
			HttpURLConnection conn = (HttpURLConnection) downUrl.openConnection();
			// 获取文件大小，然后用消息发送
			// int size = conn.getContentLength();
			// 获得输入流.把文件下载到本地
			InputStream is = conn.getInputStream();
			FileOutputStream fos = new FileOutputStream(saveImagePath);

			byte[] data = new byte[1024];
			int i = -1;
			while ((i = is.read(data)) != -1) {
				fos.write(data, 0, i);
			}
			is.close();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}