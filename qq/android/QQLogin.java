package com.example.cordova.qqLogin;
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

import com.tencent.tauth.IUiListener;
import com.tencent.tauth.UiError;

import com.tencent.tauth.Tencent;

public class QQLogin extends CordovaPlugin{
	
	public static final String APPID ="123456789"; 
    private Tencent mTencent = null;
    private CallbackContext  mCallbackContext = null;
    

	@Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
		mCallbackContext=callbackContext;

        if (action.equals("ssoLogin")) {
        	this.ssoLogin();


        }else if(action.equals("ssoLogout")){
    		Context context = this.cordova.getActivity().getApplicationContext();

        	mTencent.logout(context);
			mCallbackContext.success();

        	
        }
        else {
            return false;
        }
        return true;
    }
	
	
	public void ssoLogin(){
        // 创建授权认证信息
		final Activity activity = this.cordova.getActivity();

		Context context = this.cordova.getActivity().getApplicationContext();
		mTencent = Tencent.createInstance(APPID, context);
		
		final IUiListener listener = new BaseUiListener() {
			@Override
			protected void doComplete(JSONObject values) {
				

			}
			
			
			
		};
		
		this.cordova.getActivity().runOnUiThread(new Runnable() {
	        @Override
	        public void run() {

	        	mTencent.login(activity, "all", listener);
	        }
	    });
		
		
	}
	
	

	private class BaseUiListener implements IUiListener {

		@Override
		public void onComplete(Object response) {
			String uid=mTencent.getOpenId();
            String token=mTencent.getAccessToken();
        	Log.d("uid111",uid);

            JSONObject res=new JSONObject();
            try {
       
                res.put("uid", uid);
				res.put("token", token);
                mCallbackContext.success(res);

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				mCallbackContext.error(0);
				e.printStackTrace();
			}

		}

		protected void doComplete(JSONObject values) {


		}

		@Override
		public void onError(UiError e) {
			mCallbackContext.error(0);


		}

		@Override
		public void onCancel() {
			
			mCallbackContext.error(0);

		}

		
	}


}
