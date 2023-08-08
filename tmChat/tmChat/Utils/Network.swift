//
//  Network.swift
//  Meninki
//
//  Created by NyanDeveloper on 29.01.2023.
//

import Foundation
import Alamofire

class Network {
        
    class func perform<T:Decodable, Parameter: Encodable> (
        url: String,
        method: HTTPMethod = .get,
        params: Parameter,
        encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
        headers: HTTPHeaders = [
            .authorization(bearerToken: AccUserDefaults.token)
        ],
        completionHandler: @escaping (T?)->() ){
            

            AF.request(url,
                      method: method,
                      parameters: params,
                       encoder: encoder,
                      headers: headers)
           .responseDecodable(of: T.self) { resp in
               debugPrint(resp)
                
               guard let value = resp.value else {
                   completionHandler(nil)
                   return
               }
               
               completionHandler(value)
        }
    }
    
    class func upload<T:Decodable>(images: [UploadImage?],
                                   fields: [String: String],
                                   method: HTTPMethod = .post,
                                   path: String,
                                   completionHandler: @escaping (T?)->()  ) {
        
        print(images)
        print(fields)
        
        AF.upload(multipartFormData: { formdata in
            
            images.forEach { img in
                if img != nil {
                    formdata.append(img!.data ?? Data(),
                                    withName: img!.uploadName,
                                    fileName: img!.filename,
                                    mimeType: img!.filename?.mimeType())
                    
                    if img!.type != nil {
                        formdata.append(img!.type!.data(using: String.Encoding.utf8)!,
                                        withName: "type")
                    }

                }
            }
            
            
            fields.forEach { (key, value) in
                formdata.append(value.data(using: String.Encoding.utf8)!,
                                withName: key)

            }

        }, to: path, method: method, headers: [ .authorization(bearerToken: AccUserDefaults.token) ])
        
        .responseDecodable(of: T.self) { resp in
            debugPrint(resp)
            completionHandler(resp.value)
        }
    }
}




//extension URLEncodedFormParameterEncoder {
//    static let custom = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets), destination: .methodDependent)
//}
//
//struct ArrayEncoding: ParameterEncoding {
//    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        var request = try URLEncoding().encode(urlRequest, with: parameters)
//        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
//        return request
//    }
//}
