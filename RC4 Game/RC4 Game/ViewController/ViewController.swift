//
//  ViewController.swift
//  RC4 Game
//
//  Created by 강정훈 on 2022/11/08.
//

import UIKit
import AVFoundation

protocol sendDelegate: AnyObject{
    func sendMyMoney(money: Int)
}

class ViewController: UIViewController, UITextFieldDelegate, sendDelegate {
    var clickSound: AVAudioPlayer?
    @IBOutlet weak var textField: UITextField! {didSet{
        textField.delegate = self
    }}
    
    //MARK: -이미지
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var birdImage: UIImageView!
    @IBOutlet weak var sheepImage: UIImageView!
    @IBOutlet weak var ratImage: UIImageView!
    //MARK: -버튼
    @IBOutlet weak var dogButton: ButtonState!
    @IBOutlet weak var birdButton: ButtonState!
    @IBOutlet weak var sheepButton: ButtonState!
    @IBOutlet weak var ratButton: ButtonState!
    
    @IBOutlet weak var myMoney: UILabel!
    @IBOutlet weak var bettingButton: UIButton!
    
    //MARK: -버튼 이미지 배열
    let defaultImage: [UIImage] = [ #imageLiteral(resourceName: "개"), #imageLiteral(resourceName: "새"), #imageLiteral(resourceName: "양"), #imageLiteral(resourceName: "쥐")]
    lazy var images: [UIImageView] = [dogImage, birdImage, sheepImage, ratImage]
    lazy var buttons: [ButtonState] = [dogButton,birdButton, sheepButton, ratButton]
    
    @IBAction func OnBettingButton(_ sender: Any) {
        
        let bettingMoney = Int(textField.text ?? "0") ?? 0
        var mymoney = Int(myMoney.text ?? "0") ?? 0
        if  bettingMoney > mymoney
        {
            print("금액이 모자랍니다.")
        }
        
        else{
            
            for i in 0...buttons.count-1{
                if buttons[i].isSelect
                {
                    mymoney = mymoney - bettingMoney
                    let raceView = storyboard?.instantiateViewController(withIdentifier: "RaceView") as! RaceViewController
                    raceView.modalPresentationStyle = .fullScreen
                    raceView.betedMoney = bettingMoney
                    raceView.animalIndex = i
                    raceView.myMoney = mymoney
                    raceView.delegate = self
                    
                    self.present(raceView, animated: true)
                    //소지금 빼기(베팅금 지불)
                    // 전달할 정보 : 몇번째 동물인지 idex, 베팅금, 가진 소지금
                    //화면 전환 및 정보 다음 뷰로 전달
                    
                    
                }
            }
        }
        
        
        
        
        
        
    }
    // MARK: -OnClick
    @IBAction func OnDogButton(_ sender: Any) {
        let animalNumber: Int = 0
        setButtonImage(animalNumber)
        setDefaultImage()
        let moveImage1 = #imageLiteral(resourceName: "개Idle1")
        let moveImage2 = #imageLiteral(resourceName: "개Idle2")
        moveImage(image1: moveImage1 , image2: moveImage2, animalNum: animalNumber)

    }
    
    @IBAction func OnBirdButton(_ sender: Any) {
        let animalNumber: Int = 1
        setButtonImage(animalNumber)
        setDefaultImage()
        let moveImage1 = #imageLiteral(resourceName: "새Idle1")
        let moveImage2 = #imageLiteral(resourceName: "새Idle2")
        moveImage(image1: moveImage1 , image2: moveImage2, animalNum: animalNumber)

    }
    
    @IBAction func OnSheepButton(_ sender: Any) {
        let animalNumber: Int = 2
        setButtonImage(animalNumber)
        setDefaultImage()
        let moveImage1 = #imageLiteral(resourceName: "양")
        let moveImage2 = #imageLiteral(resourceName: "양Idle2")
        moveImage(image1: moveImage1 , image2: moveImage2, animalNum: animalNumber)
    }
    
    @IBAction func OnRatButton(_ sender: Any) {
        let animalNumber: Int = 3
        setButtonImage(animalNumber)
        setDefaultImage()
        let moveImage1 = #imageLiteral(resourceName: "쥐Idle1")
        let moveImage2 = #imageLiteral(resourceName: "쥐Idle2")
        moveImage(image1: moveImage1 , image2: moveImage2, animalNum: animalNumber)
    }
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func setButtonImage(_ index: Int){
        //사운드 초기화
        let url = Bundle.main.url(forResource: "ClickSound", withExtension: "wav")
        if let url = url{
            do{
                clickSound = try  AVAudioPlayer(contentsOf: url)
                guard let sound = clickSound else{return}
                sound.prepareToPlay()
                sound.play()
            }
            catch{
                print("Empty Click Sound")
            }
        }
        for i in 0...3{
            buttons[i].isSelect = false
        }
        buttons[index].isSelect = true
        for i in 0...3{
            buttons[i].setState()
        }
    }
    func setDefaultImage(){
        bettingButton.backgroundColor = .systemGreen
        for i in 0...images.count-1{
            images[i].image = defaultImage[i]
        }
    }
    //MARK: -이미지 움직임
    func moveImage(image1:UIImage, image2:UIImage, animalNum: Int)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            let idleImage: [UIImage] = [image1,image2]
            var isIdle: Bool = true
            
            while(self.buttons[animalNum].isSelect)
            {
                if isIdle
                {
                    DispatchQueue.main.async {
                        self.images[animalNum].image = idleImage[0]
                    }
                    
                }
                else{
                    DispatchQueue.main.async{
                        self.images[animalNum].image = idleImage[1]
                    }
                    
                }
                isIdle = !isIdle
                usleep(500000)
            }
            
        }
    }
    func sendMyMoney(money: Int){
        self.myMoney.text = String(money)
    }
}
