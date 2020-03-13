//
//  weather_struct.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/04.
//  Copyright © 2020 김동환. All rights reserved.
//

import Foundation

//그냥 부모를 만들고 overload할까?
public class Weather{
    
    public struct selectedWeatherData {
        var weatherForecast : String = ""
    }

    
    //instance를 이렇게 자신안에 선언해서 사용하다니
    public static let weatherInstance: Weather = Weather()
    private var weatherData : selectedWeatherData = selectedWeatherData()
    //private var weatherData : WeatherINF = WeatherINF(json : ["rnSt":0,"wf":""])
    
    //self?
    public func getWeatherData() -> selectedWeatherData { return weatherData }
    public func receiveWeatherDataFromServer(group : DispatchGroup, language : String , latitude : Double , longitude : Double){
        
        let weatherURL : String = "http://apis.data.go.kr/1360000/VilageFcstMsgService/getLandFcst?serviceKey=\(API_KEY)&numOfRows=1&pageNo=1&regId=11A00101&dataType=json"
        
        //enter?
        group.enter()
        //dispatchQueue?
        DispatchQueue.global(qos: .userInteractive).async(group : group, execute: {
            // [unowned self] in
            
            
            //getting data from server
            if let url = URL(string : weatherURL){
                URLSession.shared.dataTask(with: url){ [unowned self] data, res, err in
                    if let data = data{
                        
                        //print(String(decoding:data , as : UTF8.self))
                        
                        do{
                            //decode is not working properly
                            let jsonDerived = try JSONDecoder().decode(WeatherINF.self, from : data)
                            
                            //it doesnt look good
                            //print(jsonDerived.response?.body?.items?.item?[0].wf! ?? "json not derived" )
                            self.weatherData.weatherForecast = jsonDerived.response?.body?.items?.item?[0].wf ?? "empty"
                            group.leave()
                            
                        } catch let jsonErr{
                            print("Error seriallizing json:",jsonErr)
                            group.leave()
                        }
                    }
                }.resume()

            }
            else{
                print("url is nil")
            }
            
        })
        
    }
    
}


extension Weather {

    // MARK: - Welcome
    public struct WeatherINF : Codable {
        let response: Response?
    }

    // MARK: - Response
    public struct Response: Codable {
        let header: Header?
        let body: Body?
    }

    // MARK: - Body
    public struct Body: Codable {
        let dataType: String?
        let items: Items?
        let pageNo, numOfRows, totalCount: Int?
    }

    // MARK: - Items
    public struct Items: Codable {
        let item: [Item]?
    }

    // MARK: - Item
    public struct Item: Codable {
        let announceTime, numEf: Int?
        let regID: String?
        let rnSt, rnYn, ta: Int?
        let wd1, wd2, wdTnd, wf: String?
        let wfCD, wsIt: String?

        enum CodingKeys: String, CodingKey {
            case announceTime, numEf
            case regID = "regId"
            case rnSt, rnYn, ta, wd1, wd2, wdTnd, wf
            case wfCD = "wfCd"
            case wsIt
        }
    }

    // MARK: - Header
    public struct Header: Codable {
        let resultCode, resultMsg: String?
    }

}
