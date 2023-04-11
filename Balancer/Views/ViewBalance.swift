//
//  ViewBalance.swift
//  Balancer
//
//  Created by Danil Bochkarev on 11.04.2023.
//

import UIKit
import SnapKit

class ViewBalance: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        ethScan()
        bnbScan()
    }
    
    //MARK: -  Setting ETH Scan
    private let backView = UIView()
    private let infoView = UIView()
    private let imageView = UIImageView()
    private let textInput = UITextField()
    private let buttonCheck = UIButton()
    private let balanceInfo = UILabel()
    
    //MARK: -  Setting BNB Scan
    private let backView1 = UIView()
    private let infoView1 = UIView()
    private let imageView1 = UIImageView()
    private let textInput1 = UITextField()
    private let buttonCheck1 = UIButton()
    private let balanceInfo1 = UILabel()
    
    //MARK: -  Support method
    func conv(_ double: Double) -> Double {
        let num = (double / 1000000000) / 1000000000
        return round(num * 1000) / 1000
    }
}

//MARK: - Create ETH Scan
private extension ViewBalance {
    func ethScan() {
        let screen = UIScreen.main.bounds
        
        
        backView.backgroundColor = .blue.withAlphaComponent(0.5)
        backView.layer.cornerRadius = 20
        view.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.snp.makeConstraints { make in
            make.width.equalTo(screen.width - 25)
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        
        infoView.backgroundColor = .blue.withAlphaComponent(0.5)
        infoView.layer.cornerRadius = 20
        infoView.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.width.equalTo(screen.width - 25)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(backView).inset(0)
        }
        
        textInput.textColor = .black
        textInput.backgroundColor = .white
        textInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textInput.leftViewMode = .always
        textInput.layer.cornerRadius = 10
        textInput.autocorrectionType = .no
        textInput.attributedPlaceholder = NSAttributedString(
            string: "ETH Scan...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )
        infoView.addSubview(textInput)
        textInput.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(50)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "eth")
        imageView.contentMode = .scaleAspectFit
        infoView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalTo(textInput).inset(-60)
        }
        
        buttonCheck.translatesAutoresizingMaskIntoConstraints = false
        buttonCheck.backgroundColor = .white
        buttonCheck.layer.cornerRadius = 25
        buttonCheck.setImage(UIImage(systemName: "checkmark"), for: .normal)
        buttonCheck.tintColor = .black
        buttonCheck.addTarget(self, action: #selector(fetchBalance), for: .touchUpInside)
        infoView.addSubview(buttonCheck)
        buttonCheck.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.right.equalTo(textInput).inset(-60)
        }
        
        balanceInfo.translatesAutoresizingMaskIntoConstraints = false
        balanceInfo.font = .systemFont(ofSize: 24, weight: .medium)
        balanceInfo.textColor = .white
        balanceInfo.numberOfLines = 3
        balanceInfo.textAlignment = .center
        balanceInfo.text = ""
        backView.addSubview(balanceInfo)
        balanceInfo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoView).inset(-48)
            make.width.equalTo(backView)
        }
    }
    
    @objc func fetchBalance() {
        guard let address = textInput.text else {
            balanceInfo.text = "Ошибка: не введен адрес"
            return
        }
        
        let apiURL = "https://api.etherscan.io/api?module=account&action=balance&address=\(address)&tag=latest&apikey=D8GRA75IP9FNHTY21EMNYP5QU13SJANK7C"
        
        guard let url = URL(string: apiURL) else {
            balanceInfo.text = "Ошибка URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.balanceInfo.text = "Ошибка: \(error.localizedDescription)"
                return
            }
            
            guard let data = data else {
                self.balanceInfo.text = "Ошибка: нет данных"
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Any], let result = dict["result"] as? String else {
                    self.balanceInfo.text = "Ошибка: неверный формат JSON"
                    return
                }
                
                DispatchQueue.main.async {
                    if let ethBalance = Double(result) {
                        self.balanceInfo.text = "ETH баланс: \(self.conv(ethBalance))"
                    } else {
                        self.balanceInfo.text = "Введите адрес"
                    }

                }
            } catch {
                self.balanceInfo.text = "Ошибка: \(error.localizedDescription)"
            }
        }.resume()
    }
}

