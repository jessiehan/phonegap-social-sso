package com.example.cordova.renrenLogin;
import java.text.SimpleDateFormat;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.util.Log;

import com.renn.rennsdk.RennClient;
import com.renn.rennsdk.RennClient.LoginListener;

public class RenrenLogin extends CordovaPlugin{
	
	public static final String APP_ID ="123456"; 
	public static final String API_KEY ="1234567890"; 
	public static final String SECRET_KEY ="1234567890"; 

    private RennClient rennClient = null;
    private CallbackContext  mCallbackContext = null;


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

		rennClient = RennClient.getInstance(context);//获取实例
		rennClient.init(APP_ID, API_KEY, SECRET_KEY);//设置应用程序信息
		rennClient.setScope("read_user_status");
		rennClient.login(this.cordova.getActivity());
 
		rennClient.setLoginListener(new LoginListener() {
			@Override
			public void onLoginSuccess() {
				// TODO Auto-generated method stub
				String uid=rennClient.getUid().toString();
	            String token=rennClient.getAccessToken().accessToken;
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
			@Override
			public void onLoginCanceled() {
				// TODO Auto-generated method stub
				mCallbackContext.error(0);

			}

		});
		
	}
	
	
	


}
