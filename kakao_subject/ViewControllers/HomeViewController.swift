//
//  HomeViewController.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/05.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var weatherStateLabel: UILabel!; 
    @IBOutlet weak var tourListTV: UITableView!
    @IBOutlet weak var addressLB: UILabel!
    
    
    private let CELL_NAME : String = "DetailCell"
    private var currentLocation = CLocation.locationInstance.getCurrentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        showCurrentAddress()
        showWeatherInfo()
        showCurrentTourList()

        
    }
    
    
    

    private func showWeatherInfo(){
    
        let group : DispatchGroup = DispatchGroup()
        
        Weather.weatherInstance.receiveWeatherDataFromServer(group: group, language: "ko", latitude: self.currentLocation.latitude , longitude: self.currentLocation.longitude)
        
        group.notify(queue: .main, execute: { [unowned self] in
            let weatherINF = Weather.weatherInstance.getWeatherData()
            
            //more datas
            //print(weatherINF.weatherForecast)
            self.weatherStateLabel.text = weatherINF.weatherForecast
            self.weatherStateLabel.sizeToFit()


        })
        
    }//showWeatherInfo
    
    private func showCurrentTourList(){
      /*
        let cellNib : UINib = UINib(nibName: "DetailCell", bundle: nil)
        tourListTV.register(cellNib, forCellReuseIdentifier: "DetailCell")
        */
        
        let group: DispatchGroup = DispatchGroup()
        let location : CLocation.CurrentLocation = CLocation.locationInstance.getCurrentLocation()
        
        Tour.tourInstance.getTourInformationFromServer(group: group, latitude: location.latitude, longitude: location.longitude)
        
        group.notify(queue: .main, execute: { [unowned self] in
            self.tourListTV.delegate = self
            self.tourListTV.dataSource = self
            //이걸 부르니까 테이블 뷰가 다시 그려지는건가, 데이터를 다시 가져오는건가?
            self.tourListTV.reloadData()
           // print("tour delegate set")
        })
 
        
        /* dynamic rowHeight
        tourListTV.estimatedRowHeight = 70
        tourListTV.rowHeight =  UITableView.automaticDimension
        */

    }
    
    private func showCurrentAddress(){
        let group : DispatchGroup = DispatchGroup()
        CLocation.locationInstance.getCurrentAddress(group: group)
        
        group.notify(queue : .main , execute : { [unowned self] in
            self.addressLB.text = CLocation.locationInstance.getCurrentAddress()
            self.addressLB.sizeToFit()
        })

    }
    

}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count : Int = Tour.tourInstance.getTourInformation().count
        
        // for testing
        //count = 2

        print("count: \(count)")
         
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        let cell : DetailCell = self.tourListTV.dequeueReusableCell(withIdentifier: CELL_NAME, for: indexPath) as! DetailCell
        //do something
        cell.settingTourInformation(name: "test", summary: "testing", keyword: "testing", image: "not yet")
        */
        let cell : prototypeDetailCell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! prototypeDetailCell
        let inf = Tour.tourInstance.getTourInformation()[indexPath.row]
        
        /* Fatal error: Index out of range */
        //cell.settingTourInformation(name: inf.name, summary: inf.address, keyword: inf.tel, image: inf.imageURL[0] )
        
        /* there is no inf.imageURL[0]? somecase */
        if let image : String = inf.imageURL.first{
            cell.settingTourInformation(name: inf.name, summary: inf.address, keyword: inf.tel, image: image)
        }else{
            print("no instance")
        }
        
        
        return cell
    }
    
    //why only this worked?
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //inspector and this what's first
        return 120 //or whatever you need
    }
}
//
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //why use guard?
        //instantiateInitialViewController? what is it?
        guard let nextController = UIStoryboard(name : "Detail", bundle:nil).instantiateInitialViewController() else{
            fatalError("could not load UIStoryBoard")
        }
  
        self.present(nextController, animated: true){
            //근데 이 부분이 뷰디드로드 되기 전에 수행되는거 아닌가?
            //여기서 api로 받은 관광 이름을 웹 클래스로 넘긴다.
            //여기서는 존재하는 값이니까 optional을 고려안해도 되는거 같다.
            //이 부분이 신기하다, 뷰로드 되기 전부터 뷰컨은 미리 존재한다는 점...,왜 델리게이트를 굳이 디테일뷰컨으로 정했을까?
            print("webSearch is called \(webSearch.webSearchInstance.delegate)")
            webSearch.webSearchInstance.delegate?.transmitData(parameter: Tour.tourInstance.getTourInformation()[indexPath.row].name)
        }
    }
}

