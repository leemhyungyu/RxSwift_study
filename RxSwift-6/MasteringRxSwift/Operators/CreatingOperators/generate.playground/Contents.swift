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
 # generate
 */

let disposeBag = DisposeBag()
let red = "๐ด"
let blue = "๐ต"

// initialState: ์์๊ฐ (๊ฐ์ฅ ๋จผ์  ๋ฐฉ์ถ๋๋ ๊ฐ)
// condition: true๋ฅผ ๋ฆฌํดํ๋ ๊ฐ๋ง ๋ฐฉ์ถ, false์ ๋ฆฌํดํ๋ฉด completed ์ด๋ฒคํธ ์ ๋ฌํ๊ณ  ์ข๋ฃ
// iterate: ๊ฐ์ ๋ฐ๊พธ๋ ์ฝ๋

// 10๋ณด๋ค ์๊ฑฐ๋ ๊ฐ์ ์ง์๋ง ๋ฐฉ์ถํ๋ Observable
Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 10์์ 2์ฉ ๊ฐ์ํ๋ Observable
Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2 })
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// ๋ฌธ์์ด์ ๊ธธ์ด๊ฐ 15๋ฅผ ๋์ง ์๊ณ  red์ blue๋ฅผ ๋ฒ๊ฐ์ ์ถ๊ฐํด ๋ง๋ค์ด์ง ๋ฌธ์์ด์ ๋ฐฉ์ถํ๋ Observable
Observable.generate(initialState: red, condition: { $0.count < 15 }, iterate: { $0.count.isMultiple(of: 2) ? $0 + red : $0 + blue})
    .subscribe { print($0) }
    .disposed(by: disposeBag)



