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
 # concatMap
 */
// concatMap: Interleaving없이 항상 방출 순서 보장
// -> innerObservable을 생성된 순서대로 연결
// -> 앞에 innerObservable이 이벤트 방출을 끝내면 이어지는 innerObservable에서 이벤트 방출 시작
// -> 원본 Observable이 방출하는 이벤트 순서와 innerObservable이 방출하는 이벤트 순서가 동일함을 보장
let disposeBag = DisposeBag()

let redCircle = "🔴"
let greenCircle = "🟢"
let blueCircle = "🔵"

let redHeart = "❤️"
let greenHeart = "💚"
let blueHeart = "💙"

Observable.from([redCircle, greenCircle, blueCircle])
    .concatMap { circle -> Observable<String> in
        switch circle {
        case redCircle:
            return Observable.repeatElement(redHeart)
                .take(5)
        case greenCircle:
            return Observable.repeatElement(greenHeart)
                .take(5)
        case blueCircle:
            return Observable.repeatElement(blueHeart)
                .take(5)
        default:
            return Observable.just("")
        }
    }
    .subscribe { print($0) }
    .disposed(by: disposeBag)


/*
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(❤️)
 next(💚)
 next(💚)
 next(💚)
 next(💚)
 next(💚)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 next(💙)
 completed
 */









