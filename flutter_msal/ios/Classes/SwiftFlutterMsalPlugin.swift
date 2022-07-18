import Flutter
import UIKit
import MSAL

public class SwiftFlutterMsalPlugin: NSObject, FlutterPlugin {
    private var application: MSALPublicClientApplication?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.shareitsolutions.flutter_msal", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMsalPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]

        switch call.method {
        case "initialize":
            initialize(arguments, result)
        case "signIn":
            signIn(arguments, result)
        case "signInSilent":
            signInSilent(arguments, result)
        case "signOut":
            signOut(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initialize(_ arguments: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let clientId = arguments?["clientId"] as? String else {
            return result(FlutterError(code: "no_client_id", message: "A null or empty client ID was provided.", details: nil))
        }

        guard let redirectUri = arguments?["redirectUri"] as? String else {
            return result(FlutterError(code: "no_redirect_uri", message: "A null or empty redirect URI was provided.", details: nil))
        }

        if let application = application, application.configuration.clientId != clientId {
            return result(FlutterError(code: "conflicting_client_id", message: "MSAL has already been initialized with a different client ID.", details: nil))
        }

        do {
            var authority: MSALAuthority?

            if let authorityRaw = arguments?["authority"] as? String, let authorityURL = URL(string: authorityRaw) {
                authority = try MSALAuthority(url: authorityURL)
            }

            let configuration = MSALPublicClientApplicationConfig(
                clientId: clientId,
                redirectUri: redirectUri,
                authority: authority
            )

            application = try MSALPublicClientApplication(configuration: configuration)

            result(true)
        } catch let error as NSError {
            result(error.asFlutterError())
        }
    }

    private func signIn(_ arguments: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let application = application else {
            return result(FlutterError(code: "not_initialized", message: "MSAL needs to be initialized before acquiring tokens.", details: nil))
        }

        guard let scopes = arguments?["scopes"] as? [String] else {
            return result(FlutterError(code: "no_scopes", message: "Scopes missing when acquiring tokens.", details: nil))
        }

        guard let keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow) ?? UIApplication.shared.windows.first,
              let authPresentationViewController = keyWindow.rootViewController
        else {
            return result(FlutterError(code: "no_activity", message: "No activity has been attached.", details: nil))
        }
        let webviewParameters = MSALWebviewParameters(authPresentationViewController: authPresentationViewController)
        let interactiveTokenParamenters = MSALInteractiveTokenParameters(scopes: scopes, webviewParameters: webviewParameters)
        interactiveTokenParamenters.promptType = .login

        application.acquireToken(with: interactiveTokenParamenters) { msalResult, error in
            if let error = error as NSError? {
                return result(error.asFlutterError())
            }

            guard let msalResult = msalResult else {
                return result(FlutterError(code: "empty_result", message: "Expected a non-empty result.", details: nil))
            }

            let response: [String: Any?] = [
                "accessToken": msalResult.accessToken,
                "expiresOn": msalResult.expiresOn == nil ? nil : ISO8601DateFormatter().string(from: msalResult.expiresOn!),
                "scopes": msalResult.scopes,
                "idToken": msalResult.idToken,
                "tenantId": msalResult.tenantProfile.tenantId,
                "account": [
                    "homeAccountId": msalResult.account.homeAccountId == nil ? nil : [
                        "identifier": msalResult.account.homeAccountId!.identifier,
                        "objectId": msalResult.account.homeAccountId!.objectId,
                        "tenantId": msalResult.account.homeAccountId!.tenantId
                    ]
                ],
                "correlationId": msalResult.correlationId.uuidString,
                "authorizationHeader": msalResult.authorizationHeader,
                "authenticationScheme": msalResult.authenticationScheme
            ]

            result(response)
        }
    }

    private func signInSilent(_ arguments: [String: Any]?, _ result: @escaping FlutterResult) {
        guard let application = application else {
            return result(FlutterError(code: "not_initialized", message: "MSAL needs to be initialized before acquiring tokens.", details: nil))
        }

        guard let scopes = arguments?["scopes"] as? [String] else {
            return result(FlutterError(code: "no_scopes", message: "Scopes missing when acquiring tokens.", details: nil))
        }

        guard let account = try? application.allAccounts().first else {
            return result(FlutterError(code: "no_account_found", message: "Cannot acquire token silently because no account has been found.", details: nil))
        }

        let silentTokenParameters = MSALSilentTokenParameters(scopes: scopes, account: account)

        application.acquireTokenSilent(with: silentTokenParameters) { msalResult, error in
            if let error = error as NSError? {
                return result(error.asFlutterError())
            }

            guard let msalResult = msalResult else {
                return result(FlutterError(code: "empty_result", message: "Expected a non-empty result.", details: nil))
            }

            let response: [String: Any?] = [
                "accessToken": msalResult.accessToken,
                "expiresOn": msalResult.expiresOn == nil ? nil : ISO8601DateFormatter().string(from: msalResult.expiresOn!),
                "scopes": msalResult.scopes,
                "idToken": msalResult.idToken,
                "tenantId": msalResult.tenantProfile.tenantId,
                "account": [
                    "homeAccountId": msalResult.account.homeAccountId?.dictionaryWithValues(
                        forKeys: ["identifier", "objectId", "tenantId"]
                    )
                ],
                "correlationId": msalResult.correlationId.uuidString,
                "authorizationHeader": msalResult.authorizationHeader,
                "authenticationScheme": msalResult.authenticationScheme
            ]

            result(response)
        }
    }

    private func signOut(_ result: @escaping FlutterResult) {
        guard let application = application else {
            return result(FlutterError(code: "not_initialized", message: "MSAL needs to be initialized before acquiring tokens.", details: nil))
        }

        do {
            let signoutParameters = MSALSignoutParameters()

            let accounts = try application.allAccounts()

            if !accounts.isEmpty {
                application.signout(with: accounts.first!, signoutParameters: signoutParameters) { success, error in
                    if let error = error as NSError? {
                        return result(error.asFlutterError())
                    }
                    result(success)
                }
            } else {
                result(false)
            }
        } catch let error as NSError {
            result(error.asFlutterError())
        }
    }
}

extension NSError {
    func asFlutterError() -> FlutterError {
        FlutterError(code: "Error \(code)", message: domain, details: localizedDescription)
    }
}
