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
    Binding에는 데이터 생산자(Observable)와 데이터 소비자(UI Component)가 있음
    --> 생산자가 생산한 데이터는 소비자에게 전달되고 소비자는 적절한 방식으로 데이터 소비 ex) Label은 전달받은 데이터를 화면에 표시
    --> Binder는 바인딩에 사용하는 특별한 Observer (데이터 소비자)
    --> Observable이 아니므로 구독자를 추가하는 것은 불가능
    --> Error이벤트를 받지 않음
    --> Main Thread에서 UI 코드 수행
    --> Binder는 bind가 메인 쓰레드에서 실행되는 것을 보장
 */

class BindingRxCocoaViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = ""
        valueField.becomeFirstResponder()



        /*
         아래의 코드처럼 RxCocoa을 사용해 코드를 구현하면
         text필드에 입력된 값이 업데이트될때마다 next이벤트로 전달되고
         delegate 구현할 필요 X, 최종 문자열을 조합할 코드도 필요 X, 코드만으로 데이터 흐름 쉽게 파악 가능
         
         그러나 코드에 따라서 백그라운드에서 실행될 가능성이 있음
         --> GCD or observe 메소드 사용해 메인쓰레드로 지정해야함
         */

        valueField.rx.text // ControlProperty는 Observable이면서 Observer이므로 구독가능
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] str in

                self?.valueLabel.text = str

            })
            .disposed(by: disposeBag)
        
        // bind연산자쓰면 메인 쓰레드에서 실행되는 것을 보장
        // text를 입력하면 value.rx.text속성이 입력한 값을 담아서 Next이벤트 방출
        valueField.rx.text
            .bind(to: valueLabel.rx.text) // bind는 Ovservable이 방출한 이벤트를 Observer에게 전달
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        valueField.resignFirstResponder()
    }
}

/*
 Traits: UI에 특화된 Observable, UI바인딩에서 데이터 생산자 역할을 수행
 --> 모든 작업은 메인 쓰레드에서 실행
 --> UI 업데이트 코드를 작성할 떄 스케줄러 지정 필요 없음
 --> Error 이벤트를 전달하지 않아서 UI가 항상 올바른 쓰레드에서 업데이트 되는 것을 보장
 --> Observable을 구독하는 구독자들이 여러개 있어도 각각의 시퀀스를 제공하지 않고 동일한 시퀀스를 공유함
 --> Tarits는 선택의 영역, UI구현에 있어서는 쓰는게 좋다.
 4가지 Traits 제공
 - ControlProperty
 - ControlEvent
 - Driver
 - Siganl
 
 */
