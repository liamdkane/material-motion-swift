/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

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

import Foundation
import IndefiniteObservable

/**
 A Spring can pull a value from an initial position to a destination using a physical simulation.

 This class defines the expected shape of a Spring for use in creating a Spring source.
 */
public final class Spring<T: Zeroable> {

  /** Creates a spring with the provided properties and an initial velocity of zero. */
  public convenience init(to destination: ReactiveProperty<T>,
                          initialValue: ReactiveProperty<T>,
                          threshold: CGFloat,
                          source: SpringSource<T>) {
    var velocity: T = T.zero() as! T
    let initialVelocity = ReactiveProperty<T>(read: { velocity }, write: { velocity = $0 })
    self.init(to: destination,
              initialValue: initialValue,
              initialVelocity: initialVelocity,
              threshold: threshold,
              source: source)
  }

  /** Creates a spring with the provided properties and an initial velocity. */
  public init(to destination: ReactiveProperty<T>,
              initialValue: ReactiveProperty<T>,
              initialVelocity: ReactiveProperty<T>,
              threshold: CGFloat,
              source: SpringSource<T>) {
    self.destination = destination
    self.initialValue = initialValue
    self.initialVelocity = initialVelocity

    var threshold = threshold
    self.threshold = ReactiveProperty<CGFloat>(read: { threshold }, write: { threshold = $0 })

    // We must create this intermediary configuration object because we can't pass `self` to a
    // function before `self` has been completely initialized.
    let configuration = SpringConfiguration(destination: self.destination,
                                            initialValue: self.initialValue,
                                            initialVelocity: self.initialVelocity,
                                            tension: self.tension,
                                            friction: self.friction,
                                            threshold: self.threshold)
    // TODO(featherless): Memoize this stream.
    self.valueStream = source(configuration)
  }

  /** The destination value of the spring represented as a property. */
  public let destination: ReactiveProperty<T>

  /** The initial value of the spring represented as a property. */
  public let initialValue: ReactiveProperty<T>

  /** The initial velocity of the spring represented as a property. */
  public let initialVelocity: ReactiveProperty<T>

  /** The tension configuration of the spring represented as a property. */
  public let tension: ReactiveProperty<CGFloat> = createProperty(withInitialValue: defaultSpringTension)

  /** The friction configuration of the spring represented as a property. */
  public let friction: ReactiveProperty<CGFloat> = createProperty(withInitialValue: defaultSpringFriction)

  /** The value used when determining completion of the spring simulation. */
  public let threshold: ReactiveProperty<CGFloat>

  /** The stream of values generated by this spring. */
  public let valueStream: MotionObservable<T>
}

/** The default tension configuration. */
public let defaultSpringTension: CGFloat = 342

/** The default friction configuration. */
public let defaultSpringFriction: CGFloat = 30

/** A SpringConfiguration is meant for use by a SpringConnect implementation. */
public struct SpringConfiguration<T> {
  /** The destination value of the spring represented as a property. */
  public let destination: ReactiveProperty<T>

  /** The initial value of the spring represented as a property. */
  public let initialValue: ReactiveProperty<T>

  /** The initial velocity of the spring represented as a property. */
  public let initialVelocity: ReactiveProperty<T>

  /** The tension configuration of the spring represented as a property. */
  public let tension: ReactiveProperty<CGFloat>

  /** The friction configuration of the spring represented as a property. */
  public let friction: ReactiveProperty<CGFloat>

  /** The value used when determining completion of the spring simulation. */
  public let threshold: ReactiveProperty<CGFloat>
}
