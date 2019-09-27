//
//  PostResult.swift


import UIKit
import Alamofire

typealias SuccessBlock = (_ response: AnyObject) -> Void
typealias FailureBlock = (_ response: AnyObject) -> Void
typealias ProgressBlock = (_ response: AnyObject) -> Void
@objc
 class PostResult: NSObject {

    @objc func postMethodWithParamsAndImage(parameters: [String:String], forMethod: String, image: [UIImage],faceImg:UIImage?, success:@escaping SuccessBlock, fail:@escaping FailureBlock){
        let manager = Alamofire.SessionManager.default
        let headers: HTTPHeaders?
        headers =  ["Content-Type": "application/json"]
        manager.upload(
            multipartFormData: { multipartFormData in
                print(parameters)
                print(image as Any)
                if !image.isEmpty {
                    for i in 0..<image.count {
                        let img = image[i]
                        let imgData = img.jpegData(compressionQuality: 0.5)!
                        if i == 0{
                            multipartFormData.append(imgData, withName: "imageFront", fileName: "frontImage.jpg", mimeType: "image/jpg")
                        }else{
                        multipartFormData.append(imgData, withName: "imageBack", fileName: "backImage.jpg", mimeType: "image/jpg")
                        }
                    }
                    if faceImg != nil{
                        if let faceData = faceImg?.jpegData(compressionQuality: 0.5)!{
                            multipartFormData.append(faceData, withName: "imageFace", fileName: "faceImage.jpg", mimeType: "image/jpg")
                        }
                    }
                }
                if !(parameters.isEmpty) {
                    for (key, value) in parameters {
                        print("key: \(key) -> val: \(value)")
                        if let dic = value as? Dictionary<String,AnyObject>{
                            print(key)
                            print(value)
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
                                let str = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                                multipartFormData.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                            } catch {
                                print(error.localizedDescription)
                            }

                        }else{
                            multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                        }

                    }
                }
                print(multipartFormData)
        },
            to: forMethod,  method: .post, headers: headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print(progress)
                    })
                    upload.responseJSON { response in

                        success(response.result.value as AnyObject)
                    }
                case .failure(let encodingError):

                    fail(encodingError as AnyObject)
                }
        })
    }
    
}

