package com.tc.pay.alipay;

public class PartnerConfig {
	// 合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
	public static final String PARTNER = "2088711686468755";
	// 商户收款的支付宝账号
	public static final String SELLER = "2745812192@qq.com";
	// 商户（RSA）私钥
	public static final String RSA_PRIVATE = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL5NlsHlWA7nl4D09yBsyIvehBkN1EzWeYEgomoNOXufmiuD/qZKCMcDNlMT9nrUu+DDY7pV8Pgp7JKqd+e9I9GtZSYfy4cfA/bcK1gt4l9tKIDoRRXxA5DXZEdxiRz/wk59KsgAB+lVnrp5M21Utgy0cRuSpQX7hAOQKwGH8YZVAgMBAAECgYAGn5q0qu/SrPrX8S68wSyFubvtR07xUbGu7dzZRhaPF/H8u75cOU1u58y3PYWhps/XNdW9wYn+iS8Dt80ukqWxcifvNvtLxL1Fi1v+IW2GXYl/SYrvFMBLC+23s3ShPAN2gBjIxB6fQsc4iG3EPKaj0eIIdZlJTjs05pUW8TwmLQJBAO4WTe0tmIYe+ggoAAYVMo3jCA4H9dOScHam3+U0PMv/r40eLNg6fjaBIMniFn/vhVImrg0RYmN7cd7iqtVVTBMCQQDMnu+p3JXRdGM5hbPNKDfdJ4anCVEVUblvzisl8Hah5K55nPN+EJo2vg5x5LyUCCGkv48ezRy+65k8VqU5KmD3AkBlVN7jxFU3ODXohMXF0P3MP8Vs21x4KMpu5YVDcyExHeikoiQp/3M6VWkUI4K5/sJ6fXX0n+KFPsPvPf/BfmU7AkAHaLXa267dD67MFWhGRG+JZXX9tFuoPvZM8xUi4YsaH5KluqYiaW18D/Or8hFV9tlpArqm7dxdmWBKDAUdhchPAkEA3H+SbmiTIedq3nd2AowmQqMoKLXyQ+Yl3BfuVKXpn1wWFuTVLDirQZ5Wp6uXAb+pITtoFnet1Gf6bXrGYuV3yQ==";
	// 支付宝（RSA）公钥 用签约支付宝账号登录ms.alipay.com后，在密钥管理页面获取。
	public static final String RSA_ALIPAY_PUBLIC = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
	// 支付宝安全支付服务apk的名称，必须与assets目录下的apk名称一致
	public static final String ALIPAY_PLUGIN_NAME = "alipay_plugin_20120428msp.apk";
}
