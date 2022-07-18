package com.sharepoint.flutter_msal;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.microsoft.identity.client.AuthenticationCallback;
import com.microsoft.identity.client.IAccount;
import com.microsoft.identity.client.IAuthenticationResult;
import com.microsoft.identity.client.IMultipleAccountPublicClientApplication;
import com.microsoft.identity.client.IPublicClientApplication;
import com.microsoft.identity.client.PublicClientApplication;
import com.microsoft.identity.client.SilentAuthenticationCallback;
import com.microsoft.identity.client.exception.MsalException;

import java.text.SimpleDateFormat;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerDelegate implements MethodChannel.MethodCallHandler {
    private final Context context;
    @Nullable private Activity activity;
    @Nullable private IMultipleAccountPublicClientApplication application;

    public MethodCallHandlerDelegate(@Nullable Activity activity, @NonNull Context context, @NonNull MethodChannel channel) {
        this.activity = activity;
        this.context = context;
    }

    public void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        MethodChannel.Result wrappedResult = new MethodResultWrapper(result);
        switch (call.method) {
            case FlutterMsalPlugin.Methods.INITIALIZE:
                initialize((String) call.argument("clientId"),
                        (String) call.argument("authority"),
                        (String) call.argument("redirectUri"),
                        wrappedResult);
                break;
            case FlutterMsalPlugin.Methods.SIGN_IN:
                List<String> signInScopes = call.argument("scopes");
                signIn(signInScopes, wrappedResult);
                break;
            case FlutterMsalPlugin.Methods.SIGN_IN_SILENT:
                List<String> signInSilentScopes = call.argument("scopes");
                signInSilent(signInSilentScopes, wrappedResult);
                break;
            case FlutterMsalPlugin.Methods.SIGN_OUT:
                signOut(wrappedResult);
                break;
            default:
                wrappedResult.notImplemented();
        }
    }

    private void initialize(String clientId, String authority, String redirectUri, MethodChannel.Result result) {
        if (clientId == null) {
            result.error("no_client_id", "A null or empty client ID was provided.", null);
            return;
        }

        if (redirectUri == null) {
            result.error("no_redirect_uri", "A null or empty redirect URI was provided.", null);
            return;
        }

        if (application != null) {
            if (application.getConfiguration().getClientId().equals(clientId)) {
                result.success(true);
            } else {
                result.error("conflicting_client_id", "MSAL has already been initialized with a different client ID.", null);
            }
            return;
        }

        PublicClientApplication.create(context, clientId, authority, redirectUri, new IPublicClientApplication.ApplicationCreatedListener() {
            @Override
            public void onCreated(IPublicClientApplication app) {
                application = (IMultipleAccountPublicClientApplication) app;
                result.success(true);
            }

            @Override
            public void onError(MsalException exception) {
                result.error(exception.getErrorCode(), exception.getMessage(), null);
            }
        });
    }

    private void signIn(List<String> scopes, MethodChannel.Result result) {
        if (application == null) {
            result.error("not_initialized", "MSAL needs to be initialized before acquiring tokens.", null);
            return;
        }

        if (activity == null) {
            result.error("no_activity", "No activity has been attached.", null);
        }

        application.acquireToken(activity, scopes.toArray(new String[0]), new AuthenticationCallback() {
            @Override
            public void onCancel() {
                result.error("request_cancelled", "User manually cancelled the request.", null);
            }

            @Override
            public void onSuccess(IAuthenticationResult authenticationResult) {
                result.success(Serializer.serializeAuthenticationResult(authenticationResult));
            }

            @Override
            public void onError(MsalException exception) {
                result.error(exception.getErrorCode(), exception.getMessage(), null);
            }
        });
    }

    private void signInSilent(List<String> scopes, MethodChannel.Result result) {
        if (application == null) {
            result.error("not_initialized", "MSAL needs to be initialized before acquiring tokens.", null);
            return;
        }

        try {
            IAccount currentAccount = application.getAccounts().get(0);

            if (currentAccount == null) {
                result.error("no_account_found", "Cannot acquire token silently because no account has been found.", null);
                return;
            }

            application.acquireTokenSilentAsync(scopes.toArray(new String[0]), currentAccount, currentAccount.getAuthority(), new SilentAuthenticationCallback() {
                @Override
                public void onSuccess(IAuthenticationResult authenticationResult) {
                    result.success(Serializer.serializeAuthenticationResult(authenticationResult));
                }

                @Override
                public void onError(MsalException exception) {
                    result.error(exception.getErrorCode(), exception.getMessage(), null);
                }
            });
        } catch (InterruptedException e) {
            result.error("interrupted", e.getMessage(), null);
        } catch (MsalException exception) {
            result.error(exception.getErrorCode(), exception.getMessage(), null);
        }
    }

    private void signOut(MethodChannel.Result result) {
        if (application == null) {
            result.error("not_initialized", "MSAL needs to be initialized before acquiring tokens.", null);
            return;
        }

        application.getAccounts(new IPublicClientApplication.LoadAccountsCallback() {
            @Override
            public void onTaskCompleted(List<IAccount> accounts) {
                IAccount account = accounts.get(0);

                if (account == null) {
                    result.success(false);
                    return;
                }

                application.removeAccount(account, new IMultipleAccountPublicClientApplication.RemoveAccountCallback() {
                    @Override
                    public void onRemoved() {
                        result.success(true);
                    }

                    @Override
                    public void onError(@NonNull MsalException exception) {
                        result.error(exception.getErrorCode(), exception.getMessage(), null);
                    }
                });
            }

            @Override
            public void onError(MsalException exception) {
                result.error(exception.getErrorCode(), exception.getMessage(), null);
            }
        });
    }

    static final class Serializer {
        private Serializer() {}

        static HashMap<String, Object> serializeAuthenticationResult(IAuthenticationResult authenticationResult) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");

            return new HashMap<String, Object>() {{
                put("accessToken", authenticationResult.getAccessToken());
                put("expiresOn", sdf.format(authenticationResult.getExpiresOn()));
                put("scopes", Arrays.asList(authenticationResult.getScope()));
                put("idToken", authenticationResult.getAccount().getIdToken());
                put("tenantId", authenticationResult.getTenantId());
                put("account", serializeAccount(authenticationResult.getAccount()));
                put("correlationId", authenticationResult.getCorrelationId() == null ? null : authenticationResult.getCorrelationId().toString());
                put("authorizationHeader", authenticationResult.getAuthorizationHeader());
                put("authenticationScheme", authenticationResult.getAuthenticationScheme());
            }};
        }

        static HashMap<String, Object> serializeAccount(IAccount account) {
            return new HashMap<String, Object>() {{
                put("homeAccountId", new HashMap<String, Object>() {{
                    put("identifier", account.getId());
                    put("objectId", account.getId());
                    put("tenantId", account.getTenantId());
                }});
            }};
        }
    }

    private static class MethodResultWrapper implements MethodChannel.Result {
        private MethodChannel.Result methodResult;
        private Handler handler;

        MethodResultWrapper(MethodChannel.Result result) {
            methodResult = result;
            handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.success(result);
                }
            });
        }

        @Override
        public void error(final String errorCode, final String errorMessage, final Object errorDetails) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.error(errorCode, errorMessage, errorDetails);
                }
            });
        }

        @Override
        public void notImplemented() {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    methodResult.notImplemented();
                }
            });
        }
    }
}
