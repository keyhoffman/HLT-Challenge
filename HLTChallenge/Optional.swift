//
//  OptionalExt.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

extension Optional {
    func toResult() -> Result<Wrapped> {
        guard let x = self else { return Result.init <| OptionalError.nonExistantValue(ofType: self) }
        return Result(x)
    }
    
    func toResult(withError error: Error) -> Result<Wrapped> {
        guard let x = self else { return Result(error) }
        return Result(x)
    }
}

extension Optional {
    func apply<T>(_ f: ((Wrapped) -> T)?) -> T? {
        return f.flatMap { self.map($0) }
    }
}
