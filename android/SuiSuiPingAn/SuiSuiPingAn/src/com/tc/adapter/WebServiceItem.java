package com.tc.adapter;

public final class WebServiceItem {

	private String mPictureUrl; // 图片URL
	private String mArticleUrl; // 文章URL
	private String mTitle; // 文章标题
	
	public WebServiceItem(String mPictureUrl, String mArticleUrl, String mTitle) {
		this.mPictureUrl = mPictureUrl;
		this.mArticleUrl = mArticleUrl;
		this.mTitle = mTitle;
	}

	public String getmPictureUrl() {
		return mPictureUrl;
	}

	public void setmPictureUrl(String mPictureUrl) {
		this.mPictureUrl = mPictureUrl;
	}

	public String getmArticleUrl() {
		return mArticleUrl;
	}

	public void setmArticleUrl(String mArticleUrl) {
		this.mArticleUrl = mArticleUrl;
	}

	public String getmTitle() {
		return mTitle;
	}

	public void setmTitle(String mTitle) {
		this.mTitle = mTitle;
	}
	
}
