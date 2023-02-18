//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import RxSwift
import RxCocoa

/*
 ControlProperty는 ControlPorpertyType을 채용하고
 ControlPropertyType은 ObservableType과 ObserverType 채용함
 즉, 특별한 Observable이면서 동시에 특별한 Observer
 --> ControlProperty가 읽기 전용 속성을 확장했다면 Observable역할만 수행
 --> ControlProperty가 읽기 쓰기가 모두 가능하다면 Observer의 역할도 함께 수행
 --> ControlProperty는 UI Binding에 사용되므로 Error이벤트를 전달받지도 전달하지도 않음
 --> 모든 이벤트는 메인 스케줄러에서 전달
 --> ControlProperty는 시퀀스를 공유함, 일반 Observable에서 share(replay: 1)과 동일한 기능 수행

 ControlEvent는 ControlEventType을 채용하고
 ControlEventType은 ObservableType 채용함
 --> Observable의 역할은 수행하지만 Observer의 역할 수행 X
 --> 에러 이벤트 전달 X
 --> 메인 스케줄러에서 이벤트 전달
 --> ControlProperty와 달리 가장 최근의 이벤트를 replay하지 않기 때문에 새로운 구독자는 구독 이후에 전달된 이벤트만 전달받음
 */

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redComponentLabel: UILabel!
    @IBOutlet weak var greenComponentLabel: UILabel!
    @IBOutlet weak var blueComponentLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: redComponentLabel.rx.text)
            .disposed(by: bag)
        
        greenSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: bag)
        
        blueSlider.rx.value
            .map { "\(Int($0))" }
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: bag)
        
        // 슬라이더를 드래그 할 때마다 모든 슬라디어의 value값이 하나의 배열로 방출
//        Observable.combineLatest([redSlider.rx.value, greenSlider.rx.value, blueSlider.rx.value])
//            .map { UIColor(red: CGFloat($0[0]) / 255, green: CGFloat($0[1]) / 255, blue: CGFloat($0[2]) / 255, alpha: 1.0) }
//            .bind(to: colorView.rx.backgroundColor)
//            .disposed(by: bag)
        
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.colorView.backgroundColor = UIColor.black
                self?.redSlider.value = 0
                self?.greenSlider.value = 0
                self?.blueSlider.value = 0
                self?.updateComponentLabel()
            })
            .disposed(by: bag)
    }
}