//MARK: - Create BNB Scan
private extension ViewBalance {
    func bnbScan() {
        let screen = UIScreen.main.bounds
        
        backView1.backgroundColor = .yellow.withAlphaComponent(0.3)
        backView1.layer.cornerRadius = 20
        view.addSubview(backView1)
        backView1.translatesAutoresizingMaskIntoConstraints = false
        backView1.snp.makeConstraints { make in
            make.width.equalTo(screen.width - 25)
            make.height.equalTo(140)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backView).inset(-200)
        }
        
        infoView1.backgroundColor = .yellow.withAlphaComponent(0.5)
        infoView1.layer.cornerRadius = 20
        infoView1.translatesAutoresizingMaskIntoConstraints = false
        backView1.addSubview(infoView1)
        infoView1.snp.makeConstraints { make in
            make.width.equalTo(screen.width - 25)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.top.equalTo(backView1).inset(0)
        }
        
        textInput1.textColor = .black
        textInput1.backgroundColor = .white
        textInput1.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textInput1.leftViewMode = .always
        textInput1.layer.cornerRadius = 10
        textInput1.autocorrectionType = .no
        textInput1.attributedPlaceholder = NSAttributedString(
            string: "BNB Scan...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        )
        infoView1.addSubview(textInput1)
        textInput1.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(50)
        }
        
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView1.image = UIImage(named: "bnb")
        imageView1.contentMode = .scaleAspectFit
        infoView1.addSubview(imageView1)
        imageView1.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalTo(textInput1).inset(-60)
        }
        
        buttonCheck1.translatesAutoresizingMaskIntoConstraints = false
        buttonCheck1.backgroundColor = .white
        buttonCheck1.layer.cornerRadius = 25
        buttonCheck1.setImage(UIImage(systemName: "checkmark"), for: .normal)
        buttonCheck1.tintColor = .black
        buttonCheck1.addTarget(self, action: #selector(fetchBalance123), for: .touchUpInside)
        infoView1.addSubview(buttonCheck1)
        buttonCheck1.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.right.equalTo(textInput1).inset(-60)
        }
        
        balanceInfo1.translatesAutoresizingMaskIntoConstraints = false
        balanceInfo1.font = .systemFont(ofSize: 24, weight: .medium)
        balanceInfo1.textColor = .black
        balanceInfo1.numberOfLines = 3
        balanceInfo1.textAlignment = .center
        balanceInfo1.text = ""
        backView1.addSubview(balanceInfo1)
        balanceInfo1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(infoView1).inset(-48)
            make.width.equalTo(backView1)
        }
    }
    
    @objc func fetchBalance123() {
        guard let address = textInput1.text else {
            balanceInfo1.text = "Ошибка: не введен адрес"
            return
        }
        
        let apiURL = "https://api.bscscan.com/api?module=account&action=balance&address=\(address)&apikey=YFQTH726ZNTD4P9GKXHFW2CZWJXWPV2S23"
        
        guard let url = URL(string: apiURL) else {
            balanceInfo1.text = "Ошибка URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.balanceInfo1.text = "Ошибка: \(error.localizedDescription)"
                return
            }
            
            guard let data = data else {
                self.balanceInfo1.text = "Ошибка: нет данных"
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Any], let result = dict["result"] as? String else {
                    self.balanceInfo1.text = "Ошибка: неверный формат JSON"
                    return
                }
                
                DispatchQueue.main.async {
                    if let bscBalance = Double(result) {
                        self.balanceInfo1.text = "BSC баланс: \(self.conv(bscBalance))"
                    } else {
                        self.balanceInfo1.text = "Введите адрес"
                    }

                }
            } catch {
                self.balanceInfo1.text = "Ошибка: \(error.localizedDescription)"
            }
        }.resume()
    }
}


