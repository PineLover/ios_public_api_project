//
//  TourWebSearch.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/11.
//  Copyright © 2020 김동환. All rights reserved.
//

import Foundation

public protocol Transmit : class{
    func transmitData(parameter : String)
}

class webSearch : NSObject{
    
    //MARK: - properties
    public var delegate : Transmit?
    public static let webSearchInstance = webSearch()
    private let header = ["Authorization" : "KakaoAK \(KAKAO_API_KEY)"]
    
    private enum webKey : String {
        case title = "title"
        case url = "url"
        case imgUrl = "image_url"
        case display = "display"
    }
    
    public struct webInfoText {
        var title : String = ""
        var url : String = ""
    }
    public struct webInfoImg{
        var image : String = ""
        var display : String = ""
    }
    
    //왜 getWebTextInformation()이 private는 반환하지 못하지,그게 아니라, 타입이 private였네, webInfoText가.
    private var webTextInfoList : [webInfoText] = []
    private var webImageInfoList : [webInfoImg] = []
    
    
    //MARK: - method
    public func getWebTextInformation() -> [webInfoText] {return
        self.webTextInfoList }
    public func getWebImageInformation() -> [webInfoImg] {return
        self.webImageInfoList }
    
    private func extractWebTourInformation(item : [String: Any] , type : Bool) -> Any{
        
        var webTextInfo : webInfoText = webInfoText()
        var webImgInfo : webInfoImg = webInfoImg()
        
        let keys = item.keys
        for inf in item where keys.contains(inf.key){
            guard let keyCase : webKey = webKey(rawValue : inf.key) else{
                continue
            }
            
            switch keyCase{
            case .title : webTextInfo.title = inf.value as! String
            case .url : webTextInfo.url = inf.value as! String
            case .display : webImgInfo.display = inf.value as! String
            case .imgUrl : webImgInfo.display = inf.value as! String
            }
        }
        
        return type ? webTextInfo : webImgInfo
    }
    
    
    
    public func doWebSearch(group : DispatchGroup , query : String){
        
        
        //let query_encoded  = query.data(using: .utf8)
        let query_encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "https://dapi.kakao.com/v2/search/web?query=\(query_encoded!)"
        
 
        group.enter()
        
        //초기화
        self.webTextInfoList.removeAll()
        self.webTextInfoList.removeAll()
        
        //qos: 옵션은 무슨 의미지?
        DispatchQueue.global(qos: .userInitiated).async(group: group, execute: {
            
            if let url = URL(string : url){
                // data,res,err in 이 어떻게 사용되는거지? 이 세가지는 어디서 오는 거지?
                var request = URLRequest(url: url)
                
                request.addValue("KakaoAK \(KAKAO_API_KEY)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                
                URLSession.shared.dataTask(with : request ){  data, res, err in
                    print("in websearch res : \(res)")
                    if let data = data{
                        var jsonDic = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                        
                        guard let documents = jsonDic?["documents"] as? [[String:Any]] else {return}
                        
                        for item in documents {
                            guard let inf : webInfoText = self.extractWebTourInformation(item: item, type: true) as? webInfoText else {
                                continue
                            }
                            self.webTextInfoList.append(inf)
                        }
                        /*
                        for item in self.webTextInfoList {
                            print(item)
                        }
                        */
                        //언제 호출해야 하지?
                        group.leave()
                    }
                }.resume()
            }
            

        })
        
        
    }
    
}
