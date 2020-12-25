package com.tc.myview;

import java.util.ArrayList;

import com.tc.object.OBJ.Service_Info_Order;
import com.tc.tool.MSG_TYPE;
import com.zphl.sspa0.R;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Handler;
import android.os.Message;
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
public class MyOrderSpinner extends Button {

	private Context context = null;
	private OnItemSelectedListener listener = null;
	private ArrayList<Service_Info_Order> service_Orders = null;
	private SpinnerDropDownPopupWindow dropDown = null;
	private ListView listView = null;
	private Handler handler;
	private int MESAAG_TYPE = MSG_TYPE.MESSAGE_ORDER_SER;
	// 当前选中的那一项
	private Service_Info_Order myOrder;

	/**
	 * 构造方法
	 * 
	 * @param context
	 */
	public MyOrderSpinner(Context context) {
		this(context, null);
	}

	public MyOrderSpinner(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}

	public MyOrderSpinner(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	private void init(Context context) {
		this.context = context;
		service_Orders = new ArrayList<Service_Info_Order>();
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
	public void setData(ArrayList<Service_Info_Order> service_Orders, Handler handler) {
		this.handler = handler;
		this.service_Orders = service_Orders;
		dropDown = new SpinnerDropDownPopupWindow(context);

	}

	class SpinnerButtonOnClickListener implements OnClickListener {

		public void onClick(View v) {
			// if (dropDown == null) {
			// dropDown = new SpinnerDropDownPopupWindow(context);
			// }
			if (!dropDown.isShowing()) {
				dropDown.showAsDropDown(MyOrderSpinner.this);
			}
		}

	}

	public void setFirstChose() {
		if (!service_Orders.isEmpty()) {
			MyOrderSpinner.this.setText(service_Orders.get(0).getImei());
			listView.setSelection(0);
			// 设置当前选中的那一项
			myOrder = service_Orders.get(0);
			Message msg = new Message();
			msg.obj = service_Orders.get(0);
			msg.what = MESAAG_TYPE;
			handler.sendMessage(msg);
		}
	}

	public void setOrders(Service_Info_Order order) {
		MyOrderSpinner.this.setText(order.getImei());
		listView.setSelection(0);
		// 设置当前选中的那一项
		myOrder = order;
		Message msg = new Message();
		msg.obj = order;
		msg.what = MESAAG_TYPE;
		handler.sendMessage(msg);
	}

	public Service_Info_Order getMyOrder() {
		if (myOrder != null)
			return myOrder;
		return null;
	}

	class SpinnerDropDownPopupWindow extends PopupWindow {

		private LayoutInflater inflater = null;
		private SpinnerDropdownAdapter adapter = null;

		public SpinnerDropDownPopupWindow(Context context) {
			super(context);
			inflater = LayoutInflater.from(context);
			adapter = new SpinnerDropdownAdapter();
			View view = inflater.inflate(R.layout.my_order_spinner, null);
			listView = (ListView) view.findViewById(R.id.my_order_spinner_list);
			listView.setAdapter(adapter);
			listView.setOnItemClickListener(new SpinnerListOnItemClickListener());
			setWidth(MyOrderSpinner.this.getLayoutParams().width);
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
				return service_Orders.size();
			}

			public Object getItem(int position) {
				return service_Orders.get(position);
			}

			public long getItemId(int position) {
				return position;
			}

			public View getView(int position, View v, ViewGroup parent) {
				if (v == null) {
					v = LayoutInflater.from(context).inflate(com.zphl.sspa0.R.layout.my_order_spinner_item, null);
				}
				TextView imei = (TextView) v.findViewById(R.id.order_spinner_imei);
//				TextView sid = (TextView) v.findViewById(R.id.order_spinner_sid);
//				TextView uid = (TextView) v.findViewById(R.id.order_spinner_uid);
				TextView dtime = (TextView) v.findViewById(R.id.order_spinner_dtime);
				TextView outtime = (TextView) v.findViewById(R.id.order_spinner_outtime);
//				TextView utime = (TextView) v.findViewById(R.id.order_spinner_utime);
				imei.setText(service_Orders.get(position).getImei());
				dtime.setText(service_Orders.get(position).getDtime());
				outtime.setText(service_Orders.get(position).getExpire());
				return v;
			}

		}

		class SpinnerListOnItemClickListener implements OnItemClickListener {

			public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
				/**************** 把选中的这一项发送到Activity进行获取显示 ***************/
				TextView imei = (TextView) v.findViewById(R.id.order_spinner_imei);
//				TextView sid = (TextView) v.findViewById(R.id.order_spinner_sid);
//				TextView uid = (TextView) v.findViewById(R.id.order_spinner_uid);
				TextView dtime = (TextView) v.findViewById(R.id.order_spinner_dtime);
				TextView outtime = (TextView) v.findViewById(R.id.order_spinner_outtime);
//				TextView utime = (TextView) v.findViewById(R.id.order_spinner_utime);
				Service_Info_Order order = new Service_Info_Order();
				order.setImei(imei.getText().toString());
				order.setDtime(dtime.getText().toString());
				order.setExpire(outtime.getText().toString());
				Message msg = new Message();
				msg.obj = order;
				msg.what = MESAAG_TYPE;
				handler.sendMessage(msg);
				// 设置当前选中的那一项
				myOrder = order;
				/**************************************************************************/
				MyOrderSpinner.this.setText(imei.getText().toString());
				listener.onItemSelected(parent, v, position, id);
				SpinnerDropDownPopupWindow.this.dismiss();
			}

		}

	}

}