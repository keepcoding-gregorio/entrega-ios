//
//  CharacterModel.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import Foundation

public struct CharacterModel: CharacterProtocol {

    public let id: String
    public let name: String
    public let description: String
    public let photo: URL
    public let favorite: Bool
    
}
