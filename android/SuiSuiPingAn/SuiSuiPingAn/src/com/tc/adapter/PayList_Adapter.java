package com.tc.adapter;

import java.util.ArrayList;

import com.UCMobile.PayPlugin.PayInterface;
import com.tc.object.OBJ.Pay_Info;
import com.tc.tool.Utils;
import com.zphl.sspa0.R;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * @author yangyu 功能描述：ViewPager适配器，用来绑定数据和view
 */
public class PayList_Adapter extends BaseAdapter {

	// 界面列表
	private ArrayList<Pay_Info> pay_Infos;
	private Context context;
	private int selected = -1;

	public PayList_Adapter(ArrayList<Pay_Info> pay_Infos, Context context) {
		this.context = context;
		this.pay_Infos = pay_Infos;
	}

	/**
	 * 获得当前界面数
	 */
	@Override
	public int getCount() {
		if (pay_Infos != null) {
			return pay_Infos.size();
		}
		return 0;
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return 0;
	}

	public Pay_Info selected(int selected) {
		this.selected = selected;
		this.notifyDataSetChanged();
		return pay_Infos.get(selected);
	}

	public Pay_Info setFirstChose() {
		return this.selected(0);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		if (convertView == null) {
			convertView = LayoutInflater.from(context).inflate(R.layout.my_paytype_item, null);
		}
		ImageView payImg = (ImageView) convertView.findViewById(R.id.pay_type_item_img);
		ImageView paySelect = (ImageView) convertView.findViewById(R.id.pay_type_item_select);
		paySelect.setImageResource(R.drawable.ic_radio_btn_off);
		TextView payName = (TextView) convertView.findViewById(R.id.pay_type_item_name);
		TextView payNamedes = (TextView) convertView.findViewById(R.id.pay_type_item_namedes);
		TextView payId = (TextView) convertView.findViewById(R.id.pay_type_item_id);
		payName.setText(pay_Infos.get(position).getName());
		payId.setText(pay_Infos.get(position).getId());
		System.out.println("payName"+pay_Infos.get(position).getName());
		System.out.println("payId"+pay_Infos.get(position).getId());
		if (pay_Infos.get(position).getId().equals("1")) {				//银联
			payImg.setImageResource(R.drawable.ic_uppay_plugin_enabled);
			payNamedes.setText(R.string.paylist_yinlian);
		} else if (pay_Infos.get(position).getId().equals("2")) {		//支付宝
			payImg.setImageResource(R.drawable.ic_alipay_plugin_enabled);
			payNamedes.setText(R.string.paylist_ali);
		} else if (pay_Infos.get(position).getId().equals("3")) {		//卡密
			payImg.setImageResource(R.drawable.ic_card_plugin_enabled);
			payNamedes.setText(R.string.paylist_card);
		} else if (pay_Infos.get(position).getId().equals("6")) {		//话费代付
//			if (Utils.phone_Info.getIMSI_NAME().equals("中国联通")) {
//				payImg.setImageResource(R.drawable.ic_liantong_plugin_enabled);
//				payNamedes.setText(R.string.paylist_mobile);
//			} else 
			if (Utils.phone_Info.getIMSI_NAME().equals("中国移动")) {
				payImg.setImageResource(R.drawable.ic_yidong_plugin_enabled);
				payNamedes.setText(R.string.paylist_mobile);
			} else { //隐藏其他运营商话费支付
				payImg.setVisibility(View.GONE);
				payName.setVisibility(View.GONE);
				payNamedes.setVisibility(View.GONE);
				paySelect.setVisibility(View.GONE);
			}
//				else if (Utils.phone_Info.getIMSI_NAME().equals("中国电信")) {
//				payImg.setImageResource(R.drawable.ic_dianxin_plugin_enabled);
//				payNamedes.setText(R.string.paylist_mobile);
//			}
			if (!Utils.main_info.getInsur()) {
				payImg.setVisibility(View.GONE);
				payName.setVisibility(View.GONE);
				payNamedes.setVisibility(View.GONE);
				paySelect.setVisibility(View.GONE);
			}
		}

		if (position == selected) {
			paySelect.setImageResource(R.drawable.ic_radio_btn_on);
			if (pay_Infos.get(position).getId().equals("6")) {
				Utils.Pay_Mobile_Flag = true;
			} else {
				Utils.Pay_Mobile_Flag = false;
			}
		} else {
			paySelect.setImageResource(R.drawable.ic_radio_btn_off);
		}

		return convertView;
	}

}
