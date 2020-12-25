package com.tc.myview;

import java.util.ArrayList;
import java.util.HashMap;

import com.tc.in.InfoMation;
import com.tc.object.OBJ.Service_Info_Mini;
import com.tc.thread.Thread_Post;
import com.tc.tool.MSG_TYPE;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

/**
 * 自定义实现的spinner
 * 
 * @author A Shuai
 * 
 */
public class MySpinner extends Button {

	private Context context = null;
	private OnItemSelectedListener listener = null;
	private ArrayList<Service_Info_Mini> service_minis = null;
	private SpinnerDropDownPopupWindow dropDown = null;
	private ListView listView = null;
	private Handler handler = null;
	private int POST_TYPE = MSG_TYPE.POST_SERVICE;

	/**
	 * 构造方法
	 * 
	 * @param context
	 */
	public MySpinner(Context context) {
		this(context, null);
	}

	public MySpinner(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public MySpinner(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	private void init(Context context) {
		this.context = context;
		service_minis = new ArrayList<Service_Info_Mini>();
		setOnClickListener(new SpinnerButtonOnClickListener());
	}

	/**
	 * 设置spinner的监听器，用于回调，务必在显示下拉列表前载入
	 */
	public void setOnItemSelectedListener(OnItemSelectedListener listener) {
		this.listener = listener;
	}

	/**
	 * 这个方法在显示前调用，装载入数据
	 * 
	 * @param service_minis
	 */
	public void setData(ArrayList<Service_Info_Mini> service_minis, Handler handler) {
		this.service_minis = service_minis;
		this.handler = handler;
		dropDown = new SpinnerDropDownPopupWindow(context);
	}

	class SpinnerButtonOnClickListener implements OnClickListener {

		public void onClick(View v) {
			// if (dropDown == null) {
			// dropDown = new SpinnerDropDownPopupWindow(context);
			// }
			if (!dropDown.isShowing()) {
				dropDown.showAsDropDown(MySpinner.this);
			}
		}

	}

	public void setFirstChose() {
		if (!service_minis.isEmpty()) {
			MySpinner.this.setText(service_minis.get(0).getName());
			/*********************** 适配字体 ***************************/
			if (Utils.dm.widthPixels > 950) {
			} else if (Utils.dm.widthPixels > 820 && Utils.dm.widthPixels < 950) {
				MySpinner.this.setTextSize(15);
			} else if (Utils.dm.widthPixels < 820) {
				MySpinner.this.setTextSize(13);
			}
			listView.setSelection(0);
			HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_SER_ONE, Utils.user_Info.getPhone(), service_minis.get(0).getId(), null, null, null, null);
			new Thread_Post((Activity) context, handler, InfoMation.URL_SER, map, POST_TYPE).start();
		}
	}

	class SpinnerDropDownPopupWindow extends PopupWindow {

		private LayoutInflater inflater = null;
		private SpinnerDropdownAdapter adapter = null;

		public SpinnerDropDownPopupWindow(Context context) {
			super(context);
			inflater = LayoutInflater.from(context);
			adapter = new SpinnerDropdownAdapter();
			View view = inflater.inflate(R.layout.my_spinner, null);
			listView = (ListView) view.findViewById(R.id.my_spinner_list);
			listView.setAdapter(adapter);
			listView.setOnItemClickListener(new SpinnerListOnItemClickListener());
			setWidth(MySpinner.this.getLayoutParams().width);
			setHeight(LayoutParams.WRAP_CONTENT);
			// 这个是为了点击“返回Back”也能使其消失，并且并不会影响你的背景
			setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
			setFocusable(true); // 得到焦点
			setOutsideTouchable(true); // 点击布局外失去焦点
			setContentView(view);
		}

		public void showAsDropDown(View view) {
			showAsDropDown(view, 0, 0);
			update(); // 刷新
		}

		/**
		 * 适配器
		 */
		private final class SpinnerDropdownAdapter extends BaseAdapter {

			public int getCount() {
				return service_minis.size();
			}

			public Object getItem(int position) {
				return service_minis.get(position);
			}

			public long getItemId(int position) {
				return position;
			}

			public View getView(int position, View v, ViewGroup parent) {
				if (v == null) {
					v = LayoutInflater.from(context).inflate(com.zphl.sspa0.R.layout.my_spinner_item, null);
				}
				TextView serName = (TextView) v.findViewById(R.id.spinner_sername);
				TextView serId = (TextView) v.findViewById(R.id.spinner_serid);
				serName.setText(service_minis.get(position).getName());
				serId.setText(service_minis.get(position).getId());

				return v;
			}

		}

		class SpinnerListOnItemClickListener implements OnItemClickListener {

			public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
				HashMap<String, String> map = Utils.Get_Map(MSG_TYPE.MAP_SER_ONE, Utils.user_Info.getPhone(), service_minis.get(position).getId(), null, null, null, null);
				new Thread_Post((Activity) context, handler, InfoMation.URL_SER, map, POST_TYPE).start();
				TextView serName = (TextView) v.findViewById(R.id.spinner_sername);
				MySpinner.this.setText(serName.getText().toString());
				listener.onItemSelected(parent, v, position, id);
				SpinnerDropDownPopupWindow.this.dismiss();
			}

		}

	}

}