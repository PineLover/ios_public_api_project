//
//  DetailViewController.swift
//  kakao_subject
//
//  Created by 김동환 on 2020/03/11.
//  Copyright © 2020 김동환. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var webSearchTV: UITableView!
    @IBOutlet weak var WebImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //근데 여기서 델리게이트를 설정해주는데, homevc에서 transmit data를 호출 할 수 있는건가?
        //도대체 어떻게 가능한거지??
        webSearch.webSearchInstance.delegate = self
    }
    
    private func showTourInformation(parameter : String){
        let group : DispatchGroup = DispatchGroup()
        webSearch.webSearchInstance.doWebSearch(group: group, query: parameter)
        
        print("at detailvc1 showTourInformation")
        
        group.notify(queue: .main) { [unowned self] in
            /*
            //why there is now web img found?
            guard let imageURL = webSearch.webSearchInstance.getWebTextInformation().first else{
                print("at detailvc1 showTourInformation returned")
                return
            }
            
            if let url = URL(string: imageURL.image){
                self.WebImage.load(url : url)
            }
             */
            
            webSearch.webSearchInstance.getWebTextInformation()
            
            //이 함수가 transmitdata 함수 들어가서 홈뷰컨에서 호출된다.
            //그래서 세팅이 뷰디드 로드 된이후에 되는게 아닌거 같은데??
            //여기서 뷰가 생긴건지 생기기전에 값을 대입하려는건지 조사해봐야 겠다.
            
            //이게 호출이 안되는데??
            print("at detailvc2 showTourInformation2")
            self.placeTitle.text = parameter
            
            self.webSearchTV.delegate = self
            self.webSearchTV.dataSource = self
            //why need this? 이게 뭐지?
            self.webSearchTV.reloadData()
        }
        
        
        
    }
    

}


// MARK: - Transmit Delegate Extension
extension DetailViewController : Transmit {
    //why implement this??
    func transmitData(parameter: String) {
        print("transmitData is called \(parameter)")
        showTourInformation(parameter: parameter)
    }
}

//MARK: -  UITableViewDataSource Extension
extension DetailViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count : Int = webSearch.webSearchInstance.getWebTextInformation().count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let inf = webSearch.webSearchInstance.getWebTextInformation()
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebSubCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "WebSubCell")

        //set views
        cell.textLabel?.attributedText = NSAttributedString(string : inf[indexPath.row].title )
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate Extension
extension DetailViewController: UITableViewDelegate{
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath : IndexPath){
        let inf = webSearch.webSearchInstance.getWebTextInformation()
        guard let link : URL = URL(string: inf[indexPath.row].url ) else{
            return
        }
        //이게 뭐지?? 사파리 창을 띄워준다고???
        UIApplication.shared.open(link,options: [:], completionHandler:  nil)
    }
    
}
