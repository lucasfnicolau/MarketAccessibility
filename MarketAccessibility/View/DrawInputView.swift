//
//  DrawInputView.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name
// swiftlint:disable cyclomatic_complexity

import UIKit
import SpriteKit
import GameplayKit
import CoreData

class DrawInputView: UIView {
    
    private var loadedTemplates: [SwiftUnistrokeTemplate] = []
    private var templateViews: [StrokeView] = []
    
    var ceduleDrawView: StrokeView!
    var coinDrawView: StrokeView!
    var cedulesArray = [String]()
    var coinsArray = [String]()
    var templates = [JSONTemplate]()
    var appHasBeenOpenedBefore = false
    var defaults: UserDefaults?
    weak var shoppingVCDelegate: ShoppingVCDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        loadTemplates()
        
        ceduleDrawView = StrokeView(frame: .zero)
        coinDrawView = StrokeView(frame: .zero)
        set(drawView: ceduleDrawView)
        set(drawView: coinDrawView)
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setConstraints() {
        let commaLabel = UILabel(frame: .zero)
        commaLabel.text = ","
        commaLabel.font = commaLabel.font.withSize(80)
        commaLabel.textColor = UIColor.App.shopping
        commaLabel.isAccessibilityElement = false
        
        let stackView = UIStackView(arrangedSubviews: [
            ceduleDrawView, commaLabel, coinDrawView
            ])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        ceduleDrawView.translatesAutoresizingMaskIntoConstraints = false
        commaLabel.translatesAutoresizingMaskIntoConstraints = false
        coinDrawView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            ceduleDrawView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5),
            ceduleDrawView.topAnchor.constraint(equalTo: stackView.topAnchor),
            ceduleDrawView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            coinDrawView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.5),
            coinDrawView.topAnchor.constraint(equalTo: stackView.topAnchor),
            coinDrawView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        
            ])
    }
    
    func set(drawView: StrokeView) {
        
        let drawImageView = UIImageView(frame: .zero)
        drawImageView.image = #imageLiteral(resourceName: "btn_draw_filled")
        drawImageView.alpha = 0.0
        drawView.addSubview(drawImageView)
        
        drawImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawImageView.centerXAnchor.constraint(equalTo: drawView.centerXAnchor),
            drawImageView.centerYAnchor.constraint(equalTo: drawView.centerYAnchor),
            drawImageView.widthAnchor.constraint(equalToConstant: 50),
            drawImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        fadeInAndOut(view: drawImageView)
        
        drawView.onDidFinishDrawing = { drawnPoints in
            guard let drawnPoints = drawnPoints else { return }
            
            if drawnPoints.count < 5 {
                return
            }
            
            let strokeRecognizer = OneDollar(points: drawnPoints)
            do {
                let (template, _) = try strokeRecognizer.recognizeIn(templates: self.loadedTemplates,
                                                                     useProtractor: false, minThreshold: 0.80)
                
                if drawView == self.ceduleDrawView {
                    if !self.cedulesArray.isEmpty || template?.name != Number.zero.rawValue {
                        self.cedulesArray.append(getNumberFrom(string: template?.name ?? Number.zero.rawValue))
                        
                        self.ceduleDrawView.resetPoints()
                    }
                } else {
                    if self.coinsArray.count < 2 {
                        self.coinsArray.append(getNumberFrom(string: template?.name ?? Number.zero.rawValue))
                        
                        self.coinDrawView.resetPoints()
                    }
                }
                self.calculateValue()
                
            } catch let error as NSError {
//                self.recognizedLabel.text = "-"
                print(error.localizedDescription)
            }
            
        }
        
        drawView.drawPath = UIBezierPath()
    }
    
    func calculateValue() {
        var value = "R$ "
        
        for cedule in cedulesArray {
            value += cedule
        }
        value += ","
        for coin in coinsArray {
            value += coin
        }
        
        shoppingVCDelegate.updateLabel(withValue: value)
    }
    
    func loadTemplates() {
        defaults = UserDefaults()
        guard let defaults = defaults else { return }
        appHasBeenOpenedBefore = defaults.bool(forKey: Key.appHasBeenOpenedBefore.rawValue)
        
        if !appHasBeenOpenedBefore {
            for template in originalTemplates {
                guard let jsonModel = NSEntityDescription.insertNewObject(
                    forEntityName: Entity.jsonTemplate.rawValue,
                    into: getContext()) as? JSONTemplate else { return }
                jsonModel.content = template
                saveContext()
            }
            defaults.set(true, forKey: Key.appHasBeenOpenedBefore.rawValue)
        }
        
        loadedTemplates = []
        
        do {
            templates = try getContext().fetch(JSONTemplate.fetchRequest())
            
            for template in templates {
                guard let content = template.content else { return }
                guard let data = content.data(using: .utf8) else { return }
                guard let templateDict = try JSONSerialization
                    .jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    as? NSDictionary else { return }
                
                guard let templateDictName = templateDict["name"] else { return }
                guard let templateName = templateDictName as? String else { return }
                
                guard let templateDictPoints = templateDict["points"] else { return }
                guard let templateRawPoints: [AnyObject] = templateDictPoints as? [AnyObject] else { return }
                
                var templatePoints: [StrokePoint] = []
                for rawPoint in templateRawPoints {
                    guard let rawPoint = rawPoint as? [AnyObject] else { return }
                    guard let first = rawPoint.first else { return }
                    guard let last = rawPoint.last else { return }
                    
                    guard let x = first as? Float else { return }
                    guard let y = last as? Float else { return }
                    templatePoints.append(StrokePoint(x: x, y: y))
                }
                
                let templateObj = SwiftUnistrokeTemplate(name: templateName, points: templatePoints)
                loadedTemplates.append(templateObj)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fadeInAndOut(view: UIView) {
        UIView.animate(withDuration: 0.75, delay: 0.25, options: [], animations: {
            view.alpha = 1.0
        }, completion: { (_) in
            UIView.animate(withDuration: 0.75, animations: {
                view.alpha = 0.0
            }, completion: { (_) in
                view.removeFromSuperview()
            })
        })
    }
}
