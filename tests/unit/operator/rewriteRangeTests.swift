/*
 Copyright 2017-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest
import MaterialMotion

class rewriteRangeTests: XCTestCase {

  func testOnlyEmitsRewrittenValues() {
    let property = createProperty()

    var values: [CGFloat] = []
    let subscription = property.rewriteRange(start: 0, end: 100, destinationStart: 0, destinationEnd: 1).subscribeToValue { value in
      values.append(value)
    }

    property.value = 50
    property.value = 75
    property.value = 125

    XCTAssertEqual(values, [0, 0.5, 0.75, 1.25])

    subscription.unsubscribe()
  }
}
