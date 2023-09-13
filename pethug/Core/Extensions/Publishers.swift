//
//  Publishers.swift
//  pethug
//
//  Created by Raul Pena on 12/09/23.
//

import Combine
import FirebaseAuth

extension Publishers {
    struct AuthPublisher: Publisher {
        typealias Output = SessionState
        typealias Failure = Never
        
        func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, SessionState == S.Input {
            let authSubscription = AuthSubscription(subscriber: subscriber)
            subscriber.receive(subscription: authSubscription)
        }
    }
    
    class AuthSubscription<S: Subscriber>: Subscription where S.Input == SessionState, S.Failure == Never {
        private var subscriber: S?
        private var handler: AuthStateDidChangeListenerHandle?
        
        init(subscriber: S) {
            self.subscriber = subscriber
            
            // Starts the auth listener and assign it to the handler
            self.handler = Auth.auth().addStateDidChangeListener { _, user in
                
                // if user exists
                if let user {
                    print("REVISA SI EL USER ESTA LOGEADO O NO: => true")
                    // check if email is verified and return state
                    _ = subscriber.receive(user.isEmailVerified ? .signedIn : .signedInButNotVerified)
                } else {
                    print("REVISA SI EL USER ESTA LOGEADO O NO: => false")
                    // if not user
                    _ = subscriber.receive(.signedOut)
                }
            }
        }
        
        func request(_: Subscribers.Demand) {}
        
        // remove both the handler and the subscriptions when cancelled
        func cancel() {
            subscriber = nil
            handler = nil
        }
    }
}
