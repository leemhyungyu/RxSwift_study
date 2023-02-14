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

/*:
 # withLatestFrom
 */
// withLatestFrom:
// 형식: triggerObservable.withLatestFrom(dataObservable)
// --> triggerObservable이 Next이벤트를 방출하면 dataObservable이 가장 최근에 발생한 Next이벤트를 구독자에게 전달
// --> ex) 회원가입 버튼을 클릭하는 시점에 텍스트에 입력된 값을 가져오는 기능을 구현할때 활용할 수 있음

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

trigger.withLatestFrom(data)
    .subscribe { print($0) }
    .disposed(by: bag)


data.onNext("Hello") // 아직 triggerSubject가 Next이벤트를 전달하지 않았기 때문에 구독자에게 전달되지 않음
trigger.onNext(()) // 해당 시점에 dataSuject가 전달한 Next이벤트가 구독자에게 전달됨
trigger.onNext(()) // 동일한 이벤트가 반복적으로 구독자에게 전달됨

data.onCompleted()
trigger.onNext(()) // dataSubject가 마지막으로 전달한 이벤트는 completed이벤트 이지만 마지막으로 전달된 Next이벤트가 구독자에게 전달됨

trigger.onCompleted() // triggerSuject만 Completed이벤트를 방출하면 바로 종료됨 (error도 동일)

data.onError(MyError.error) // 바로 구독자에게 전달






