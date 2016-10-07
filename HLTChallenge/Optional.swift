//
//  OptionalExt.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/5/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation

extension Optional where Wrapped: ResultRepresentable {
    func toResult() -> Result<Wrapped> {
        guard let x = self else { return curry(Result.init) <^> OptionalError.nonExistantValue(self) }
        return Result(x)
    }
    
    func toResult(withError error: Error) -> Result<Wrapped> {
        guard let x = self else { return Result(error) }
        return Result(x)
    }
}

