//
//  BaseCharacterModel.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import Foundation

public protocol CharacterProtocol: Decodable {
    
    var id: String { get }
    var name: String { get }
    var description: String { get }
    var photo: URL { get }
    
}
