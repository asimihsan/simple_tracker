import Flutter
import UIKit

public class SwiftLocalStoragePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.asimihsan.local_storage", binaryMessenger: registrar.messenger())
    let instance = SwiftLocalStoragePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getKeyValue":
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "INVALID_PLUGIN_USAGE", message: "could not get args for Flutter plugin call", details: nil))
            return
        }
        guard args.count == 2,
              let appId = args["appId"] as? String,
              let key = args["key"] as? String else {
            result(FlutterError.init(code: "INVALID_PLUGIN_USAGE", message: "could not get sub-args for Flutter plugin call", details: nil))
            return
        }
        
        let maybeMissingValue: String? = getKeyValue(appId: appId, key: key)
        guard let value: String = maybeMissingValue else {
            result(FlutterError.init(code: "KEY_NOT_FOUND", message: "could not find value for specified key", details: nil))
            return
        }
        result(value)
        
    case "storeKeyValue":
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "INVALID_PLUGIN_USAGE", message: "could not get args for Flutter plugin call", details: nil))
            return
        }
        guard args.count == 3,
              let appId = args["appId"] as? String,
              let key = args["key"] as? String,
              let value = args["value"] as? String else {
            result(FlutterError.init(code: "INVALID_PLUGIN_USAGE", message: "could not get sub-args for Flutter plugin call", details: nil))
            return
        }
        
        let status = addKeyValue(appId: appId, key: key, value: value)
        guard status == errSecSuccess else {
            switch status {
            case errSecDuplicateItem:
                result(FlutterError.init(code: "KEY_ALREADY_EXISTS", message:  "could not store key: " + key, details: nil))
            default:
                let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil);
                result(FlutterError.init(code: "PLUGIN_FAILURE", message: "could not store key: " + key + ": " + error.localizedDescription, details: nil))
            }
            return
        }
        result(nil)
    default:
        result(FlutterMethodNotImplemented)
    }
    
  }
    
  func getEncodedTag(appId: String, key: String) -> Data {
    let tag = (appId + "_" + key).data(using: .utf8)!.base64EncodedData()
    return tag.base64EncodedData()
  }
    
  func getEncodedValue(value: String) -> Data {
    return value.data(using: .utf8)!.base64EncodedData()
  }
    
  func addKeyValue(appId: String, key: String, value: String) -> OSStatus {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: getEncodedTag(appId: appId, key: key),
                                kSecValueData as String: getEncodedValue(value: value),
                                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]
    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }
    
  func getKeyValue(appId: String, key: String) -> String? {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: getEncodedTag(appId: appId, key: key),
                                kSecReturnData as String: kCFBooleanTrue!,
                                kSecMatchLimit as String: kSecMatchLimitOne]
    var maybeDataTypeRef: CFTypeRef?
    let getStatus = SecItemCopyMatching(query as CFDictionary, &maybeDataTypeRef)
    guard getStatus != errSecItemNotFound else {
        NSLog("key not found")
        return nil
    }
    guard getStatus == errSecSuccess else {
        NSLog("some other error occurred")
        return nil
    }
    if maybeDataTypeRef == nil {
        NSLog("here 2 key is nil")
        return nil
    }
    guard let data = maybeDataTypeRef as? Data else {
        NSLog("found key but it is nil")
        return nil
    }
    let value = String(data: Data(base64Encoded: data)!, encoding: .utf8)!
    return value
  }
    
  func deleteKeyValue(appId: String, key: String, value: String) -> OSStatus {
     let deletequery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: getEncodedTag(appId: appId, key: key),
                                       kSecValueData as String: getEncodedValue(value: value)]
     return SecItemDelete(deletequery as CFDictionary)
  }
}
