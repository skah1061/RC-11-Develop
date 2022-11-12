//
//  RaceViewController.swift
//  RC4 Game
//
//  Created by 강정훈 on 2022/11/10.
//

import Foundation
import UIKit
import AVFoundation

class RaceViewController: UIViewController{
    
    var isRacing: Bool = false
    var audio: AVAudioPlayer!
    @IBOutlet weak var GoToLobbyButton: UIButton!
    @IBOutlet weak var track: UIView!
    //MARK: -AnimalImagesOutlet
    
    @IBOutlet weak var ratSleep: UILabel!
    @IBOutlet weak var sheepSleep: UILabel!
    @IBOutlet weak var birdSleep: UILabel!
    @IBOutlet weak var dogSleep: UILabel!
    lazy var sleepLabelArray: [UILabel] = [dogSleep, birdSleep, sheepSleep, ratSleep]
    
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var birdImage: UIImageView!
    @IBOutlet weak var sheepImage: UIImageView!
    @IBOutlet weak var ratImage: UIImageView!
    lazy var animalImages: [UIImageView] = [dogImage, birdImage, sheepImage, ratImage]
    //MARK: -LabelOutlet
    
    @IBOutlet weak var choiceAnimal: UILabel!
    @IBOutlet weak var betMoney: UILabel!
    @IBOutlet weak var money: UILabel!
    //MARK: -가져온정보
    var betedMoney: Int = 0
    var animalIndex: Int = 0
    var myMoney = 0
    weak var delegate: sendDelegate?
    //MARK: -동물 능력치
    var dogState = AnimalState(speed: 400000,name: "개",potential: 20,sleep: 2, image1: #imageLiteral(resourceName: "개1"), image2: #imageLiteral(resourceName: "개2"))
    var birdState = AnimalState(speed: 200000,name: "새",potential: 10,sleep: 4,  image1: #imageLiteral(resourceName: "새1"), image2: #imageLiteral(resourceName: "새2"))
    var sheepState = AnimalState(speed: 500000,name: "양",potential: 40,sleep: 4,  image1: #imageLiteral(resourceName: "양2"), image2: #imageLiteral(resourceName: "양1"))
    var ratState = AnimalState(speed: 300000,name: "쥐",potential: 15,sleep: 3,  image1: #imageLiteral(resourceName: "쥐1"), image2: #imageLiteral(resourceName: "쥐2"))
    lazy var animals: [AnimalState] = [dogState, birdState, sheepState, ratState]
    // MARK: -등수
    var ranking: [AnimalState] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //받아온 정보 초기화
        choiceAnimal.text = animals[animalIndex].name
        betMoney.text = String(betedMoney)
        money.text = String(myMoney)
        
    }
    
    @IBAction func OnGotoLobby(_ sender: Any) {
        delegate?.sendMyMoney(money: myMoney)
        self.dismiss(animated: false)
        audio.stop()
    }
    //메인로직 경기 시작
    @IBAction func OnStartButton(_ sender: Any) {
        if isRacing == true{return}
        let url = Bundle.main.url(forResource: "RaceBGM", withExtension: "wav")
        if let url = url{
            do{
                audio = try AVAudioPlayer(contentsOf: url)
                guard let sound = audio else{ return}
                sound.prepareToPlay()
                sound.play()
            }catch _ {
                print("error")
            }
        }
        
       
        
        audio.play()
        
        for i in 0...animals.count-1{
            StartRun(index: i)
        }
    }
   
    
    func StartRun(index: Int){
        isRacing = true
        let trackDistance: CGFloat = track.bounds.height
        var isDone: Bool = true
        DispatchQueue.global(qos: .userInitiated).async {
            
            var isImage: Bool = true
            var distance: CGFloat = 0
            var isPotential: Bool = false
            var potentialCount: Int = 0
            let defaultSpeed: Int = self.animals[index].speed
            var isSleep: Bool = false
            var sleepCount: Int = 0
            var randomPotentialTime: Int = 0
            while(isDone)//도착시로 바꾸기
            {
                DispatchQueue.main.async {  //달리기
                    if self.animals[index].sleep >= Int.random(in: 1...200) && !isPotential
                    {//잠듬
                        isSleep = true
                        print("\(self.animals[index].name) 잠듬.ZZz")
                    }
                    if !isSleep{
                        if isImage{
                            self.animalImages[index].image = self.animals[index].image1
                            isImage = !isImage
                        }
                        else{
                            self.animalImages[index].image = self.animals[index].image2
                            isImage = !isImage
                        }
                        if Int.random(in: 1...200) < self.animals[index].potential && potentialCount == 0
                        {
                            self.animals[index].speed = 50000
                            isPotential = true
                            randomPotentialTime = Int.random(in: 8...20)
                        }
                        if isPotential == true{
                            potentialCount = potentialCount+1
                            if potentialCount == randomPotentialTime{
                                isPotential = false
                                self.animals[index].speed = defaultSpeed
                                potentialCount = 0
                            }
                            
                        }
                        distance = distance-3
                        self.animalImages[index].transform = CGAffineTransform(translationX: 0, y: distance)
                        
                    }
                    else{
                        //ZZz라벨 출력 및 위치 이동
                       self.sleepLabelArray[index].transform = CGAffineTransform(translationX: 0, y: distance)
                            self.sleepLabelArray[index].isHidden = false
                        
                        sleepCount = sleepCount+1
                        print("\(self.animals[index].name)SleepCount : \(sleepCount)")
                        if sleepCount == 10
                        {
                            self.sleepLabelArray[index].isHidden = true
                            //ZZz라벨 숨기기
                            sleepCount = 0
                            isSleep = false
                        }
                    }
                } // DispatchQueue.Main
                
                usleep(useconds_t(self.animals[index].speed))
                if trackDistance-(trackDistance/9) <= distance * (-1){  //도착
                    isDone = false
                    self.ranking.append(self.animals[index])
                    DispatchQueue.main.async {
                        if self.ranking.count == 1{
                            if self.ranking[0].name == self.animals[self.animalIndex].name{
                                self.myMoney = self.myMoney + self.betedMoney*2
                                
                                self.money.text = String(self.myMoney)
                                
                                let alert = UIAlertController(title: "맞췄 습니다!", message: "소지금+\(self.betedMoney*2)", preferredStyle: UIAlertController.Style.alert)
                                let alertOKBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
                                alert.addAction(alertOKBtn)
                                self.present(alert, animated: false)
                            }
                            else {
                                print("틀렸다!")
                                let alert = UIAlertController(title: "틀렸 습니다!", message: "소지금 = \(self.myMoney)", preferredStyle: UIAlertController.Style.alert)
                                let alertOKBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
                                alert.addAction(alertOKBtn)
                                self.present(alert, animated: false)
                                
                            }
                        }
                        self.GoToLobbyButton.isHidden = false
                    }   //도착부문 내부 mainTread
                    
                    break
                }   // 도착시 if
            }   // while 중괄호
        }   //DispatchQueue.global
    }
}
