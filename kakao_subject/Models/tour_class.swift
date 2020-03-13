//
//  tour_class.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/06.
//  Copyright © 2020 김동환. All rights reserved.
//

import Foundation

public class Tour {

    
    //why this exists?
    private enum TourCase : String{
        //exist
        case Title = "title"
        //not seen
        case Tel = "tel"
        //exist
        case Dist = "dist"
        //exist
        case Addr = "addr1"
        //exist
        case Image = "firstimage"
        //exist
        case MapY = "mapy"
        case MapX = "mapx"
    }
    
    //Codable?
    public struct TourINF{
        var name : String = ""
        var address : String = ""
        var tel : String = ""
        var imageURL : [String] = [] //why array?
        
        //where did i defined it? here?
        var location : (lat : String , long : String) = ("0.0","0.0")
        var distance : Int = 0
    }
    
    //MARK: - Method
    public static let tourInstance : Tour = Tour()
    //datas will be driven to the cells
    private var tourInfoList : [TourINF] = []
    //MARK: - data parser
    private func extractTourInfo(parser : [String : Any]) -> TourINF{
        let containKeys = parser.keys
        
        var information : TourINF = TourINF()
        
        //where있어야 되는건가?
        for key in containKeys where containKeys.contains(key){
            //guard let else?, guard 있어야 되는건가??
            guard let tourKey : TourCase = TourCase(rawValue: key) else{
                continue
            }
            
            switch tourKey{
            case .Title : information.name = parser[key] as! String
            case .Tel : information.tel = parser[key] as! String
            case .Dist: information.distance = parser[key] as! Int
            case .Addr : information.address = parser[key] as! String
            case .MapX : information.location.long = String(describing : parser[key]!)
            case .MapY : information.location.lat = String(describing: parser[key]!)
            case .Image : information.imageURL.append(parser[key] as! String)
            }
            
        }
        return information
    }
    //MARK: - getting Info
    
    public func getTourInformation() -> [TourINF] {return self.tourInfoList}
    
    public func getTourInformationFromServer(group : DispatchGroup , latitude : Double, longitude : Double){
        group.enter()
        let tourURL = "http://api.visitkorea.or.kr/openapi/service/rest/KorService/locationBasedList?serviceKey=\(API_KEY)&numOfRows=20&pageNo=1&MobileOS=ETC&MobileApp=KakaoSubject&arrange=O&contentTypeId=12&mapX=\(longitude)&mapY=\(latitude)&radius=10000&listYN=Y&_type=json"
        //what does the paramater means?
        DispatchQueue.global(qos: .userInteractive).async(group: group){
            //getting data from server
            if let url = URL(string : tourURL){
                URLSession.shared.dataTask(with: url){ [unowned self] data, res, err in
                    if let data = data{
                        let jsonDic = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        if let dic = jsonDic{
                            print("\(latitude) \(longitude)")
                            //print(dic)
                            guard let response = dic["response"] as? [String : Any] else {return}
                            guard let body = response["body"] as? [String : Any] else {return}
                            guard let items = body["items"] as? [String:Any] else {return}
                            //as! 로 했는데 아이템이 마침 비어있었다. 로케이션을 못가져와서 그런거같다.
                            //대신에 guard로 해결했다. 안그랬으면 body?["items"]로 해야되.
                            guard let item = items["item"] as? [[String:Any]] else {return}
                            
                            for elem in item{
                                self.tourInfoList.append(self.extractTourInfo(parser: elem))
                            }
                            
                            print("tourInfoList updated")
                            group.leave()
                        }
                    }
                //resume이 뭐지?
                }.resume()
            }//if
            else{
                print("url is nil")
            }
            
        }
        
    }
}
