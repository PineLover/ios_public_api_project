//
//  location_class.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/07.
//  Copyright © 2020 김동환. All rights reserved.
//

import CoreLocation

//what's this for?
public protocol AlarmGetLocation{
    func alarmGetLocation()
}

//NSObject가 뭐지? 이걸 해야 밑에 CLocationManagerDelegate가 될 수 있네
class CLocation : NSObject{
    
    public typealias CurrentLocation = (latitude : Double, longitude : Double)
    
    public var delegate : AlarmGetLocation?
    private var currentLocation: CurrentLocation = (0,0)
    private var currentAddress : String = ""
    public static let locationInstance : CLocation = CLocation()
    public let locationManager : CLLocationManager = CLLocationManager()
    
    //이건 뭐지? NSObject 때문에 가능한거 같은데?
    private override init() {}
    
    public func settingLocationManager() {
        //self는 함수를 호출하는 자기 자신인가?? CLocation 클래스가 아니겠지?
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        //alarmGetLocation의 델리게이트에서가 아니라 아니라 여기서 출력해야 제대로 출력하네?
        print("in settingLocationManager: \(locationManager.location?.coordinate.longitude) , \(locationManager.location?.coordinate.latitude)")
        
        //여기서 갱신해줘야되네 , 가끔 실제앱에서 여기서 에러가 발생한다. 아마 위치 정보 가져오는데 시간이 좀 걸려서 딜레이 화면을 넣은듯??
        self.currentLocation = (locationManager.location?.coordinate.latitude , locationManager.location?.coordinate.longitude) as! CLocation.CurrentLocation
        

    }
    
    
    public func getCurrentLocation() -> CurrentLocation { return self.currentLocation }
    
    public func getCurrentAddress() -> String { return self.currentAddress }
    
    public func getCurrentAddress(group : DispatchGroup){
        let geoCoder : CLGeocoder = CLGeocoder()
        print("got address")
        let location : CLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        //이걸 넣어야 한국어 주소가 나옴.
        let locale = Locale(identifier: "Ko-kr")
        
        
        group.enter()
        //why unowned self declared in []??
        DispatchQueue.global(qos: .userInitiated).async(group: group, execute: {            
            
            geoCoder.reverseGeocodeLocation(location, preferredLocale: locale , completionHandler: { (placemark,error) -> Void in
                guard error == nil, let place = placemark?.first else{
                    group.leave()
                    fatalError("error, conver GEO location")
                }
                
                print("got current adress")
                
                
                if let administrativeArea : String = place.administrativeArea { self.currentAddress.append(administrativeArea + " " )}
                if let locality : String = place.locality { self.currentAddress.append(locality + " ")}
                if let subLocality : String = place.subLocality { self.currentAddress.append(subLocality + " ")}
                if let subThoroughfare : String = place.subThoroughfare { self.currentAddress.append(subThoroughfare + " ")}
                
                
                
                group.leave()
            })   
        })
        
    }

}

//뭘 확장해야되지?
extension CLocation : CLLocationManagerDelegate{
    
    //이 함수는 위치가 변경되면 호출되는듯 하다.
    func locationManager( _ manager : CLLocationManager , didUpdateLocations locations : [CLLocation] ){
        //locations.last 맨마지막 원소인듯
        guard let location : CLLocation = locations.last else{
            fatalError("didnt get location from GPS")
        }
        
        //정확도에 대한거 같은데, horizontalAccuracy가 뭐지?
        if location.horizontalAccuracy < 100{
            print("in locationManager")
            
            //이 부분이 델리게이트에 대한 멋진 활용 예시같다.
            //내가 만든 클래스인 CLocation의 델리게이트가 구현한 alarmGetLocation()을 호출한다. connectVC에서 호출된다.
            self.delegate?.alarmGetLocation()
            
            if let x = self.delegate{
                print("not nil")
            }else{
                print("nil")
            }
            print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
            self.currentLocation = (location.coordinate.latitude , location.coordinate.longitude)
            //위치 업데이트를 종료시키는 듯 하다. 언제 시작한거지?
            self.locationManager.stopUpdatingLocation()
        }
    }
    
}
