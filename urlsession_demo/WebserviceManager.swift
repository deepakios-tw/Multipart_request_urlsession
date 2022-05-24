//
//  WebserviceManager.swift
//  urlsession_demo
//
//  Created by Apple on 20/05/22.
//

import Foundation

//HttpMethodTypes
public enum MethodType :String {
    case POST
    case GET
    case PUT
    case DELETE
}

 struct RESPONSE_CODE {
    static let success = 200
    static let sessionExpire = 401
    static let serverError = 500
}

protocol WebserviceDelegate {
    func didGetUploadPercent(_ percent:Float)
}

class WebserviceManager: NSObject,URLSessionDelegate,URLSessionTaskDelegate {

    static var shared = WebserviceManager()
    private var uploadDelegate: WebserviceDelegate?
    private override init(){ }
    private let boundary = "Boundary-\(NSUUID().uuidString)"
   // let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1Ni"

    //Upload Image Method
    func multipartRequest(url:String, imageName:String,imageData:[Data],keyForImage:String,parameters:[String:Any]?,delegate: WebserviceDelegate?,onSuccess:@escaping(_ httpStatus:Int,_ response:Data?)->(), onFailure:@escaping(_ httpStatus:Int,_ response:NSDictionary?)->()){
            self.uploadDelegate = delegate

            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            var urlRequest = URLRequest(url: URL(string: url)!)
            urlRequest.httpMethod = MethodType.POST.rawValue
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //  urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("sZWU9oTE7GGnty9UPddE", forHTTPHeaderField: "authentication-token")

         let data = self.createDataBody(withParameters: parameters, media: imageData, boundary: self.boundary, keyForImage: keyForImage, imageName: imageName)
           session.uploadTask(with: urlRequest, from: data) { (tmpdata, response, error) in

            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("Status Code is \(httpStatusCode)")
            }
            if error != nil {
                let tmpResponse = ["message":error?.localizedDescription]
                onFailure(httpStatusCode,tmpResponse as NSDictionary)
            }else {
                if httpStatusCode == RESPONSE_CODE.sessionExpire {
                    // Refresh Token
                }else if httpStatusCode == RESPONSE_CODE.success {
                    onSuccess(httpStatusCode,data)
                } else  {
                    do {
                        //convert response into json
                        let json =   try JSONSerialization.jsonObject(with: tmpdata!, options: []) as! NSDictionary
                        onFailure(httpStatusCode,json)

                    }catch {
                        let tmpResponse = ["message":"Unable to get json."] as NSDictionary
                        onFailure(httpStatusCode,tmpResponse)
                    }
                }
            }

        }.resume()
    }

    private func createDataBody(withParameters params: [String:Any]?, media: [Data]?, boundary: String, keyForImage:String, imageName:String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()

        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\("\(value)" + lineBreak)")
            }
        }
       body.append("--\(boundary + lineBreak)")
       body.append("Content-Disposition: form-data; name=\"\(keyForImage)\"; filename=\"\(imageName)\"\(lineBreak)")
       body.append("Content-Type: image/jpeg\r\n\r\n")
//     body.append(media!)
       body.append(media![0])
       body.append(lineBreak)
       body.append("--\(boundary)--\(lineBreak)")
        return body
    }

    //MARK:- URLSession Delegates
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        let percent = uploadProgress * 100.0
        self.uploadDelegate?.didGetUploadPercent(percent)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
