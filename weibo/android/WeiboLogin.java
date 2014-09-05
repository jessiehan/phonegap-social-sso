package com.example.cordova.weiboLogin;
import java.text.SimpleDateFormat;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.sina.weibo.sdk.api.share.IWeiboShareAPI;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.WeiboAuth;
import com.sina.weibo.sdk.auth.WeiboAuthListener;
import com.sina.weibo.sdk.auth.WeiboAuth.AuthInfo;
import com.sina.weibo.sdk.auth.sso.SsoHandler;


import com.sina.weibo.sdk.exception.WeiboException;

public class WeiboLogin extends CordovaPlugin{
	public static final String SCOPE = 
            "email,direct_messages_read"
            + "friendships_groups_read,friendships_groups_write,statuses_to_me_read,"
            + "follow_app_official_microblog," + "invitation_write";
	public static final String APPKEY ="123456789"; 
	public static final String REDIRECT_URL ="https://api.weibo.com/oauth2/default.html"; 
    private CallbackContext  mCallbackContext = null;
    private  SsoHandler mSsoHandler=null;


	@Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
		mCallbackContext=callbackContext;

        if (action.equals("ssoLogin")) {
        	
        	Log.d("登陆","登陆");
        	this.ssoLogin();


        } 

        else {
            return false;
        }
        return true;
    }
	
	
	public void ssoLogin(){
        // 创建授权认证信息
		Context context = this.cordova.getActivity().getApplicationContext();

        AuthInfo authInfo = new AuthInfo(context,APPKEY,REDIRECT_URL,SCOPE);
		WeiboAuth weiboAuth = new WeiboAuth(context, authInfo);
		mSsoHandler=new SsoHandler(this.cordova.getActivity(), weiboAuth);
		//important
		
		this.cordova.setActivityResultCallback(this);
		mSsoHandler.authorize(new AuthListener());
	}
	
	/**
     * 当 SSO 授权 Activity 退出时，该函数被调用。
     * 
     * @see {@link Activity#onActivityResult}
     */
    @Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {

        System.out.println("登陆！！！！！！！！！！！！！！！！");

        super.onActivityResult(requestCode, resultCode, data);

        // SSO 授权回调
        // 重要：发起 SSO 登陆的 Activity 必须重写 onActivityResult
        if (mSsoHandler != null) {
            mSsoHandler.authorizeCallBack(requestCode, resultCode, data);
        }
    }

	 
 
	/**
     * 登入按钮的监听器，接收授权结果。
     */
	private class AuthListener implements WeiboAuthListener {
        @Override
        public void onComplete(Bundle values) {
            Oauth2AccessToken accessToken = Oauth2AccessToken.parseAccessToken(values);
            System.out.println("完成！！！！！！！！！！！");

            if (accessToken != null && accessToken.isSessionValid()) {
                String uid=accessToken.getUid();
                String token=accessToken.getToken();
                JSONObject res=new JSONObject();
                try {
                	
                    res.put("uid", uid);
					res.put("token", token);
	                mCallbackContext.success(res);
	            	Log.d("uid",uid);

				} catch (JSONException e) {
					// TODO Auto-generated catch block
					mCallbackContext.error(0);
					e.printStackTrace();
				}

                

            }
        }

        @Override
        public void onWeiboException(WeiboException e) {
            System.out.println("有问题！！！！！！！！！！！");

			mCallbackContext.error(0);
        }

        @Override
        public void onCancel() {
            System.out.println("有问题！！！！！！！！！！！");

			mCallbackContext.error(0);


        }
    }

	

}
